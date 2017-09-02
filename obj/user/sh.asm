
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 b5 09 00 00       	call   8009e6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	83 ec 1c             	sub    $0x1c,%esp
  800049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int t;

	if (s == 0) {
  80004f:	85 db                	test   %ebx,%ebx
  800051:	75 28                	jne    80007b <_gettoken+0x3b>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
  800053:	b8 00 00 00 00       	mov    $0x0,%eax
_gettoken(char *s, char **p1, char **p2)
{
	int t;

	if (s == 0) {
		if (debug > 1)
  800058:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80005f:	0f 8e 33 01 00 00    	jle    800198 <_gettoken+0x158>
			cprintf("GETTOKEN NULL\n");
  800065:	c7 04 24 a0 3b 80 00 	movl   $0x803ba0,(%esp)
  80006c:	e8 d9 0a 00 00       	call   800b4a <cprintf>
		return 0;
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	e9 1d 01 00 00       	jmp    800198 <_gettoken+0x158>
	}

	if (debug > 1)
  80007b:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800082:	7e 10                	jle    800094 <_gettoken+0x54>
		cprintf("GETTOKEN: %s\n", s);
  800084:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800088:	c7 04 24 af 3b 80 00 	movl   $0x803baf,(%esp)
  80008f:	e8 b6 0a 00 00       	call   800b4a <cprintf>

	*p1 = 0;
  800094:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	*p2 = 0;
  80009a:	8b 45 10             	mov    0x10(%ebp),%eax
  80009d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  8000a3:	eb 07                	jmp    8000ac <_gettoken+0x6c>
		*s++ = 0;
  8000a5:	83 c3 01             	add    $0x1,%ebx
  8000a8:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8000ac:	0f be 03             	movsbl (%ebx),%eax
  8000af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b3:	c7 04 24 bd 3b 80 00 	movl   $0x803bbd,(%esp)
  8000ba:	e8 bb 12 00 00       	call   80137a <strchr>
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	75 e2                	jne    8000a5 <_gettoken+0x65>
  8000c3:	89 df                	mov    %ebx,%edi
		*s++ = 0;
	if (*s == 0) {
  8000c5:	0f b6 03             	movzbl (%ebx),%eax
  8000c8:	84 c0                	test   %al,%al
  8000ca:	75 28                	jne    8000f4 <_gettoken+0xb4>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000cc:	b8 00 00 00 00       	mov    $0x0,%eax
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
		*s++ = 0;
	if (*s == 0) {
		if (debug > 1)
  8000d1:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  8000d8:	0f 8e ba 00 00 00    	jle    800198 <_gettoken+0x158>
			cprintf("EOL\n");
  8000de:	c7 04 24 c2 3b 80 00 	movl   $0x803bc2,(%esp)
  8000e5:	e8 60 0a 00 00       	call   800b4a <cprintf>
		return 0;
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	e9 a4 00 00 00       	jmp    800198 <_gettoken+0x158>
	}
	if (strchr(SYMBOLS, *s)) {
  8000f4:	0f be c0             	movsbl %al,%eax
  8000f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000fb:	c7 04 24 d3 3b 80 00 	movl   $0x803bd3,(%esp)
  800102:	e8 73 12 00 00       	call   80137a <strchr>
  800107:	85 c0                	test   %eax,%eax
  800109:	74 2f                	je     80013a <_gettoken+0xfa>
		t = *s;
  80010b:	0f be 1b             	movsbl (%ebx),%ebx
		*p1 = s;
  80010e:	89 3e                	mov    %edi,(%esi)
		*s++ = 0;
  800110:	c6 07 00             	movb   $0x0,(%edi)
  800113:	83 c7 01             	add    $0x1,%edi
  800116:	8b 45 10             	mov    0x10(%ebp),%eax
  800119:	89 38                	mov    %edi,(%eax)
		*p2 = s;
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
  80011b:	89 d8                	mov    %ebx,%eax
	if (strchr(SYMBOLS, *s)) {
		t = *s;
		*p1 = s;
		*s++ = 0;
		*p2 = s;
		if (debug > 1)
  80011d:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800124:	7e 72                	jle    800198 <_gettoken+0x158>
			cprintf("TOK %c\n", t);
  800126:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80012a:	c7 04 24 c7 3b 80 00 	movl   $0x803bc7,(%esp)
  800131:	e8 14 0a 00 00       	call   800b4a <cprintf>
		return t;
  800136:	89 d8                	mov    %ebx,%eax
  800138:	eb 5e                	jmp    800198 <_gettoken+0x158>
	}
	*p1 = s;
  80013a:	89 1e                	mov    %ebx,(%esi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80013c:	eb 03                	jmp    800141 <_gettoken+0x101>
		s++;
  80013e:	83 c3 01             	add    $0x1,%ebx
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800141:	0f b6 03             	movzbl (%ebx),%eax
  800144:	84 c0                	test   %al,%al
  800146:	74 17                	je     80015f <_gettoken+0x11f>
  800148:	0f be c0             	movsbl %al,%eax
  80014b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014f:	c7 04 24 cf 3b 80 00 	movl   $0x803bcf,(%esp)
  800156:	e8 1f 12 00 00       	call   80137a <strchr>
  80015b:	85 c0                	test   %eax,%eax
  80015d:	74 df                	je     80013e <_gettoken+0xfe>
		s++;
	*p2 = s;
  80015f:	8b 45 10             	mov    0x10(%ebp),%eax
  800162:	89 18                	mov    %ebx,(%eax)
		t = **p2;
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
  800164:	b8 77 00 00 00       	mov    $0x77,%eax
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
		s++;
	*p2 = s;
	if (debug > 1) {
  800169:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800170:	7e 26                	jle    800198 <_gettoken+0x158>
		t = **p2;
  800172:	0f b6 3b             	movzbl (%ebx),%edi
		**p2 = 0;
  800175:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  800178:	8b 06                	mov    (%esi),%eax
  80017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017e:	c7 04 24 db 3b 80 00 	movl   $0x803bdb,(%esp)
  800185:	e8 c0 09 00 00       	call   800b4a <cprintf>
		**p2 = t;
  80018a:	8b 45 10             	mov    0x10(%ebp),%eax
  80018d:	8b 00                	mov    (%eax),%eax
  80018f:	89 fa                	mov    %edi,%edx
  800191:	88 10                	mov    %dl,(%eax)
	}
	return 'w';
  800193:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800198:	83 c4 1c             	add    $0x1c,%esp
  80019b:	5b                   	pop    %ebx
  80019c:	5e                   	pop    %esi
  80019d:	5f                   	pop    %edi
  80019e:	5d                   	pop    %ebp
  80019f:	c3                   	ret    

008001a0 <gettoken>:

int
gettoken(char *s, char **p1)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
  8001a6:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	74 24                	je     8001d1 <gettoken+0x31>
		nc = _gettoken(s, &np1, &np2);
  8001ad:	c7 44 24 08 0c 60 80 	movl   $0x80600c,0x8(%esp)
  8001b4:	00 
  8001b5:	c7 44 24 04 10 60 80 	movl   $0x806010,0x4(%esp)
  8001bc:	00 
  8001bd:	89 04 24             	mov    %eax,(%esp)
  8001c0:	e8 7b fe ff ff       	call   800040 <_gettoken>
  8001c5:	a3 08 60 80 00       	mov    %eax,0x806008
		return 0;
  8001ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cf:	eb 3c                	jmp    80020d <gettoken+0x6d>
	}
	c = nc;
  8001d1:	a1 08 60 80 00       	mov    0x806008,%eax
  8001d6:	a3 04 60 80 00       	mov    %eax,0x806004
	*p1 = np1;
  8001db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001de:	8b 15 10 60 80 00    	mov    0x806010,%edx
  8001e4:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001e6:	c7 44 24 08 0c 60 80 	movl   $0x80600c,0x8(%esp)
  8001ed:	00 
  8001ee:	c7 44 24 04 10 60 80 	movl   $0x806010,0x4(%esp)
  8001f5:	00 
  8001f6:	a1 0c 60 80 00       	mov    0x80600c,%eax
  8001fb:	89 04 24             	mov    %eax,(%esp)
  8001fe:	e8 3d fe ff ff       	call   800040 <_gettoken>
  800203:	a3 08 60 80 00       	mov    %eax,0x806008
	return c;
  800208:	a1 04 60 80 00       	mov    0x806004,%eax
}
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    

0080020f <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	57                   	push   %edi
  800213:	56                   	push   %esi
  800214:	53                   	push   %ebx
  800215:	81 ec 6c 04 00 00    	sub    $0x46c,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);
  80021b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800222:	00 
  800223:	8b 45 08             	mov    0x8(%ebp),%eax
  800226:	89 04 24             	mov    %eax,(%esp)
  800229:	e8 72 ff ff ff       	call   8001a0 <gettoken>

again:
	argc = 0;
  80022e:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		switch ((c = gettoken(0, &t))) {
  800233:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
  800236:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80023a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800241:	e8 5a ff ff ff       	call   8001a0 <gettoken>
  800246:	83 f8 3e             	cmp    $0x3e,%eax
  800249:	0f 84 b0 00 00 00    	je     8002ff <runcmd+0xf0>
  80024f:	83 f8 3e             	cmp    $0x3e,%eax
  800252:	7f 13                	jg     800267 <runcmd+0x58>
  800254:	85 c0                	test   %eax,%eax
  800256:	0f 84 31 02 00 00    	je     80048d <runcmd+0x27e>
  80025c:	83 f8 3c             	cmp    $0x3c,%eax
  80025f:	90                   	nop
  800260:	74 3d                	je     80029f <runcmd+0x90>
  800262:	e9 06 02 00 00       	jmp    80046d <runcmd+0x25e>
  800267:	83 f8 77             	cmp    $0x77,%eax
  80026a:	74 0f                	je     80027b <runcmd+0x6c>
  80026c:	83 f8 7c             	cmp    $0x7c,%eax
  80026f:	90                   	nop
  800270:	0f 84 0a 01 00 00    	je     800380 <runcmd+0x171>
  800276:	e9 f2 01 00 00       	jmp    80046d <runcmd+0x25e>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  80027b:	83 fe 10             	cmp    $0x10,%esi
  80027e:	66 90                	xchg   %ax,%ax
  800280:	75 11                	jne    800293 <runcmd+0x84>
				cprintf("too many arguments\n");
  800282:	c7 04 24 e5 3b 80 00 	movl   $0x803be5,(%esp)
  800289:	e8 bc 08 00 00       	call   800b4a <cprintf>
				exit();
  80028e:	e8 a5 07 00 00       	call   800a38 <exit>
			}
			argv[argc++] = t;
  800293:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800296:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  80029a:	8d 76 01             	lea    0x1(%esi),%esi
			break;
  80029d:	eb 97                	jmp    800236 <runcmd+0x27>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80029f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002aa:	e8 f1 fe ff ff       	call   8001a0 <gettoken>
  8002af:	83 f8 77             	cmp    $0x77,%eax
  8002b2:	74 11                	je     8002c5 <runcmd+0xb6>
				cprintf("syntax error: < not followed by word\n");
  8002b4:	c7 04 24 24 3d 80 00 	movl   $0x803d24,(%esp)
  8002bb:	e8 8a 08 00 00       	call   800b4a <cprintf>
				exit();
  8002c0:	e8 73 07 00 00       	call   800a38 <exit>
			// so open the file as 'fd',
			// then check whether 'fd' is 0.
			// If not, dup 'fd' onto file descriptor 0,
			// then close the original 'fd'.

			fd = open(t,O_RDONLY);
  8002c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002cc:	00 
  8002cd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002d0:	89 04 24             	mov    %eax,(%esp)
  8002d3:	e8 7b 23 00 00       	call   802653 <open>
  8002d8:	89 c7                	mov    %eax,%edi
			if(fd!=0)
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	0f 84 54 ff ff ff    	je     800236 <runcmd+0x27>
			{
				dup(fd,0);
  8002e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002e9:	00 
  8002ea:	89 04 24             	mov    %eax,(%esp)
  8002ed:	e8 7a 1d 00 00       	call   80206c <dup>
				close(fd);
  8002f2:	89 3c 24             	mov    %edi,(%esp)
  8002f5:	e8 1d 1d 00 00       	call   802017 <close>
  8002fa:	e9 37 ff ff ff       	jmp    800236 <runcmd+0x27>
			//panic("< redirection not implemented");
			break;

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8002ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800303:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80030a:	e8 91 fe ff ff       	call   8001a0 <gettoken>
  80030f:	83 f8 77             	cmp    $0x77,%eax
  800312:	74 11                	je     800325 <runcmd+0x116>
				cprintf("syntax error: > not followed by word\n");
  800314:	c7 04 24 4c 3d 80 00 	movl   $0x803d4c,(%esp)
  80031b:	e8 2a 08 00 00       	call   800b4a <cprintf>
				exit();
  800320:	e8 13 07 00 00       	call   800a38 <exit>
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800325:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  80032c:	00 
  80032d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800330:	89 04 24             	mov    %eax,(%esp)
  800333:	e8 1b 23 00 00       	call   802653 <open>
  800338:	89 c7                	mov    %eax,%edi
  80033a:	85 c0                	test   %eax,%eax
  80033c:	79 1c                	jns    80035a <runcmd+0x14b>
				cprintf("open %s for write: %e", t, fd);
  80033e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800342:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800345:	89 44 24 04          	mov    %eax,0x4(%esp)
  800349:	c7 04 24 f9 3b 80 00 	movl   $0x803bf9,(%esp)
  800350:	e8 f5 07 00 00       	call   800b4a <cprintf>
				exit();
  800355:	e8 de 06 00 00       	call   800a38 <exit>
			}
			if (fd != 1) {
  80035a:	83 ff 01             	cmp    $0x1,%edi
  80035d:	0f 84 d3 fe ff ff    	je     800236 <runcmd+0x27>
				dup(fd, 1);
  800363:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80036a:	00 
  80036b:	89 3c 24             	mov    %edi,(%esp)
  80036e:	e8 f9 1c 00 00       	call   80206c <dup>
				close(fd);
  800373:	89 3c 24             	mov    %edi,(%esp)
  800376:	e8 9c 1c 00 00       	call   802017 <close>
  80037b:	e9 b6 fe ff ff       	jmp    800236 <runcmd+0x27>
			}
			break;

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  800380:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  800386:	89 04 24             	mov    %eax,(%esp)
  800389:	e8 a6 31 00 00       	call   803534 <pipe>
  80038e:	85 c0                	test   %eax,%eax
  800390:	79 15                	jns    8003a7 <runcmd+0x198>
				cprintf("pipe: %e", r);
  800392:	89 44 24 04          	mov    %eax,0x4(%esp)
  800396:	c7 04 24 0f 3c 80 00 	movl   $0x803c0f,(%esp)
  80039d:	e8 a8 07 00 00       	call   800b4a <cprintf>
				exit();
  8003a2:	e8 91 06 00 00       	call   800a38 <exit>
			}
			if (debug)
  8003a7:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8003ae:	74 20                	je     8003d0 <runcmd+0x1c1>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  8003b0:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  8003b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ba:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8003c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c4:	c7 04 24 18 3c 80 00 	movl   $0x803c18,(%esp)
  8003cb:	e8 7a 07 00 00       	call   800b4a <cprintf>
			if ((r = fork()) < 0) {
  8003d0:	e8 e1 16 00 00       	call   801ab6 <fork>
  8003d5:	89 c7                	mov    %eax,%edi
  8003d7:	85 c0                	test   %eax,%eax
  8003d9:	79 15                	jns    8003f0 <runcmd+0x1e1>
				cprintf("fork: %e", r);
  8003db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003df:	c7 04 24 25 3c 80 00 	movl   $0x803c25,(%esp)
  8003e6:	e8 5f 07 00 00       	call   800b4a <cprintf>
				exit();
  8003eb:	e8 48 06 00 00       	call   800a38 <exit>
			}
			if (r == 0) {
  8003f0:	85 ff                	test   %edi,%edi
  8003f2:	75 40                	jne    800434 <runcmd+0x225>
				if (p[0] != 0) {
  8003f4:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8003fa:	85 c0                	test   %eax,%eax
  8003fc:	74 1e                	je     80041c <runcmd+0x20d>
					dup(p[0], 0);
  8003fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800405:	00 
  800406:	89 04 24             	mov    %eax,(%esp)
  800409:	e8 5e 1c 00 00       	call   80206c <dup>
					close(p[0]);
  80040e:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800414:	89 04 24             	mov    %eax,(%esp)
  800417:	e8 fb 1b 00 00       	call   802017 <close>
				}
				close(p[1]);
  80041c:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800422:	89 04 24             	mov    %eax,(%esp)
  800425:	e8 ed 1b 00 00       	call   802017 <close>

	pipe_child = 0;
	gettoken(s, 0);

again:
	argc = 0;
  80042a:	be 00 00 00 00       	mov    $0x0,%esi
				if (p[0] != 0) {
					dup(p[0], 0);
					close(p[0]);
				}
				close(p[1]);
				goto again;
  80042f:	e9 02 fe ff ff       	jmp    800236 <runcmd+0x27>
			} else {
				pipe_child = r;
				if (p[1] != 1) {
  800434:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80043a:	83 f8 01             	cmp    $0x1,%eax
  80043d:	74 1e                	je     80045d <runcmd+0x24e>
					dup(p[1], 1);
  80043f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800446:	00 
  800447:	89 04 24             	mov    %eax,(%esp)
  80044a:	e8 1d 1c 00 00       	call   80206c <dup>
					close(p[1]);
  80044f:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800455:	89 04 24             	mov    %eax,(%esp)
  800458:	e8 ba 1b 00 00       	call   802017 <close>
				}
				close(p[0]);
  80045d:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800463:	89 04 24             	mov    %eax,(%esp)
  800466:	e8 ac 1b 00 00       	call   802017 <close>
				goto runit;
  80046b:	eb 25                	jmp    800492 <runcmd+0x283>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  80046d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800471:	c7 44 24 08 2e 3c 80 	movl   $0x803c2e,0x8(%esp)
  800478:	00 
  800479:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
  800480:	00 
  800481:	c7 04 24 4a 3c 80 00 	movl   $0x803c4a,(%esp)
  800488:	e8 c4 05 00 00       	call   800a51 <_panic>
runcmd(char* s)
{
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  80048d:	bf 00 00 00 00       	mov    $0x0,%edi
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  800492:	85 f6                	test   %esi,%esi
  800494:	75 1e                	jne    8004b4 <runcmd+0x2a5>
		if (debug)
  800496:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80049d:	0f 84 85 01 00 00    	je     800628 <runcmd+0x419>
			cprintf("EMPTY COMMAND\n");
  8004a3:	c7 04 24 54 3c 80 00 	movl   $0x803c54,(%esp)
  8004aa:	e8 9b 06 00 00       	call   800b4a <cprintf>
  8004af:	e9 74 01 00 00       	jmp    800628 <runcmd+0x419>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  8004b4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004b7:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004ba:	74 22                	je     8004de <runcmd+0x2cf>
		argv0buf[0] = '/';
  8004bc:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  8004c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c7:	8d 9d a4 fb ff ff    	lea    -0x45c(%ebp),%ebx
  8004cd:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  8004d3:	89 04 24             	mov    %eax,(%esp)
  8004d6:	e8 8c 0d 00 00       	call   801267 <strcpy>
		argv[0] = argv0buf;
  8004db:	89 5d a8             	mov    %ebx,-0x58(%ebp)
	}
	argv[argc] = 0;
  8004de:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  8004e5:	00 

	// Print the command.
	if (debug) {
  8004e6:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004ed:	74 43                	je     800532 <runcmd+0x323>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8004ef:	a1 28 64 80 00       	mov    0x806428,%eax
  8004f4:	8b 40 48             	mov    0x48(%eax),%eax
  8004f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004fb:	c7 04 24 63 3c 80 00 	movl   $0x803c63,(%esp)
  800502:	e8 43 06 00 00       	call   800b4a <cprintf>
  800507:	8d 5d a8             	lea    -0x58(%ebp),%ebx
		for (i = 0; argv[i]; i++)
  80050a:	eb 10                	jmp    80051c <runcmd+0x30d>
			cprintf(" %s", argv[i]);
  80050c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800510:	c7 04 24 ee 3c 80 00 	movl   $0x803cee,(%esp)
  800517:	e8 2e 06 00 00       	call   800b4a <cprintf>
  80051c:	83 c3 04             	add    $0x4,%ebx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  80051f:	8b 43 fc             	mov    -0x4(%ebx),%eax
  800522:	85 c0                	test   %eax,%eax
  800524:	75 e6                	jne    80050c <runcmd+0x2fd>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  800526:	c7 04 24 c0 3b 80 00 	movl   $0x803bc0,(%esp)
  80052d:	e8 18 06 00 00       	call   800b4a <cprintf>
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800532:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800535:	89 44 24 04          	mov    %eax,0x4(%esp)
  800539:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80053c:	89 04 24             	mov    %eax,(%esp)
  80053f:	e8 ec 22 00 00       	call   802830 <spawn>
  800544:	89 c3                	mov    %eax,%ebx
  800546:	85 c0                	test   %eax,%eax
  800548:	0f 89 c3 00 00 00    	jns    800611 <runcmd+0x402>
		cprintf("spawn %s: %e\n", argv[0], r);
  80054e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800552:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800555:	89 44 24 04          	mov    %eax,0x4(%esp)
  800559:	c7 04 24 71 3c 80 00 	movl   $0x803c71,(%esp)
  800560:	e8 e5 05 00 00       	call   800b4a <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  800565:	e8 e0 1a 00 00       	call   80204a <close_all>
  80056a:	eb 4c                	jmp    8005b8 <runcmd+0x3a9>
	if (r >= 0) {
		if (debug)
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  80056c:	a1 28 64 80 00       	mov    0x806428,%eax
  800571:	8b 40 48             	mov    0x48(%eax),%eax
  800574:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800578:	8b 55 a8             	mov    -0x58(%ebp),%edx
  80057b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80057f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800583:	c7 04 24 7f 3c 80 00 	movl   $0x803c7f,(%esp)
  80058a:	e8 bb 05 00 00       	call   800b4a <cprintf>
		wait(r);
  80058f:	89 1c 24             	mov    %ebx,(%esp)
  800592:	e8 43 31 00 00       	call   8036da <wait>
		if (debug)
  800597:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80059e:	74 18                	je     8005b8 <runcmd+0x3a9>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8005a0:	a1 28 64 80 00       	mov    0x806428,%eax
  8005a5:	8b 40 48             	mov    0x48(%eax),%eax
  8005a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ac:	c7 04 24 94 3c 80 00 	movl   $0x803c94,(%esp)
  8005b3:	e8 92 05 00 00       	call   800b4a <cprintf>
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  8005b8:	85 ff                	test   %edi,%edi
  8005ba:	74 4e                	je     80060a <runcmd+0x3fb>
		if (debug)
  8005bc:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005c3:	74 1c                	je     8005e1 <runcmd+0x3d2>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  8005c5:	a1 28 64 80 00       	mov    0x806428,%eax
  8005ca:	8b 40 48             	mov    0x48(%eax),%eax
  8005cd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8005d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005d5:	c7 04 24 aa 3c 80 00 	movl   $0x803caa,(%esp)
  8005dc:	e8 69 05 00 00       	call   800b4a <cprintf>
		wait(pipe_child);
  8005e1:	89 3c 24             	mov    %edi,(%esp)
  8005e4:	e8 f1 30 00 00       	call   8036da <wait>
		if (debug)
  8005e9:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005f0:	74 18                	je     80060a <runcmd+0x3fb>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8005f2:	a1 28 64 80 00       	mov    0x806428,%eax
  8005f7:	8b 40 48             	mov    0x48(%eax),%eax
  8005fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005fe:	c7 04 24 94 3c 80 00 	movl   $0x803c94,(%esp)
  800605:	e8 40 05 00 00       	call   800b4a <cprintf>
	}

	// Done!
	exit();
  80060a:	e8 29 04 00 00       	call   800a38 <exit>
  80060f:	eb 17                	jmp    800628 <runcmd+0x419>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
		cprintf("spawn %s: %e\n", argv[0], r);

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  800611:	e8 34 1a 00 00       	call   80204a <close_all>
	if (r >= 0) {
		if (debug)
  800616:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80061d:	0f 84 6c ff ff ff    	je     80058f <runcmd+0x380>
  800623:	e9 44 ff ff ff       	jmp    80056c <runcmd+0x35d>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// Done!
	exit();
}
  800628:	81 c4 6c 04 00 00    	add    $0x46c,%esp
  80062e:	5b                   	pop    %ebx
  80062f:	5e                   	pop    %esi
  800630:	5f                   	pop    %edi
  800631:	5d                   	pop    %ebp
  800632:	c3                   	ret    

00800633 <usage>:
}


void
usage(void)
{
  800633:	55                   	push   %ebp
  800634:	89 e5                	mov    %esp,%ebp
  800636:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800639:	c7 04 24 74 3d 80 00 	movl   $0x803d74,(%esp)
  800640:	e8 05 05 00 00       	call   800b4a <cprintf>
	exit();
  800645:	e8 ee 03 00 00       	call   800a38 <exit>
}
  80064a:	c9                   	leave  
  80064b:	c3                   	ret    

0080064c <umain>:

void
umain(int argc, char **argv)
{
  80064c:	55                   	push   %ebp
  80064d:	89 e5                	mov    %esp,%ebp
  80064f:	57                   	push   %edi
  800650:	56                   	push   %esi
  800651:	53                   	push   %ebx
  800652:	83 ec 3c             	sub    $0x3c,%esp
  800655:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  800658:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80065b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80065f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800663:	8d 45 08             	lea    0x8(%ebp),%eax
  800666:	89 04 24             	mov    %eax,(%esp)
  800669:	e8 9b 16 00 00       	call   801d09 <argstart>
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
  80066e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
umain(int argc, char **argv)
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
  800675:	bf 3f 00 00 00       	mov    $0x3f,%edi
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  80067a:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  80067d:	eb 31                	jmp    8006b0 <umain+0x64>
		switch (r) {
  80067f:	83 f8 69             	cmp    $0x69,%eax
  800682:	74 0e                	je     800692 <umain+0x46>
  800684:	83 f8 78             	cmp    $0x78,%eax
  800687:	74 20                	je     8006a9 <umain+0x5d>
  800689:	83 f8 64             	cmp    $0x64,%eax
  80068c:	75 14                	jne    8006a2 <umain+0x56>
  80068e:	66 90                	xchg   %ax,%ax
  800690:	eb 07                	jmp    800699 <umain+0x4d>
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  800692:	bf 01 00 00 00       	mov    $0x1,%edi
  800697:	eb 17                	jmp    8006b0 <umain+0x64>
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
		switch (r) {
		case 'd':
			debug++;
  800699:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
			break;
  8006a0:	eb 0e                	jmp    8006b0 <umain+0x64>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  8006a2:	e8 8c ff ff ff       	call   800633 <usage>
  8006a7:	eb 07                	jmp    8006b0 <umain+0x64>
			break;
		case 'i':
			interactive = 1;
			break;
		case 'x':
			echocmds = 1;
  8006a9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  8006b0:	89 1c 24             	mov    %ebx,(%esp)
  8006b3:	e8 89 16 00 00       	call   801d41 <argnext>
  8006b8:	85 c0                	test   %eax,%eax
  8006ba:	79 c3                	jns    80067f <umain+0x33>
  8006bc:	89 fb                	mov    %edi,%ebx
			break;
		default:
			usage();
		}

	if (argc > 2)
  8006be:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006c2:	7e 05                	jle    8006c9 <umain+0x7d>
		usage();
  8006c4:	e8 6a ff ff ff       	call   800633 <usage>
	if (argc == 2) {
  8006c9:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006cd:	75 72                	jne    800741 <umain+0xf5>
		close(0);
  8006cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006d6:	e8 3c 19 00 00       	call   802017 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  8006db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8006e2:	00 
  8006e3:	8b 46 04             	mov    0x4(%esi),%eax
  8006e6:	89 04 24             	mov    %eax,(%esp)
  8006e9:	e8 65 1f 00 00       	call   802653 <open>
  8006ee:	85 c0                	test   %eax,%eax
  8006f0:	79 27                	jns    800719 <umain+0xcd>
			panic("open %s: %e", argv[1], r);
  8006f2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006f6:	8b 46 04             	mov    0x4(%esi),%eax
  8006f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006fd:	c7 44 24 08 ca 3c 80 	movl   $0x803cca,0x8(%esp)
  800704:	00 
  800705:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  80070c:	00 
  80070d:	c7 04 24 4a 3c 80 00 	movl   $0x803c4a,(%esp)
  800714:	e8 38 03 00 00       	call   800a51 <_panic>
		assert(r == 0);
  800719:	85 c0                	test   %eax,%eax
  80071b:	74 24                	je     800741 <umain+0xf5>
  80071d:	c7 44 24 0c d6 3c 80 	movl   $0x803cd6,0xc(%esp)
  800724:	00 
  800725:	c7 44 24 08 dd 3c 80 	movl   $0x803cdd,0x8(%esp)
  80072c:	00 
  80072d:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  800734:	00 
  800735:	c7 04 24 4a 3c 80 00 	movl   $0x803c4a,(%esp)
  80073c:	e8 10 03 00 00       	call   800a51 <_panic>
	}
	if (interactive == '?')
  800741:	83 fb 3f             	cmp    $0x3f,%ebx
  800744:	75 0e                	jne    800754 <umain+0x108>
		interactive = iscons(0);
  800746:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80074d:	e8 0a 02 00 00       	call   80095c <iscons>
  800752:	89 c7                	mov    %eax,%edi

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  800754:	85 ff                	test   %edi,%edi
  800756:	b8 00 00 00 00       	mov    $0x0,%eax
  80075b:	ba c7 3c 80 00       	mov    $0x803cc7,%edx
  800760:	0f 45 c2             	cmovne %edx,%eax
  800763:	89 04 24             	mov    %eax,(%esp)
  800766:	e8 d5 09 00 00       	call   801140 <readline>
  80076b:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  80076d:	85 c0                	test   %eax,%eax
  80076f:	75 1a                	jne    80078b <umain+0x13f>
			if (debug)
  800771:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800778:	74 0c                	je     800786 <umain+0x13a>
				cprintf("EXITING\n");
  80077a:	c7 04 24 f2 3c 80 00 	movl   $0x803cf2,(%esp)
  800781:	e8 c4 03 00 00       	call   800b4a <cprintf>
			exit();	// end of file
  800786:	e8 ad 02 00 00       	call   800a38 <exit>
		}
		if (debug)
  80078b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800792:	74 10                	je     8007a4 <umain+0x158>
			cprintf("LINE: %s\n", buf);
  800794:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800798:	c7 04 24 fb 3c 80 00 	movl   $0x803cfb,(%esp)
  80079f:	e8 a6 03 00 00       	call   800b4a <cprintf>
		if (buf[0] == '#')
  8007a4:	80 3b 23             	cmpb   $0x23,(%ebx)
  8007a7:	74 ab                	je     800754 <umain+0x108>
			continue;
		if (echocmds)
  8007a9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007ad:	74 10                	je     8007bf <umain+0x173>
			printf("# %s\n", buf);
  8007af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007b3:	c7 04 24 05 3d 80 00 	movl   $0x803d05,(%esp)
  8007ba:	e8 44 20 00 00       	call   802803 <printf>
		if (debug)
  8007bf:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007c6:	74 0c                	je     8007d4 <umain+0x188>
			cprintf("BEFORE FORK\n");
  8007c8:	c7 04 24 0b 3d 80 00 	movl   $0x803d0b,(%esp)
  8007cf:	e8 76 03 00 00       	call   800b4a <cprintf>
		if ((r = fork()) < 0)
  8007d4:	e8 dd 12 00 00       	call   801ab6 <fork>
  8007d9:	89 c6                	mov    %eax,%esi
  8007db:	85 c0                	test   %eax,%eax
  8007dd:	79 20                	jns    8007ff <umain+0x1b3>
			panic("fork: %e", r);
  8007df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007e3:	c7 44 24 08 25 3c 80 	movl   $0x803c25,0x8(%esp)
  8007ea:	00 
  8007eb:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
  8007f2:	00 
  8007f3:	c7 04 24 4a 3c 80 00 	movl   $0x803c4a,(%esp)
  8007fa:	e8 52 02 00 00       	call   800a51 <_panic>
		if (debug)
  8007ff:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800806:	74 10                	je     800818 <umain+0x1cc>
			cprintf("FORK: %d\n", r);
  800808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080c:	c7 04 24 18 3d 80 00 	movl   $0x803d18,(%esp)
  800813:	e8 32 03 00 00       	call   800b4a <cprintf>
		if (r == 0) {
  800818:	85 f6                	test   %esi,%esi
  80081a:	75 12                	jne    80082e <umain+0x1e2>
			runcmd(buf);
  80081c:	89 1c 24             	mov    %ebx,(%esp)
  80081f:	e8 eb f9 ff ff       	call   80020f <runcmd>
			exit();
  800824:	e8 0f 02 00 00       	call   800a38 <exit>
  800829:	e9 26 ff ff ff       	jmp    800754 <umain+0x108>
		} else
			wait(r);
  80082e:	89 34 24             	mov    %esi,(%esp)
  800831:	e8 a4 2e 00 00       	call   8036da <wait>
  800836:	e9 19 ff ff ff       	jmp    800754 <umain+0x108>
  80083b:	66 90                	xchg   %ax,%ax
  80083d:	66 90                	xchg   %ax,%ax
  80083f:	90                   	nop

00800840 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800843:	b8 00 00 00 00       	mov    $0x0,%eax
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    

0080084a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800850:	c7 44 24 04 95 3d 80 	movl   $0x803d95,0x4(%esp)
  800857:	00 
  800858:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085b:	89 04 24             	mov    %eax,(%esp)
  80085e:	e8 04 0a 00 00       	call   801267 <strcpy>
	return 0;
}
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	c9                   	leave  
  800869:	c3                   	ret    

0080086a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	57                   	push   %edi
  80086e:	56                   	push   %esi
  80086f:	53                   	push   %ebx
  800870:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800876:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80087b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800881:	eb 31                	jmp    8008b4 <devcons_write+0x4a>
		m = n - tot;
  800883:	8b 75 10             	mov    0x10(%ebp),%esi
  800886:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  800888:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80088b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800890:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800893:	89 74 24 08          	mov    %esi,0x8(%esp)
  800897:	03 45 0c             	add    0xc(%ebp),%eax
  80089a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80089e:	89 3c 24             	mov    %edi,(%esp)
  8008a1:	e8 5e 0b 00 00       	call   801404 <memmove>
		sys_cputs(buf, m);
  8008a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008aa:	89 3c 24             	mov    %edi,(%esp)
  8008ad:	e8 04 0d 00 00       	call   8015b6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008b2:	01 f3                	add    %esi,%ebx
  8008b4:	89 d8                	mov    %ebx,%eax
  8008b6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8008b9:	72 c8                	jb     800883 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8008bb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8008c1:	5b                   	pop    %ebx
  8008c2:	5e                   	pop    %esi
  8008c3:	5f                   	pop    %edi
  8008c4:	5d                   	pop    %ebp
  8008c5:	c3                   	ret    

008008c6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8008cc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8008d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8008d5:	75 07                	jne    8008de <devcons_read+0x18>
  8008d7:	eb 2a                	jmp    800903 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8008d9:	e8 86 0d 00 00       	call   801664 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8008de:	66 90                	xchg   %ax,%ax
  8008e0:	e8 ef 0c 00 00       	call   8015d4 <sys_cgetc>
  8008e5:	85 c0                	test   %eax,%eax
  8008e7:	74 f0                	je     8008d9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8008e9:	85 c0                	test   %eax,%eax
  8008eb:	78 16                	js     800903 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8008ed:	83 f8 04             	cmp    $0x4,%eax
  8008f0:	74 0c                	je     8008fe <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8008f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f5:	88 02                	mov    %al,(%edx)
	return 1;
  8008f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8008fc:	eb 05                	jmp    800903 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800903:	c9                   	leave  
  800904:	c3                   	ret    

00800905 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800911:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800918:	00 
  800919:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80091c:	89 04 24             	mov    %eax,(%esp)
  80091f:	e8 92 0c 00 00       	call   8015b6 <sys_cputs>
}
  800924:	c9                   	leave  
  800925:	c3                   	ret    

00800926 <getchar>:

int
getchar(void)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80092c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800933:	00 
  800934:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800937:	89 44 24 04          	mov    %eax,0x4(%esp)
  80093b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800942:	e8 33 18 00 00       	call   80217a <read>
	if (r < 0)
  800947:	85 c0                	test   %eax,%eax
  800949:	78 0f                	js     80095a <getchar+0x34>
		return r;
	if (r < 1)
  80094b:	85 c0                	test   %eax,%eax
  80094d:	7e 06                	jle    800955 <getchar+0x2f>
		return -E_EOF;
	return c;
  80094f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800953:	eb 05                	jmp    80095a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800955:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    

0080095c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800962:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800965:	89 44 24 04          	mov    %eax,0x4(%esp)
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	89 04 24             	mov    %eax,(%esp)
  80096f:	e8 72 15 00 00       	call   801ee6 <fd_lookup>
  800974:	85 c0                	test   %eax,%eax
  800976:	78 11                	js     800989 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80097b:	8b 15 00 50 80 00    	mov    0x805000,%edx
  800981:	39 10                	cmp    %edx,(%eax)
  800983:	0f 94 c0             	sete   %al
  800986:	0f b6 c0             	movzbl %al,%eax
}
  800989:	c9                   	leave  
  80098a:	c3                   	ret    

0080098b <opencons>:

int
opencons(void)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800991:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800994:	89 04 24             	mov    %eax,(%esp)
  800997:	e8 fb 14 00 00       	call   801e97 <fd_alloc>
		return r;
  80099c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80099e:	85 c0                	test   %eax,%eax
  8009a0:	78 40                	js     8009e2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009a2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8009a9:	00 
  8009aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009b8:	e8 c6 0c 00 00       	call   801683 <sys_page_alloc>
		return r;
  8009bd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009bf:	85 c0                	test   %eax,%eax
  8009c1:	78 1f                	js     8009e2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8009c3:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009d8:	89 04 24             	mov    %eax,(%esp)
  8009db:	e8 90 14 00 00       	call   801e70 <fd2num>
  8009e0:	89 c2                	mov    %eax,%edx
}
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	c9                   	leave  
  8009e5:	c3                   	ret    

008009e6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	56                   	push   %esi
  8009ea:	53                   	push   %ebx
  8009eb:	83 ec 10             	sub    $0x10,%esp
  8009ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009f1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8009f4:	c7 05 28 64 80 00 00 	movl   $0x0,0x806428
  8009fb:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8009fe:	e8 42 0c 00 00       	call   801645 <sys_getenvid>
  800a03:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800a08:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a0b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a10:	a3 28 64 80 00       	mov    %eax,0x806428


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a15:	85 db                	test   %ebx,%ebx
  800a17:	7e 07                	jle    800a20 <libmain+0x3a>
		binaryname = argv[0];
  800a19:	8b 06                	mov    (%esi),%eax
  800a1b:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800a20:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a24:	89 1c 24             	mov    %ebx,(%esp)
  800a27:	e8 20 fc ff ff       	call   80064c <umain>

	// exit gracefully
	exit();
  800a2c:	e8 07 00 00 00       	call   800a38 <exit>
}
  800a31:	83 c4 10             	add    $0x10,%esp
  800a34:	5b                   	pop    %ebx
  800a35:	5e                   	pop    %esi
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    

00800a38 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800a3e:	e8 07 16 00 00       	call   80204a <close_all>
	sys_env_destroy(0);
  800a43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a4a:	e8 a4 0b 00 00       	call   8015f3 <sys_env_destroy>
}
  800a4f:	c9                   	leave  
  800a50:	c3                   	ret    

00800a51 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	56                   	push   %esi
  800a55:	53                   	push   %ebx
  800a56:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800a59:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a5c:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800a62:	e8 de 0b 00 00       	call   801645 <sys_getenvid>
  800a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6a:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800a71:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a75:	89 74 24 08          	mov    %esi,0x8(%esp)
  800a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a7d:	c7 04 24 ac 3d 80 00 	movl   $0x803dac,(%esp)
  800a84:	e8 c1 00 00 00       	call   800b4a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a89:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a90:	89 04 24             	mov    %eax,(%esp)
  800a93:	e8 51 00 00 00       	call   800ae9 <vcprintf>
	cprintf("\n");
  800a98:	c7 04 24 c0 3b 80 00 	movl   $0x803bc0,(%esp)
  800a9f:	e8 a6 00 00 00       	call   800b4a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800aa4:	cc                   	int3   
  800aa5:	eb fd                	jmp    800aa4 <_panic+0x53>

00800aa7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	53                   	push   %ebx
  800aab:	83 ec 14             	sub    $0x14,%esp
  800aae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800ab1:	8b 13                	mov    (%ebx),%edx
  800ab3:	8d 42 01             	lea    0x1(%edx),%eax
  800ab6:	89 03                	mov    %eax,(%ebx)
  800ab8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800abf:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ac4:	75 19                	jne    800adf <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800ac6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800acd:	00 
  800ace:	8d 43 08             	lea    0x8(%ebx),%eax
  800ad1:	89 04 24             	mov    %eax,(%esp)
  800ad4:	e8 dd 0a 00 00       	call   8015b6 <sys_cputs>
		b->idx = 0;
  800ad9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800adf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800ae3:	83 c4 14             	add    $0x14,%esp
  800ae6:	5b                   	pop    %ebx
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800af2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800af9:	00 00 00 
	b.cnt = 0;
  800afc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b03:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b14:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b1e:	c7 04 24 a7 0a 80 00 	movl   $0x800aa7,(%esp)
  800b25:	e8 b4 01 00 00       	call   800cde <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b2a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800b30:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b34:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b3a:	89 04 24             	mov    %eax,(%esp)
  800b3d:	e8 74 0a 00 00       	call   8015b6 <sys_cputs>

	return b.cnt;
}
  800b42:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    

00800b4a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b50:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b53:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	89 04 24             	mov    %eax,(%esp)
  800b5d:	e8 87 ff ff ff       	call   800ae9 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    
  800b64:	66 90                	xchg   %ax,%ax
  800b66:	66 90                	xchg   %ax,%ax
  800b68:	66 90                	xchg   %ax,%ax
  800b6a:	66 90                	xchg   %ax,%ax
  800b6c:	66 90                	xchg   %ax,%ax
  800b6e:	66 90                	xchg   %ax,%ax

00800b70 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	57                   	push   %edi
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
  800b76:	83 ec 3c             	sub    $0x3c,%esp
  800b79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b7c:	89 d7                	mov    %edx,%edi
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b87:	89 c3                	mov    %eax,%ebx
  800b89:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b97:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b9a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b9d:	39 d9                	cmp    %ebx,%ecx
  800b9f:	72 05                	jb     800ba6 <printnum+0x36>
  800ba1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800ba4:	77 69                	ja     800c0f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ba6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ba9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800bad:	83 ee 01             	sub    $0x1,%esi
  800bb0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bb4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bb8:	8b 44 24 08          	mov    0x8(%esp),%eax
  800bbc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800bc0:	89 c3                	mov    %eax,%ebx
  800bc2:	89 d6                	mov    %edx,%esi
  800bc4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800bc7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800bca:	89 54 24 08          	mov    %edx,0x8(%esp)
  800bce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800bd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bd5:	89 04 24             	mov    %eax,(%esp)
  800bd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bdf:	e8 2c 2d 00 00       	call   803910 <__udivdi3>
  800be4:	89 d9                	mov    %ebx,%ecx
  800be6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800bea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bee:	89 04 24             	mov    %eax,(%esp)
  800bf1:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bf5:	89 fa                	mov    %edi,%edx
  800bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bfa:	e8 71 ff ff ff       	call   800b70 <printnum>
  800bff:	eb 1b                	jmp    800c1c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c01:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c05:	8b 45 18             	mov    0x18(%ebp),%eax
  800c08:	89 04 24             	mov    %eax,(%esp)
  800c0b:	ff d3                	call   *%ebx
  800c0d:	eb 03                	jmp    800c12 <printnum+0xa2>
  800c0f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c12:	83 ee 01             	sub    $0x1,%esi
  800c15:	85 f6                	test   %esi,%esi
  800c17:	7f e8                	jg     800c01 <printnum+0x91>
  800c19:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c1c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c20:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c24:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c27:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c2e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c35:	89 04 24             	mov    %eax,(%esp)
  800c38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c3f:	e8 fc 2d 00 00       	call   803a40 <__umoddi3>
  800c44:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c48:	0f be 80 cf 3d 80 00 	movsbl 0x803dcf(%eax),%eax
  800c4f:	89 04 24             	mov    %eax,(%esp)
  800c52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c55:	ff d0                	call   *%eax
}
  800c57:	83 c4 3c             	add    $0x3c,%esp
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c62:	83 fa 01             	cmp    $0x1,%edx
  800c65:	7e 0e                	jle    800c75 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800c67:	8b 10                	mov    (%eax),%edx
  800c69:	8d 4a 08             	lea    0x8(%edx),%ecx
  800c6c:	89 08                	mov    %ecx,(%eax)
  800c6e:	8b 02                	mov    (%edx),%eax
  800c70:	8b 52 04             	mov    0x4(%edx),%edx
  800c73:	eb 22                	jmp    800c97 <getuint+0x38>
	else if (lflag)
  800c75:	85 d2                	test   %edx,%edx
  800c77:	74 10                	je     800c89 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800c79:	8b 10                	mov    (%eax),%edx
  800c7b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c7e:	89 08                	mov    %ecx,(%eax)
  800c80:	8b 02                	mov    (%edx),%eax
  800c82:	ba 00 00 00 00       	mov    $0x0,%edx
  800c87:	eb 0e                	jmp    800c97 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800c89:	8b 10                	mov    (%eax),%edx
  800c8b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c8e:	89 08                	mov    %ecx,(%eax)
  800c90:	8b 02                	mov    (%edx),%eax
  800c92:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c9f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800ca3:	8b 10                	mov    (%eax),%edx
  800ca5:	3b 50 04             	cmp    0x4(%eax),%edx
  800ca8:	73 0a                	jae    800cb4 <sprintputch+0x1b>
		*b->buf++ = ch;
  800caa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cad:	89 08                	mov    %ecx,(%eax)
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	88 02                	mov    %al,(%edx)
}
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cbc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800cbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	89 04 24             	mov    %eax,(%esp)
  800cd7:	e8 02 00 00 00       	call   800cde <vprintfmt>
	va_end(ap);
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	57                   	push   %edi
  800ce2:	56                   	push   %esi
  800ce3:	53                   	push   %ebx
  800ce4:	83 ec 3c             	sub    $0x3c,%esp
  800ce7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800cea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ced:	eb 14                	jmp    800d03 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800cef:	85 c0                	test   %eax,%eax
  800cf1:	0f 84 b3 03 00 00    	je     8010aa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800cf7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cfb:	89 04 24             	mov    %eax,(%esp)
  800cfe:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d01:	89 f3                	mov    %esi,%ebx
  800d03:	8d 73 01             	lea    0x1(%ebx),%esi
  800d06:	0f b6 03             	movzbl (%ebx),%eax
  800d09:	83 f8 25             	cmp    $0x25,%eax
  800d0c:	75 e1                	jne    800cef <vprintfmt+0x11>
  800d0e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800d12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800d19:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800d20:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800d27:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2c:	eb 1d                	jmp    800d4b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d2e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800d30:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800d34:	eb 15                	jmp    800d4b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d36:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d38:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800d3c:	eb 0d                	jmp    800d4b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800d3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d41:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d44:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d4b:	8d 5e 01             	lea    0x1(%esi),%ebx
  800d4e:	0f b6 0e             	movzbl (%esi),%ecx
  800d51:	0f b6 c1             	movzbl %cl,%eax
  800d54:	83 e9 23             	sub    $0x23,%ecx
  800d57:	80 f9 55             	cmp    $0x55,%cl
  800d5a:	0f 87 2a 03 00 00    	ja     80108a <vprintfmt+0x3ac>
  800d60:	0f b6 c9             	movzbl %cl,%ecx
  800d63:	ff 24 8d 20 3f 80 00 	jmp    *0x803f20(,%ecx,4)
  800d6a:	89 de                	mov    %ebx,%esi
  800d6c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800d71:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800d74:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800d78:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800d7b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800d7e:	83 fb 09             	cmp    $0x9,%ebx
  800d81:	77 36                	ja     800db9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d83:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d86:	eb e9                	jmp    800d71 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d88:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8b:	8d 48 04             	lea    0x4(%eax),%ecx
  800d8e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800d91:	8b 00                	mov    (%eax),%eax
  800d93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d96:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800d98:	eb 22                	jmp    800dbc <vprintfmt+0xde>
  800d9a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800d9d:	85 c9                	test   %ecx,%ecx
  800d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800da4:	0f 49 c1             	cmovns %ecx,%eax
  800da7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800daa:	89 de                	mov    %ebx,%esi
  800dac:	eb 9d                	jmp    800d4b <vprintfmt+0x6d>
  800dae:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800db0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800db7:	eb 92                	jmp    800d4b <vprintfmt+0x6d>
  800db9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800dbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dc0:	79 89                	jns    800d4b <vprintfmt+0x6d>
  800dc2:	e9 77 ff ff ff       	jmp    800d3e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dc7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dca:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800dcc:	e9 7a ff ff ff       	jmp    800d4b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd4:	8d 50 04             	lea    0x4(%eax),%edx
  800dd7:	89 55 14             	mov    %edx,0x14(%ebp)
  800dda:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dde:	8b 00                	mov    (%eax),%eax
  800de0:	89 04 24             	mov    %eax,(%esp)
  800de3:	ff 55 08             	call   *0x8(%ebp)
			break;
  800de6:	e9 18 ff ff ff       	jmp    800d03 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800deb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dee:	8d 50 04             	lea    0x4(%eax),%edx
  800df1:	89 55 14             	mov    %edx,0x14(%ebp)
  800df4:	8b 00                	mov    (%eax),%eax
  800df6:	99                   	cltd   
  800df7:	31 d0                	xor    %edx,%eax
  800df9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dfb:	83 f8 0f             	cmp    $0xf,%eax
  800dfe:	7f 0b                	jg     800e0b <vprintfmt+0x12d>
  800e00:	8b 14 85 80 40 80 00 	mov    0x804080(,%eax,4),%edx
  800e07:	85 d2                	test   %edx,%edx
  800e09:	75 20                	jne    800e2b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800e0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e0f:	c7 44 24 08 e7 3d 80 	movl   $0x803de7,0x8(%esp)
  800e16:	00 
  800e17:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 04 24             	mov    %eax,(%esp)
  800e21:	e8 90 fe ff ff       	call   800cb6 <printfmt>
  800e26:	e9 d8 fe ff ff       	jmp    800d03 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800e2b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e2f:	c7 44 24 08 ef 3c 80 	movl   $0x803cef,0x8(%esp)
  800e36:	00 
  800e37:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	89 04 24             	mov    %eax,(%esp)
  800e41:	e8 70 fe ff ff       	call   800cb6 <printfmt>
  800e46:	e9 b8 fe ff ff       	jmp    800d03 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e4b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e51:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e54:	8b 45 14             	mov    0x14(%ebp),%eax
  800e57:	8d 50 04             	lea    0x4(%eax),%edx
  800e5a:	89 55 14             	mov    %edx,0x14(%ebp)
  800e5d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800e5f:	85 f6                	test   %esi,%esi
  800e61:	b8 e0 3d 80 00       	mov    $0x803de0,%eax
  800e66:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800e69:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800e6d:	0f 84 97 00 00 00    	je     800f0a <vprintfmt+0x22c>
  800e73:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800e77:	0f 8e 9b 00 00 00    	jle    800f18 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e81:	89 34 24             	mov    %esi,(%esp)
  800e84:	e8 bf 03 00 00       	call   801248 <strnlen>
  800e89:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e8c:	29 c2                	sub    %eax,%edx
  800e8e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800e91:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800e95:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e98:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800e9b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e9e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ea1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea3:	eb 0f                	jmp    800eb4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800ea5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ea9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800eac:	89 04 24             	mov    %eax,(%esp)
  800eaf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eb1:	83 eb 01             	sub    $0x1,%ebx
  800eb4:	85 db                	test   %ebx,%ebx
  800eb6:	7f ed                	jg     800ea5 <vprintfmt+0x1c7>
  800eb8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800ebb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800ebe:	85 d2                	test   %edx,%edx
  800ec0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec5:	0f 49 c2             	cmovns %edx,%eax
  800ec8:	29 c2                	sub    %eax,%edx
  800eca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800ecd:	89 d7                	mov    %edx,%edi
  800ecf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ed2:	eb 50                	jmp    800f24 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ed4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ed8:	74 1e                	je     800ef8 <vprintfmt+0x21a>
  800eda:	0f be d2             	movsbl %dl,%edx
  800edd:	83 ea 20             	sub    $0x20,%edx
  800ee0:	83 fa 5e             	cmp    $0x5e,%edx
  800ee3:	76 13                	jbe    800ef8 <vprintfmt+0x21a>
					putch('?', putdat);
  800ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eec:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800ef3:	ff 55 08             	call   *0x8(%ebp)
  800ef6:	eb 0d                	jmp    800f05 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efb:	89 54 24 04          	mov    %edx,0x4(%esp)
  800eff:	89 04 24             	mov    %eax,(%esp)
  800f02:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f05:	83 ef 01             	sub    $0x1,%edi
  800f08:	eb 1a                	jmp    800f24 <vprintfmt+0x246>
  800f0a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800f0d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800f10:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f13:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800f16:	eb 0c                	jmp    800f24 <vprintfmt+0x246>
  800f18:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800f1b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800f1e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f21:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800f24:	83 c6 01             	add    $0x1,%esi
  800f27:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800f2b:	0f be c2             	movsbl %dl,%eax
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	74 27                	je     800f59 <vprintfmt+0x27b>
  800f32:	85 db                	test   %ebx,%ebx
  800f34:	78 9e                	js     800ed4 <vprintfmt+0x1f6>
  800f36:	83 eb 01             	sub    $0x1,%ebx
  800f39:	79 99                	jns    800ed4 <vprintfmt+0x1f6>
  800f3b:	89 f8                	mov    %edi,%eax
  800f3d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f40:	8b 75 08             	mov    0x8(%ebp),%esi
  800f43:	89 c3                	mov    %eax,%ebx
  800f45:	eb 1a                	jmp    800f61 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800f47:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f4b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800f52:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f54:	83 eb 01             	sub    $0x1,%ebx
  800f57:	eb 08                	jmp    800f61 <vprintfmt+0x283>
  800f59:	89 fb                	mov    %edi,%ebx
  800f5b:	8b 75 08             	mov    0x8(%ebp),%esi
  800f5e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f61:	85 db                	test   %ebx,%ebx
  800f63:	7f e2                	jg     800f47 <vprintfmt+0x269>
  800f65:	89 75 08             	mov    %esi,0x8(%ebp)
  800f68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6b:	e9 93 fd ff ff       	jmp    800d03 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800f70:	83 fa 01             	cmp    $0x1,%edx
  800f73:	7e 16                	jle    800f8b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800f75:	8b 45 14             	mov    0x14(%ebp),%eax
  800f78:	8d 50 08             	lea    0x8(%eax),%edx
  800f7b:	89 55 14             	mov    %edx,0x14(%ebp)
  800f7e:	8b 50 04             	mov    0x4(%eax),%edx
  800f81:	8b 00                	mov    (%eax),%eax
  800f83:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f86:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800f89:	eb 32                	jmp    800fbd <vprintfmt+0x2df>
	else if (lflag)
  800f8b:	85 d2                	test   %edx,%edx
  800f8d:	74 18                	je     800fa7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800f8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f92:	8d 50 04             	lea    0x4(%eax),%edx
  800f95:	89 55 14             	mov    %edx,0x14(%ebp)
  800f98:	8b 30                	mov    (%eax),%esi
  800f9a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800f9d:	89 f0                	mov    %esi,%eax
  800f9f:	c1 f8 1f             	sar    $0x1f,%eax
  800fa2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fa5:	eb 16                	jmp    800fbd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800fa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800faa:	8d 50 04             	lea    0x4(%eax),%edx
  800fad:	89 55 14             	mov    %edx,0x14(%ebp)
  800fb0:	8b 30                	mov    (%eax),%esi
  800fb2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800fb5:	89 f0                	mov    %esi,%eax
  800fb7:	c1 f8 1f             	sar    $0x1f,%eax
  800fba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800fc3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800fc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fcc:	0f 89 80 00 00 00    	jns    801052 <vprintfmt+0x374>
				putch('-', putdat);
  800fd2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fd6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800fdd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800fe0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fe6:	f7 d8                	neg    %eax
  800fe8:	83 d2 00             	adc    $0x0,%edx
  800feb:	f7 da                	neg    %edx
			}
			base = 10;
  800fed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ff2:	eb 5e                	jmp    801052 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ff4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff7:	e8 63 fc ff ff       	call   800c5f <getuint>
			base = 10;
  800ffc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801001:	eb 4f                	jmp    801052 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  801003:	8d 45 14             	lea    0x14(%ebp),%eax
  801006:	e8 54 fc ff ff       	call   800c5f <getuint>
			base =8;
  80100b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801010:	eb 40                	jmp    801052 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  801012:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801016:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80101d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801020:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801024:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80102b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80102e:	8b 45 14             	mov    0x14(%ebp),%eax
  801031:	8d 50 04             	lea    0x4(%eax),%edx
  801034:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801037:	8b 00                	mov    (%eax),%eax
  801039:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80103e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801043:	eb 0d                	jmp    801052 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801045:	8d 45 14             	lea    0x14(%ebp),%eax
  801048:	e8 12 fc ff ff       	call   800c5f <getuint>
			base = 16;
  80104d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801052:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801056:	89 74 24 10          	mov    %esi,0x10(%esp)
  80105a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80105d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801061:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801065:	89 04 24             	mov    %eax,(%esp)
  801068:	89 54 24 04          	mov    %edx,0x4(%esp)
  80106c:	89 fa                	mov    %edi,%edx
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	e8 fa fa ff ff       	call   800b70 <printnum>
			break;
  801076:	e9 88 fc ff ff       	jmp    800d03 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80107b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80107f:	89 04 24             	mov    %eax,(%esp)
  801082:	ff 55 08             	call   *0x8(%ebp)
			break;
  801085:	e9 79 fc ff ff       	jmp    800d03 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80108a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80108e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801095:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801098:	89 f3                	mov    %esi,%ebx
  80109a:	eb 03                	jmp    80109f <vprintfmt+0x3c1>
  80109c:	83 eb 01             	sub    $0x1,%ebx
  80109f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8010a3:	75 f7                	jne    80109c <vprintfmt+0x3be>
  8010a5:	e9 59 fc ff ff       	jmp    800d03 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8010aa:	83 c4 3c             	add    $0x3c,%esp
  8010ad:	5b                   	pop    %ebx
  8010ae:	5e                   	pop    %esi
  8010af:	5f                   	pop    %edi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    

008010b2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 28             	sub    $0x28,%esp
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010c1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010c5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	74 30                	je     801103 <vsnprintf+0x51>
  8010d3:	85 d2                	test   %edx,%edx
  8010d5:	7e 2c                	jle    801103 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010ec:	c7 04 24 99 0c 80 00 	movl   $0x800c99,(%esp)
  8010f3:	e8 e6 fb ff ff       	call   800cde <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8010f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010fb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801101:	eb 05                	jmp    801108 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801103:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801110:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801117:	8b 45 10             	mov    0x10(%ebp),%eax
  80111a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	89 44 24 04          	mov    %eax,0x4(%esp)
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	89 04 24             	mov    %eax,(%esp)
  80112b:	e8 82 ff ff ff       	call   8010b2 <vsnprintf>
	va_end(ap);

	return rc;
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    
  801132:	66 90                	xchg   %ax,%ax
  801134:	66 90                	xchg   %ax,%ax
  801136:	66 90                	xchg   %ax,%ax
  801138:	66 90                	xchg   %ax,%ax
  80113a:	66 90                	xchg   %ax,%ax
  80113c:	66 90                	xchg   %ax,%ax
  80113e:	66 90                	xchg   %ax,%ax

00801140 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	57                   	push   %edi
  801144:	56                   	push   %esi
  801145:	53                   	push   %ebx
  801146:	83 ec 1c             	sub    $0x1c,%esp
  801149:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80114c:	85 c0                	test   %eax,%eax
  80114e:	74 18                	je     801168 <readline+0x28>
		fprintf(1, "%s", prompt);
  801150:	89 44 24 08          	mov    %eax,0x8(%esp)
  801154:	c7 44 24 04 ef 3c 80 	movl   $0x803cef,0x4(%esp)
  80115b:	00 
  80115c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801163:	e8 7a 16 00 00       	call   8027e2 <fprintf>
#endif


	i = 0;
	echoing = iscons(0);
  801168:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80116f:	e8 e8 f7 ff ff       	call   80095c <iscons>
  801174:	89 c7                	mov    %eax,%edi
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif


	i = 0;
  801176:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  80117b:	e8 a6 f7 ff ff       	call   800926 <getchar>
  801180:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801182:	85 c0                	test   %eax,%eax
  801184:	79 25                	jns    8011ab <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);

			return NULL;
  801186:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  80118b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  80118e:	0f 84 88 00 00 00    	je     80121c <readline+0xdc>
				cprintf("read error: %e\n", c);
  801194:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801198:	c7 04 24 df 40 80 00 	movl   $0x8040df,(%esp)
  80119f:	e8 a6 f9 ff ff       	call   800b4a <cprintf>

			return NULL;
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a9:	eb 71                	jmp    80121c <readline+0xdc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8011ab:	83 f8 7f             	cmp    $0x7f,%eax
  8011ae:	74 05                	je     8011b5 <readline+0x75>
  8011b0:	83 f8 08             	cmp    $0x8,%eax
  8011b3:	75 19                	jne    8011ce <readline+0x8e>
  8011b5:	85 f6                	test   %esi,%esi
  8011b7:	7e 15                	jle    8011ce <readline+0x8e>
			if (echoing)
  8011b9:	85 ff                	test   %edi,%edi
  8011bb:	74 0c                	je     8011c9 <readline+0x89>
				cputchar('\b');
  8011bd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8011c4:	e8 3c f7 ff ff       	call   800905 <cputchar>
			i--;
  8011c9:	83 ee 01             	sub    $0x1,%esi
  8011cc:	eb ad                	jmp    80117b <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011ce:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8011d4:	7f 1c                	jg     8011f2 <readline+0xb2>
  8011d6:	83 fb 1f             	cmp    $0x1f,%ebx
  8011d9:	7e 17                	jle    8011f2 <readline+0xb2>
			if (echoing)
  8011db:	85 ff                	test   %edi,%edi
  8011dd:	74 08                	je     8011e7 <readline+0xa7>
				cputchar(c);
  8011df:	89 1c 24             	mov    %ebx,(%esp)
  8011e2:	e8 1e f7 ff ff       	call   800905 <cputchar>
			buf[i++] = c;
  8011e7:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  8011ed:	8d 76 01             	lea    0x1(%esi),%esi
  8011f0:	eb 89                	jmp    80117b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  8011f2:	83 fb 0d             	cmp    $0xd,%ebx
  8011f5:	74 09                	je     801200 <readline+0xc0>
  8011f7:	83 fb 0a             	cmp    $0xa,%ebx
  8011fa:	0f 85 7b ff ff ff    	jne    80117b <readline+0x3b>
			if (echoing)
  801200:	85 ff                	test   %edi,%edi
  801202:	74 0c                	je     801210 <readline+0xd0>
				cputchar('\n');
  801204:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80120b:	e8 f5 f6 ff ff       	call   800905 <cputchar>
			buf[i] = 0;
  801210:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  801217:	b8 20 60 80 00       	mov    $0x806020,%eax
		}
	}
}
  80121c:	83 c4 1c             	add    $0x1c,%esp
  80121f:	5b                   	pop    %ebx
  801220:	5e                   	pop    %esi
  801221:	5f                   	pop    %edi
  801222:	5d                   	pop    %ebp
  801223:	c3                   	ret    
  801224:	66 90                	xchg   %ax,%ax
  801226:	66 90                	xchg   %ax,%ax
  801228:	66 90                	xchg   %ax,%ax
  80122a:	66 90                	xchg   %ax,%ax
  80122c:	66 90                	xchg   %ax,%ax
  80122e:	66 90                	xchg   %ax,%ax

00801230 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801236:	b8 00 00 00 00       	mov    $0x0,%eax
  80123b:	eb 03                	jmp    801240 <strlen+0x10>
		n++;
  80123d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801240:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801244:	75 f7                	jne    80123d <strlen+0xd>
		n++;
	return n;
}
  801246:	5d                   	pop    %ebp
  801247:	c3                   	ret    

00801248 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80124e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	eb 03                	jmp    80125b <strnlen+0x13>
		n++;
  801258:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80125b:	39 d0                	cmp    %edx,%eax
  80125d:	74 06                	je     801265 <strnlen+0x1d>
  80125f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801263:	75 f3                	jne    801258 <strnlen+0x10>
		n++;
	return n;
}
  801265:	5d                   	pop    %ebp
  801266:	c3                   	ret    

00801267 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	53                   	push   %ebx
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801271:	89 c2                	mov    %eax,%edx
  801273:	83 c2 01             	add    $0x1,%edx
  801276:	83 c1 01             	add    $0x1,%ecx
  801279:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80127d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801280:	84 db                	test   %bl,%bl
  801282:	75 ef                	jne    801273 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801284:	5b                   	pop    %ebx
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    

00801287 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	53                   	push   %ebx
  80128b:	83 ec 08             	sub    $0x8,%esp
  80128e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801291:	89 1c 24             	mov    %ebx,(%esp)
  801294:	e8 97 ff ff ff       	call   801230 <strlen>
	strcpy(dst + len, src);
  801299:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012a0:	01 d8                	add    %ebx,%eax
  8012a2:	89 04 24             	mov    %eax,(%esp)
  8012a5:	e8 bd ff ff ff       	call   801267 <strcpy>
	return dst;
}
  8012aa:	89 d8                	mov    %ebx,%eax
  8012ac:	83 c4 08             	add    $0x8,%esp
  8012af:	5b                   	pop    %ebx
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    

008012b2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	56                   	push   %esi
  8012b6:	53                   	push   %ebx
  8012b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8012ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012bd:	89 f3                	mov    %esi,%ebx
  8012bf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012c2:	89 f2                	mov    %esi,%edx
  8012c4:	eb 0f                	jmp    8012d5 <strncpy+0x23>
		*dst++ = *src;
  8012c6:	83 c2 01             	add    $0x1,%edx
  8012c9:	0f b6 01             	movzbl (%ecx),%eax
  8012cc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8012cf:	80 39 01             	cmpb   $0x1,(%ecx)
  8012d2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d5:	39 da                	cmp    %ebx,%edx
  8012d7:	75 ed                	jne    8012c6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8012d9:	89 f0                	mov    %esi,%eax
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5d                   	pop    %ebp
  8012de:	c3                   	ret    

008012df <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	56                   	push   %esi
  8012e3:	53                   	push   %ebx
  8012e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8012e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ed:	89 f0                	mov    %esi,%eax
  8012ef:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8012f3:	85 c9                	test   %ecx,%ecx
  8012f5:	75 0b                	jne    801302 <strlcpy+0x23>
  8012f7:	eb 1d                	jmp    801316 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8012f9:	83 c0 01             	add    $0x1,%eax
  8012fc:	83 c2 01             	add    $0x1,%edx
  8012ff:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801302:	39 d8                	cmp    %ebx,%eax
  801304:	74 0b                	je     801311 <strlcpy+0x32>
  801306:	0f b6 0a             	movzbl (%edx),%ecx
  801309:	84 c9                	test   %cl,%cl
  80130b:	75 ec                	jne    8012f9 <strlcpy+0x1a>
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	eb 02                	jmp    801313 <strlcpy+0x34>
  801311:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801313:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801316:	29 f0                	sub    %esi,%eax
}
  801318:	5b                   	pop    %ebx
  801319:	5e                   	pop    %esi
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    

0080131c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801322:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801325:	eb 06                	jmp    80132d <strcmp+0x11>
		p++, q++;
  801327:	83 c1 01             	add    $0x1,%ecx
  80132a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80132d:	0f b6 01             	movzbl (%ecx),%eax
  801330:	84 c0                	test   %al,%al
  801332:	74 04                	je     801338 <strcmp+0x1c>
  801334:	3a 02                	cmp    (%edx),%al
  801336:	74 ef                	je     801327 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801338:	0f b6 c0             	movzbl %al,%eax
  80133b:	0f b6 12             	movzbl (%edx),%edx
  80133e:	29 d0                	sub    %edx,%eax
}
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	53                   	push   %ebx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134c:	89 c3                	mov    %eax,%ebx
  80134e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801351:	eb 06                	jmp    801359 <strncmp+0x17>
		n--, p++, q++;
  801353:	83 c0 01             	add    $0x1,%eax
  801356:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801359:	39 d8                	cmp    %ebx,%eax
  80135b:	74 15                	je     801372 <strncmp+0x30>
  80135d:	0f b6 08             	movzbl (%eax),%ecx
  801360:	84 c9                	test   %cl,%cl
  801362:	74 04                	je     801368 <strncmp+0x26>
  801364:	3a 0a                	cmp    (%edx),%cl
  801366:	74 eb                	je     801353 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801368:	0f b6 00             	movzbl (%eax),%eax
  80136b:	0f b6 12             	movzbl (%edx),%edx
  80136e:	29 d0                	sub    %edx,%eax
  801370:	eb 05                	jmp    801377 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801372:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801377:	5b                   	pop    %ebx
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801384:	eb 07                	jmp    80138d <strchr+0x13>
		if (*s == c)
  801386:	38 ca                	cmp    %cl,%dl
  801388:	74 0f                	je     801399 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80138a:	83 c0 01             	add    $0x1,%eax
  80138d:	0f b6 10             	movzbl (%eax),%edx
  801390:	84 d2                	test   %dl,%dl
  801392:	75 f2                	jne    801386 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801394:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    

0080139b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013a5:	eb 07                	jmp    8013ae <strfind+0x13>
		if (*s == c)
  8013a7:	38 ca                	cmp    %cl,%dl
  8013a9:	74 0a                	je     8013b5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013ab:	83 c0 01             	add    $0x1,%eax
  8013ae:	0f b6 10             	movzbl (%eax),%edx
  8013b1:	84 d2                	test   %dl,%dl
  8013b3:	75 f2                	jne    8013a7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8013b5:	5d                   	pop    %ebp
  8013b6:	c3                   	ret    

008013b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	57                   	push   %edi
  8013bb:	56                   	push   %esi
  8013bc:	53                   	push   %ebx
  8013bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8013c3:	85 c9                	test   %ecx,%ecx
  8013c5:	74 36                	je     8013fd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8013c7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8013cd:	75 28                	jne    8013f7 <memset+0x40>
  8013cf:	f6 c1 03             	test   $0x3,%cl
  8013d2:	75 23                	jne    8013f7 <memset+0x40>
		c &= 0xFF;
  8013d4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013d8:	89 d3                	mov    %edx,%ebx
  8013da:	c1 e3 08             	shl    $0x8,%ebx
  8013dd:	89 d6                	mov    %edx,%esi
  8013df:	c1 e6 18             	shl    $0x18,%esi
  8013e2:	89 d0                	mov    %edx,%eax
  8013e4:	c1 e0 10             	shl    $0x10,%eax
  8013e7:	09 f0                	or     %esi,%eax
  8013e9:	09 c2                	or     %eax,%edx
  8013eb:	89 d0                	mov    %edx,%eax
  8013ed:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013ef:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013f2:	fc                   	cld    
  8013f3:	f3 ab                	rep stos %eax,%es:(%edi)
  8013f5:	eb 06                	jmp    8013fd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fa:	fc                   	cld    
  8013fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8013fd:	89 f8                	mov    %edi,%eax
  8013ff:	5b                   	pop    %ebx
  801400:	5e                   	pop    %esi
  801401:	5f                   	pop    %edi
  801402:	5d                   	pop    %ebp
  801403:	c3                   	ret    

00801404 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	57                   	push   %edi
  801408:	56                   	push   %esi
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80140f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801412:	39 c6                	cmp    %eax,%esi
  801414:	73 35                	jae    80144b <memmove+0x47>
  801416:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801419:	39 d0                	cmp    %edx,%eax
  80141b:	73 2e                	jae    80144b <memmove+0x47>
		s += n;
		d += n;
  80141d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801420:	89 d6                	mov    %edx,%esi
  801422:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801424:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80142a:	75 13                	jne    80143f <memmove+0x3b>
  80142c:	f6 c1 03             	test   $0x3,%cl
  80142f:	75 0e                	jne    80143f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801431:	83 ef 04             	sub    $0x4,%edi
  801434:	8d 72 fc             	lea    -0x4(%edx),%esi
  801437:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80143a:	fd                   	std    
  80143b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80143d:	eb 09                	jmp    801448 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80143f:	83 ef 01             	sub    $0x1,%edi
  801442:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801445:	fd                   	std    
  801446:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801448:	fc                   	cld    
  801449:	eb 1d                	jmp    801468 <memmove+0x64>
  80144b:	89 f2                	mov    %esi,%edx
  80144d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80144f:	f6 c2 03             	test   $0x3,%dl
  801452:	75 0f                	jne    801463 <memmove+0x5f>
  801454:	f6 c1 03             	test   $0x3,%cl
  801457:	75 0a                	jne    801463 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801459:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80145c:	89 c7                	mov    %eax,%edi
  80145e:	fc                   	cld    
  80145f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801461:	eb 05                	jmp    801468 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801463:	89 c7                	mov    %eax,%edi
  801465:	fc                   	cld    
  801466:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801468:	5e                   	pop    %esi
  801469:	5f                   	pop    %edi
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    

0080146c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801472:	8b 45 10             	mov    0x10(%ebp),%eax
  801475:	89 44 24 08          	mov    %eax,0x8(%esp)
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	89 04 24             	mov    %eax,(%esp)
  801486:	e8 79 ff ff ff       	call   801404 <memmove>
}
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	56                   	push   %esi
  801491:	53                   	push   %ebx
  801492:	8b 55 08             	mov    0x8(%ebp),%edx
  801495:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801498:	89 d6                	mov    %edx,%esi
  80149a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80149d:	eb 1a                	jmp    8014b9 <memcmp+0x2c>
		if (*s1 != *s2)
  80149f:	0f b6 02             	movzbl (%edx),%eax
  8014a2:	0f b6 19             	movzbl (%ecx),%ebx
  8014a5:	38 d8                	cmp    %bl,%al
  8014a7:	74 0a                	je     8014b3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8014a9:	0f b6 c0             	movzbl %al,%eax
  8014ac:	0f b6 db             	movzbl %bl,%ebx
  8014af:	29 d8                	sub    %ebx,%eax
  8014b1:	eb 0f                	jmp    8014c2 <memcmp+0x35>
		s1++, s2++;
  8014b3:	83 c2 01             	add    $0x1,%edx
  8014b6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014b9:	39 f2                	cmp    %esi,%edx
  8014bb:	75 e2                	jne    80149f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c2:	5b                   	pop    %ebx
  8014c3:	5e                   	pop    %esi
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    

008014c6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8014d4:	eb 07                	jmp    8014dd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014d6:	38 08                	cmp    %cl,(%eax)
  8014d8:	74 07                	je     8014e1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014da:	83 c0 01             	add    $0x1,%eax
  8014dd:	39 d0                	cmp    %edx,%eax
  8014df:	72 f5                	jb     8014d6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8014e1:	5d                   	pop    %ebp
  8014e2:	c3                   	ret    

008014e3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	57                   	push   %edi
  8014e7:	56                   	push   %esi
  8014e8:	53                   	push   %ebx
  8014e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ec:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ef:	eb 03                	jmp    8014f4 <strtol+0x11>
		s++;
  8014f1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014f4:	0f b6 0a             	movzbl (%edx),%ecx
  8014f7:	80 f9 09             	cmp    $0x9,%cl
  8014fa:	74 f5                	je     8014f1 <strtol+0xe>
  8014fc:	80 f9 20             	cmp    $0x20,%cl
  8014ff:	74 f0                	je     8014f1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  801501:	80 f9 2b             	cmp    $0x2b,%cl
  801504:	75 0a                	jne    801510 <strtol+0x2d>
		s++;
  801506:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801509:	bf 00 00 00 00       	mov    $0x0,%edi
  80150e:	eb 11                	jmp    801521 <strtol+0x3e>
  801510:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801515:	80 f9 2d             	cmp    $0x2d,%cl
  801518:	75 07                	jne    801521 <strtol+0x3e>
		s++, neg = 1;
  80151a:	8d 52 01             	lea    0x1(%edx),%edx
  80151d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801521:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801526:	75 15                	jne    80153d <strtol+0x5a>
  801528:	80 3a 30             	cmpb   $0x30,(%edx)
  80152b:	75 10                	jne    80153d <strtol+0x5a>
  80152d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801531:	75 0a                	jne    80153d <strtol+0x5a>
		s += 2, base = 16;
  801533:	83 c2 02             	add    $0x2,%edx
  801536:	b8 10 00 00 00       	mov    $0x10,%eax
  80153b:	eb 10                	jmp    80154d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80153d:	85 c0                	test   %eax,%eax
  80153f:	75 0c                	jne    80154d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801541:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801543:	80 3a 30             	cmpb   $0x30,(%edx)
  801546:	75 05                	jne    80154d <strtol+0x6a>
		s++, base = 8;
  801548:	83 c2 01             	add    $0x1,%edx
  80154b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80154d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801552:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801555:	0f b6 0a             	movzbl (%edx),%ecx
  801558:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80155b:	89 f0                	mov    %esi,%eax
  80155d:	3c 09                	cmp    $0x9,%al
  80155f:	77 08                	ja     801569 <strtol+0x86>
			dig = *s - '0';
  801561:	0f be c9             	movsbl %cl,%ecx
  801564:	83 e9 30             	sub    $0x30,%ecx
  801567:	eb 20                	jmp    801589 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801569:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80156c:	89 f0                	mov    %esi,%eax
  80156e:	3c 19                	cmp    $0x19,%al
  801570:	77 08                	ja     80157a <strtol+0x97>
			dig = *s - 'a' + 10;
  801572:	0f be c9             	movsbl %cl,%ecx
  801575:	83 e9 57             	sub    $0x57,%ecx
  801578:	eb 0f                	jmp    801589 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80157a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80157d:	89 f0                	mov    %esi,%eax
  80157f:	3c 19                	cmp    $0x19,%al
  801581:	77 16                	ja     801599 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801583:	0f be c9             	movsbl %cl,%ecx
  801586:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801589:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80158c:	7d 0f                	jge    80159d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80158e:	83 c2 01             	add    $0x1,%edx
  801591:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801595:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801597:	eb bc                	jmp    801555 <strtol+0x72>
  801599:	89 d8                	mov    %ebx,%eax
  80159b:	eb 02                	jmp    80159f <strtol+0xbc>
  80159d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80159f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015a3:	74 05                	je     8015aa <strtol+0xc7>
		*endptr = (char *) s;
  8015a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015a8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8015aa:	f7 d8                	neg    %eax
  8015ac:	85 ff                	test   %edi,%edi
  8015ae:	0f 44 c3             	cmove  %ebx,%eax
}
  8015b1:	5b                   	pop    %ebx
  8015b2:	5e                   	pop    %esi
  8015b3:	5f                   	pop    %edi
  8015b4:	5d                   	pop    %ebp
  8015b5:	c3                   	ret    

008015b6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	57                   	push   %edi
  8015ba:	56                   	push   %esi
  8015bb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c7:	89 c3                	mov    %eax,%ebx
  8015c9:	89 c7                	mov    %eax,%edi
  8015cb:	89 c6                	mov    %eax,%esi
  8015cd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8015cf:	5b                   	pop    %ebx
  8015d0:	5e                   	pop    %esi
  8015d1:	5f                   	pop    %edi
  8015d2:	5d                   	pop    %ebp
  8015d3:	c3                   	ret    

008015d4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	57                   	push   %edi
  8015d8:	56                   	push   %esi
  8015d9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015da:	ba 00 00 00 00       	mov    $0x0,%edx
  8015df:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e4:	89 d1                	mov    %edx,%ecx
  8015e6:	89 d3                	mov    %edx,%ebx
  8015e8:	89 d7                	mov    %edx,%edi
  8015ea:	89 d6                	mov    %edx,%esi
  8015ec:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8015ee:	5b                   	pop    %ebx
  8015ef:	5e                   	pop    %esi
  8015f0:	5f                   	pop    %edi
  8015f1:	5d                   	pop    %ebp
  8015f2:	c3                   	ret    

008015f3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	57                   	push   %edi
  8015f7:	56                   	push   %esi
  8015f8:	53                   	push   %ebx
  8015f9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801601:	b8 03 00 00 00       	mov    $0x3,%eax
  801606:	8b 55 08             	mov    0x8(%ebp),%edx
  801609:	89 cb                	mov    %ecx,%ebx
  80160b:	89 cf                	mov    %ecx,%edi
  80160d:	89 ce                	mov    %ecx,%esi
  80160f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801611:	85 c0                	test   %eax,%eax
  801613:	7e 28                	jle    80163d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801615:	89 44 24 10          	mov    %eax,0x10(%esp)
  801619:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801620:	00 
  801621:	c7 44 24 08 ef 40 80 	movl   $0x8040ef,0x8(%esp)
  801628:	00 
  801629:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801630:	00 
  801631:	c7 04 24 0c 41 80 00 	movl   $0x80410c,(%esp)
  801638:	e8 14 f4 ff ff       	call   800a51 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80163d:	83 c4 2c             	add    $0x2c,%esp
  801640:	5b                   	pop    %ebx
  801641:	5e                   	pop    %esi
  801642:	5f                   	pop    %edi
  801643:	5d                   	pop    %ebp
  801644:	c3                   	ret    

00801645 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	57                   	push   %edi
  801649:	56                   	push   %esi
  80164a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80164b:	ba 00 00 00 00       	mov    $0x0,%edx
  801650:	b8 02 00 00 00       	mov    $0x2,%eax
  801655:	89 d1                	mov    %edx,%ecx
  801657:	89 d3                	mov    %edx,%ebx
  801659:	89 d7                	mov    %edx,%edi
  80165b:	89 d6                	mov    %edx,%esi
  80165d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80165f:	5b                   	pop    %ebx
  801660:	5e                   	pop    %esi
  801661:	5f                   	pop    %edi
  801662:	5d                   	pop    %ebp
  801663:	c3                   	ret    

00801664 <sys_yield>:

void
sys_yield(void)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	57                   	push   %edi
  801668:	56                   	push   %esi
  801669:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80166a:	ba 00 00 00 00       	mov    $0x0,%edx
  80166f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801674:	89 d1                	mov    %edx,%ecx
  801676:	89 d3                	mov    %edx,%ebx
  801678:	89 d7                	mov    %edx,%edi
  80167a:	89 d6                	mov    %edx,%esi
  80167c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80167e:	5b                   	pop    %ebx
  80167f:	5e                   	pop    %esi
  801680:	5f                   	pop    %edi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	57                   	push   %edi
  801687:	56                   	push   %esi
  801688:	53                   	push   %ebx
  801689:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80168c:	be 00 00 00 00       	mov    $0x0,%esi
  801691:	b8 04 00 00 00       	mov    $0x4,%eax
  801696:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801699:	8b 55 08             	mov    0x8(%ebp),%edx
  80169c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80169f:	89 f7                	mov    %esi,%edi
  8016a1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	7e 28                	jle    8016cf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016ab:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8016b2:	00 
  8016b3:	c7 44 24 08 ef 40 80 	movl   $0x8040ef,0x8(%esp)
  8016ba:	00 
  8016bb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016c2:	00 
  8016c3:	c7 04 24 0c 41 80 00 	movl   $0x80410c,(%esp)
  8016ca:	e8 82 f3 ff ff       	call   800a51 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8016cf:	83 c4 2c             	add    $0x2c,%esp
  8016d2:	5b                   	pop    %ebx
  8016d3:	5e                   	pop    %esi
  8016d4:	5f                   	pop    %edi
  8016d5:	5d                   	pop    %ebp
  8016d6:	c3                   	ret    

008016d7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	57                   	push   %edi
  8016db:	56                   	push   %esi
  8016dc:	53                   	push   %ebx
  8016dd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8016e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016ee:	8b 7d 14             	mov    0x14(%ebp),%edi
  8016f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8016f4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	7e 28                	jle    801722 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016fa:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016fe:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801705:	00 
  801706:	c7 44 24 08 ef 40 80 	movl   $0x8040ef,0x8(%esp)
  80170d:	00 
  80170e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801715:	00 
  801716:	c7 04 24 0c 41 80 00 	movl   $0x80410c,(%esp)
  80171d:	e8 2f f3 ff ff       	call   800a51 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801722:	83 c4 2c             	add    $0x2c,%esp
  801725:	5b                   	pop    %ebx
  801726:	5e                   	pop    %esi
  801727:	5f                   	pop    %edi
  801728:	5d                   	pop    %ebp
  801729:	c3                   	ret    

0080172a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	57                   	push   %edi
  80172e:	56                   	push   %esi
  80172f:	53                   	push   %ebx
  801730:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801733:	bb 00 00 00 00       	mov    $0x0,%ebx
  801738:	b8 06 00 00 00       	mov    $0x6,%eax
  80173d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801740:	8b 55 08             	mov    0x8(%ebp),%edx
  801743:	89 df                	mov    %ebx,%edi
  801745:	89 de                	mov    %ebx,%esi
  801747:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801749:	85 c0                	test   %eax,%eax
  80174b:	7e 28                	jle    801775 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80174d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801751:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801758:	00 
  801759:	c7 44 24 08 ef 40 80 	movl   $0x8040ef,0x8(%esp)
  801760:	00 
  801761:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801768:	00 
  801769:	c7 04 24 0c 41 80 00 	movl   $0x80410c,(%esp)
  801770:	e8 dc f2 ff ff       	call   800a51 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801775:	83 c4 2c             	add    $0x2c,%esp
  801778:	5b                   	pop    %ebx
  801779:	5e                   	pop    %esi
  80177a:	5f                   	pop    %edi
  80177b:	5d                   	pop    %ebp
  80177c:	c3                   	ret    

0080177d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	57                   	push   %edi
  801781:	56                   	push   %esi
  801782:	53                   	push   %ebx
  801783:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801786:	bb 00 00 00 00       	mov    $0x0,%ebx
  80178b:	b8 08 00 00 00       	mov    $0x8,%eax
  801790:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801793:	8b 55 08             	mov    0x8(%ebp),%edx
  801796:	89 df                	mov    %ebx,%edi
  801798:	89 de                	mov    %ebx,%esi
  80179a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80179c:	85 c0                	test   %eax,%eax
  80179e:	7e 28                	jle    8017c8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017a4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8017ab:	00 
  8017ac:	c7 44 24 08 ef 40 80 	movl   $0x8040ef,0x8(%esp)
  8017b3:	00 
  8017b4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017bb:	00 
  8017bc:	c7 04 24 0c 41 80 00 	movl   $0x80410c,(%esp)
  8017c3:	e8 89 f2 ff ff       	call   800a51 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8017c8:	83 c4 2c             	add    $0x2c,%esp
  8017cb:	5b                   	pop    %ebx
  8017cc:	5e                   	pop    %esi
  8017cd:	5f                   	pop    %edi
  8017ce:	5d                   	pop    %ebp
  8017cf:	c3                   	ret    

008017d0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	57                   	push   %edi
  8017d4:	56                   	push   %esi
  8017d5:	53                   	push   %ebx
  8017d6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017de:	b8 09 00 00 00       	mov    $0x9,%eax
  8017e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e9:	89 df                	mov    %ebx,%edi
  8017eb:	89 de                	mov    %ebx,%esi
  8017ed:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	7e 28                	jle    80181b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017f3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017f7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8017fe:	00 
  8017ff:	c7 44 24 08 ef 40 80 	movl   $0x8040ef,0x8(%esp)
  801806:	00 
  801807:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80180e:	00 
  80180f:	c7 04 24 0c 41 80 00 	movl   $0x80410c,(%esp)
  801816:	e8 36 f2 ff ff       	call   800a51 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80181b:	83 c4 2c             	add    $0x2c,%esp
  80181e:	5b                   	pop    %ebx
  80181f:	5e                   	pop    %esi
  801820:	5f                   	pop    %edi
  801821:	5d                   	pop    %ebp
  801822:	c3                   	ret    

00801823 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	57                   	push   %edi
  801827:	56                   	push   %esi
  801828:	53                   	push   %ebx
  801829:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801831:	b8 0a 00 00 00       	mov    $0xa,%eax
  801836:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801839:	8b 55 08             	mov    0x8(%ebp),%edx
  80183c:	89 df                	mov    %ebx,%edi
  80183e:	89 de                	mov    %ebx,%esi
  801840:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801842:	85 c0                	test   %eax,%eax
  801844:	7e 28                	jle    80186e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801846:	89 44 24 10          	mov    %eax,0x10(%esp)
  80184a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801851:	00 
  801852:	c7 44 24 08 ef 40 80 	movl   $0x8040ef,0x8(%esp)
  801859:	00 
  80185a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801861:	00 
  801862:	c7 04 24 0c 41 80 00 	movl   $0x80410c,(%esp)
  801869:	e8 e3 f1 ff ff       	call   800a51 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80186e:	83 c4 2c             	add    $0x2c,%esp
  801871:	5b                   	pop    %ebx
  801872:	5e                   	pop    %esi
  801873:	5f                   	pop    %edi
  801874:	5d                   	pop    %ebp
  801875:	c3                   	ret    

00801876 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	57                   	push   %edi
  80187a:	56                   	push   %esi
  80187b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80187c:	be 00 00 00 00       	mov    $0x0,%esi
  801881:	b8 0c 00 00 00       	mov    $0xc,%eax
  801886:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801889:	8b 55 08             	mov    0x8(%ebp),%edx
  80188c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80188f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801892:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801894:	5b                   	pop    %ebx
  801895:	5e                   	pop    %esi
  801896:	5f                   	pop    %edi
  801897:	5d                   	pop    %ebp
  801898:	c3                   	ret    

00801899 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	57                   	push   %edi
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018a7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8018ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8018af:	89 cb                	mov    %ecx,%ebx
  8018b1:	89 cf                	mov    %ecx,%edi
  8018b3:	89 ce                	mov    %ecx,%esi
  8018b5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	7e 28                	jle    8018e3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018bb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018bf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8018c6:	00 
  8018c7:	c7 44 24 08 ef 40 80 	movl   $0x8040ef,0x8(%esp)
  8018ce:	00 
  8018cf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018d6:	00 
  8018d7:	c7 04 24 0c 41 80 00 	movl   $0x80410c,(%esp)
  8018de:	e8 6e f1 ff ff       	call   800a51 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8018e3:	83 c4 2c             	add    $0x2c,%esp
  8018e6:	5b                   	pop    %ebx
  8018e7:	5e                   	pop    %esi
  8018e8:	5f                   	pop    %edi
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    

008018eb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	57                   	push   %edi
  8018ef:	56                   	push   %esi
  8018f0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8018fb:	89 d1                	mov    %edx,%ecx
  8018fd:	89 d3                	mov    %edx,%ebx
  8018ff:	89 d7                	mov    %edx,%edi
  801901:	89 d6                	mov    %edx,%esi
  801903:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801905:	5b                   	pop    %ebx
  801906:	5e                   	pop    %esi
  801907:	5f                   	pop    %edi
  801908:	5d                   	pop    %ebp
  801909:	c3                   	ret    

0080190a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	57                   	push   %edi
  80190e:	56                   	push   %esi
  80190f:	53                   	push   %ebx
  801910:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801913:	bb 00 00 00 00       	mov    $0x0,%ebx
  801918:	b8 0f 00 00 00       	mov    $0xf,%eax
  80191d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801920:	8b 55 08             	mov    0x8(%ebp),%edx
  801923:	89 df                	mov    %ebx,%edi
  801925:	89 de                	mov    %ebx,%esi
  801927:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801929:	85 c0                	test   %eax,%eax
  80192b:	7e 28                	jle    801955 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80192d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801931:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801938:	00 
  801939:	c7 44 24 08 ef 40 80 	movl   $0x8040ef,0x8(%esp)
  801940:	00 
  801941:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801948:	00 
  801949:	c7 04 24 0c 41 80 00 	movl   $0x80410c,(%esp)
  801950:	e8 fc f0 ff ff       	call   800a51 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801955:	83 c4 2c             	add    $0x2c,%esp
  801958:	5b                   	pop    %ebx
  801959:	5e                   	pop    %esi
  80195a:	5f                   	pop    %edi
  80195b:	5d                   	pop    %ebp
  80195c:	c3                   	ret    

0080195d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	57                   	push   %edi
  801961:	56                   	push   %esi
  801962:	53                   	push   %ebx
  801963:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801966:	bb 00 00 00 00       	mov    $0x0,%ebx
  80196b:	b8 10 00 00 00       	mov    $0x10,%eax
  801970:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801973:	8b 55 08             	mov    0x8(%ebp),%edx
  801976:	89 df                	mov    %ebx,%edi
  801978:	89 de                	mov    %ebx,%esi
  80197a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80197c:	85 c0                	test   %eax,%eax
  80197e:	7e 28                	jle    8019a8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801980:	89 44 24 10          	mov    %eax,0x10(%esp)
  801984:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80198b:	00 
  80198c:	c7 44 24 08 ef 40 80 	movl   $0x8040ef,0x8(%esp)
  801993:	00 
  801994:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80199b:	00 
  80199c:	c7 04 24 0c 41 80 00 	movl   $0x80410c,(%esp)
  8019a3:	e8 a9 f0 ff ff       	call   800a51 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  8019a8:	83 c4 2c             	add    $0x2c,%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5f                   	pop    %edi
  8019ae:	5d                   	pop    %ebp
  8019af:	c3                   	ret    

008019b0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 24             	sub    $0x24,%esp
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  8019ba:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  8019bc:	89 d3                	mov    %edx,%ebx
  8019be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  8019c4:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8019c8:	74 1a                	je     8019e4 <pgfault+0x34>
  8019ca:	c1 ea 0c             	shr    $0xc,%edx
  8019cd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019d4:	a8 01                	test   $0x1,%al
  8019d6:	74 0c                	je     8019e4 <pgfault+0x34>
  8019d8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019df:	f6 c4 08             	test   $0x8,%ah
  8019e2:	75 1c                	jne    801a00 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  8019e4:	c7 44 24 08 1c 41 80 	movl   $0x80411c,0x8(%esp)
  8019eb:	00 
  8019ec:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8019f3:	00 
  8019f4:	c7 04 24 6b 42 80 00 	movl   $0x80426b,(%esp)
  8019fb:	e8 51 f0 ff ff       	call   800a51 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  801a00:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a07:	00 
  801a08:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801a0f:	00 
  801a10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a17:	e8 67 fc ff ff       	call   801683 <sys_page_alloc>
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	79 1c                	jns    801a3c <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  801a20:	c7 44 24 08 60 41 80 	movl   $0x804160,0x8(%esp)
  801a27:	00 
  801a28:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801a2f:	00 
  801a30:	c7 04 24 6b 42 80 00 	movl   $0x80426b,(%esp)
  801a37:	e8 15 f0 ff ff       	call   800a51 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  801a3c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801a43:	00 
  801a44:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a48:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801a4f:	e8 18 fa ff ff       	call   80146c <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  801a54:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801a5b:	00 
  801a5c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a60:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a67:	00 
  801a68:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801a6f:	00 
  801a70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a77:	e8 5b fc ff ff       	call   8016d7 <sys_page_map>
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	74 1c                	je     801a9c <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  801a80:	c7 44 24 08 76 42 80 	movl   $0x804276,0x8(%esp)
  801a87:	00 
  801a88:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  801a8f:	00 
  801a90:	c7 04 24 6b 42 80 00 	movl   $0x80426b,(%esp)
  801a97:	e8 b5 ef ff ff       	call   800a51 <_panic>
    sys_page_unmap(0,PFTEMP);
  801a9c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801aa3:	00 
  801aa4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aab:	e8 7a fc ff ff       	call   80172a <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  801ab0:	83 c4 24             	add    $0x24,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5d                   	pop    %ebp
  801ab5:	c3                   	ret    

00801ab6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	57                   	push   %edi
  801aba:	56                   	push   %esi
  801abb:	53                   	push   %ebx
  801abc:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  801abf:	c7 04 24 b0 19 80 00 	movl   $0x8019b0,(%esp)
  801ac6:	e8 6f 1c 00 00       	call   80373a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801acb:	b8 07 00 00 00       	mov    $0x7,%eax
  801ad0:	cd 30                	int    $0x30
  801ad2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ad5:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801ad7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801adc:	85 c0                	test   %eax,%eax
  801ade:	75 21                	jne    801b01 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801ae0:	e8 60 fb ff ff       	call   801645 <sys_getenvid>
  801ae5:	25 ff 03 00 00       	and    $0x3ff,%eax
  801aea:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801aed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801af2:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801af7:	b8 00 00 00 00       	mov    $0x0,%eax
  801afc:	e9 de 01 00 00       	jmp    801cdf <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  801b01:	89 d8                	mov    %ebx,%eax
  801b03:	c1 e8 16             	shr    $0x16,%eax
  801b06:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b0d:	a8 01                	test   $0x1,%al
  801b0f:	0f 84 58 01 00 00    	je     801c6d <fork+0x1b7>
  801b15:	89 de                	mov    %ebx,%esi
  801b17:	c1 ee 0c             	shr    $0xc,%esi
  801b1a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b21:	83 e0 05             	and    $0x5,%eax
  801b24:	83 f8 05             	cmp    $0x5,%eax
  801b27:	0f 85 40 01 00 00    	jne    801c6d <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  801b2d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b34:	f6 c4 04             	test   $0x4,%ah
  801b37:	74 4f                	je     801b88 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  801b39:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b40:	c1 e6 0c             	shl    $0xc,%esi
  801b43:	25 07 0e 00 00       	and    $0xe07,%eax
  801b48:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b4c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801b50:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801b54:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b5f:	e8 73 fb ff ff       	call   8016d7 <sys_page_map>
  801b64:	85 c0                	test   %eax,%eax
  801b66:	0f 89 01 01 00 00    	jns    801c6d <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  801b6c:	c7 44 24 08 80 41 80 	movl   $0x804180,0x8(%esp)
  801b73:	00 
  801b74:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  801b7b:	00 
  801b7c:	c7 04 24 6b 42 80 00 	movl   $0x80426b,(%esp)
  801b83:	e8 c9 ee ff ff       	call   800a51 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  801b88:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b8f:	a8 02                	test   $0x2,%al
  801b91:	75 10                	jne    801ba3 <fork+0xed>
  801b93:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b9a:	f6 c4 08             	test   $0x8,%ah
  801b9d:	0f 84 87 00 00 00    	je     801c2a <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  801ba3:	c1 e6 0c             	shl    $0xc,%esi
  801ba6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801bad:	00 
  801bae:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801bb2:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801bb6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bc1:	e8 11 fb ff ff       	call   8016d7 <sys_page_map>
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	79 1c                	jns    801be6 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  801bca:	c7 44 24 08 b8 41 80 	movl   $0x8041b8,0x8(%esp)
  801bd1:	00 
  801bd2:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801bd9:	00 
  801bda:	c7 04 24 6b 42 80 00 	movl   $0x80426b,(%esp)
  801be1:	e8 6b ee ff ff       	call   800a51 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  801be6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801bed:	00 
  801bee:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801bf2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bf9:	00 
  801bfa:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bfe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c05:	e8 cd fa ff ff       	call   8016d7 <sys_page_map>
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	79 5f                	jns    801c6d <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  801c0e:	c7 44 24 08 f0 41 80 	movl   $0x8041f0,0x8(%esp)
  801c15:	00 
  801c16:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  801c1d:	00 
  801c1e:	c7 04 24 6b 42 80 00 	movl   $0x80426b,(%esp)
  801c25:	e8 27 ee ff ff       	call   800a51 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  801c2a:	c1 e6 0c             	shl    $0xc,%esi
  801c2d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801c34:	00 
  801c35:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c39:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801c3d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c48:	e8 8a fa ff ff       	call   8016d7 <sys_page_map>
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	74 1c                	je     801c6d <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801c51:	c7 44 24 08 18 42 80 	movl   $0x804218,0x8(%esp)
  801c58:	00 
  801c59:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801c60:	00 
  801c61:	c7 04 24 6b 42 80 00 	movl   $0x80426b,(%esp)
  801c68:	e8 e4 ed ff ff       	call   800a51 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  801c6d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c73:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801c79:	0f 85 82 fe ff ff    	jne    801b01 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  801c7f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c86:	00 
  801c87:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801c8e:	ee 
  801c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c92:	89 04 24             	mov    %eax,(%esp)
  801c95:	e8 e9 f9 ff ff       	call   801683 <sys_page_alloc>
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	79 1c                	jns    801cba <fork+0x204>
      panic("sys_page_alloc failure in fork");
  801c9e:	c7 44 24 08 4c 42 80 	movl   $0x80424c,0x8(%esp)
  801ca5:	00 
  801ca6:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  801cad:	00 
  801cae:	c7 04 24 6b 42 80 00 	movl   $0x80426b,(%esp)
  801cb5:	e8 97 ed ff ff       	call   800a51 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  801cba:	c7 44 24 04 ab 37 80 	movl   $0x8037ab,0x4(%esp)
  801cc1:	00 
  801cc2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801cc5:	89 3c 24             	mov    %edi,(%esp)
  801cc8:	e8 56 fb ff ff       	call   801823 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  801ccd:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801cd4:	00 
  801cd5:	89 3c 24             	mov    %edi,(%esp)
  801cd8:	e8 a0 fa ff ff       	call   80177d <sys_env_set_status>
		return child;
  801cdd:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  801cdf:	83 c4 2c             	add    $0x2c,%esp
  801ce2:	5b                   	pop    %ebx
  801ce3:	5e                   	pop    %esi
  801ce4:	5f                   	pop    %edi
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    

00801ce7 <sfork>:

// Challenge!
int
sfork(void)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801ced:	c7 44 24 08 94 42 80 	movl   $0x804294,0x8(%esp)
  801cf4:	00 
  801cf5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  801cfc:	00 
  801cfd:	c7 04 24 6b 42 80 00 	movl   $0x80426b,(%esp)
  801d04:	e8 48 ed ff ff       	call   800a51 <_panic>

00801d09 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	53                   	push   %ebx
  801d0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d13:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801d16:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  801d18:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801d1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d20:	83 39 01             	cmpl   $0x1,(%ecx)
  801d23:	7e 0f                	jle    801d34 <argstart+0x2b>
  801d25:	85 d2                	test   %edx,%edx
  801d27:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2c:	bb c1 3b 80 00       	mov    $0x803bc1,%ebx
  801d31:	0f 44 da             	cmove  %edx,%ebx
  801d34:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  801d37:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801d3e:	5b                   	pop    %ebx
  801d3f:	5d                   	pop    %ebp
  801d40:	c3                   	ret    

00801d41 <argnext>:

int
argnext(struct Argstate *args)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	53                   	push   %ebx
  801d45:	83 ec 14             	sub    $0x14,%esp
  801d48:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801d4b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801d52:	8b 43 08             	mov    0x8(%ebx),%eax
  801d55:	85 c0                	test   %eax,%eax
  801d57:	74 71                	je     801dca <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801d59:	80 38 00             	cmpb   $0x0,(%eax)
  801d5c:	75 50                	jne    801dae <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801d5e:	8b 0b                	mov    (%ebx),%ecx
  801d60:	83 39 01             	cmpl   $0x1,(%ecx)
  801d63:	74 57                	je     801dbc <argnext+0x7b>
		    || args->argv[1][0] != '-'
  801d65:	8b 53 04             	mov    0x4(%ebx),%edx
  801d68:	8b 42 04             	mov    0x4(%edx),%eax
  801d6b:	80 38 2d             	cmpb   $0x2d,(%eax)
  801d6e:	75 4c                	jne    801dbc <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801d70:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801d74:	74 46                	je     801dbc <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801d76:	83 c0 01             	add    $0x1,%eax
  801d79:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d7c:	8b 01                	mov    (%ecx),%eax
  801d7e:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801d85:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d89:	8d 42 08             	lea    0x8(%edx),%eax
  801d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d90:	83 c2 04             	add    $0x4,%edx
  801d93:	89 14 24             	mov    %edx,(%esp)
  801d96:	e8 69 f6 ff ff       	call   801404 <memmove>
		(*args->argc)--;
  801d9b:	8b 03                	mov    (%ebx),%eax
  801d9d:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801da0:	8b 43 08             	mov    0x8(%ebx),%eax
  801da3:	80 38 2d             	cmpb   $0x2d,(%eax)
  801da6:	75 06                	jne    801dae <argnext+0x6d>
  801da8:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801dac:	74 0e                	je     801dbc <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801dae:	8b 53 08             	mov    0x8(%ebx),%edx
  801db1:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801db4:	83 c2 01             	add    $0x1,%edx
  801db7:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801dba:	eb 13                	jmp    801dcf <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  801dbc:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801dc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801dc8:	eb 05                	jmp    801dcf <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  801dca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801dcf:	83 c4 14             	add    $0x14,%esp
  801dd2:	5b                   	pop    %ebx
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    

00801dd5 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	53                   	push   %ebx
  801dd9:	83 ec 14             	sub    $0x14,%esp
  801ddc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801ddf:	8b 43 08             	mov    0x8(%ebx),%eax
  801de2:	85 c0                	test   %eax,%eax
  801de4:	74 5a                	je     801e40 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  801de6:	80 38 00             	cmpb   $0x0,(%eax)
  801de9:	74 0c                	je     801df7 <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801deb:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801dee:	c7 43 08 c1 3b 80 00 	movl   $0x803bc1,0x8(%ebx)
  801df5:	eb 44                	jmp    801e3b <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  801df7:	8b 03                	mov    (%ebx),%eax
  801df9:	83 38 01             	cmpl   $0x1,(%eax)
  801dfc:	7e 2f                	jle    801e2d <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  801dfe:	8b 53 04             	mov    0x4(%ebx),%edx
  801e01:	8b 4a 04             	mov    0x4(%edx),%ecx
  801e04:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e07:	8b 00                	mov    (%eax),%eax
  801e09:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801e10:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e14:	8d 42 08             	lea    0x8(%edx),%eax
  801e17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1b:	83 c2 04             	add    $0x4,%edx
  801e1e:	89 14 24             	mov    %edx,(%esp)
  801e21:	e8 de f5 ff ff       	call   801404 <memmove>
		(*args->argc)--;
  801e26:	8b 03                	mov    (%ebx),%eax
  801e28:	83 28 01             	subl   $0x1,(%eax)
  801e2b:	eb 0e                	jmp    801e3b <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  801e2d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801e34:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801e3b:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e3e:	eb 05                	jmp    801e45 <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  801e45:	83 c4 14             	add    $0x14,%esp
  801e48:	5b                   	pop    %ebx
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    

00801e4b <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 18             	sub    $0x18,%esp
  801e51:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801e54:	8b 51 0c             	mov    0xc(%ecx),%edx
  801e57:	89 d0                	mov    %edx,%eax
  801e59:	85 d2                	test   %edx,%edx
  801e5b:	75 08                	jne    801e65 <argvalue+0x1a>
  801e5d:	89 0c 24             	mov    %ecx,(%esp)
  801e60:	e8 70 ff ff ff       	call   801dd5 <argnextvalue>
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    
  801e67:	66 90                	xchg   %ax,%ax
  801e69:	66 90                	xchg   %ax,%ax
  801e6b:	66 90                	xchg   %ax,%ax
  801e6d:	66 90                	xchg   %ax,%ax
  801e6f:	90                   	nop

00801e70 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	05 00 00 00 30       	add    $0x30000000,%eax
  801e7b:	c1 e8 0c             	shr    $0xc,%eax
}
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    

00801e80 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801e8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e90:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801e95:	5d                   	pop    %ebp
  801e96:	c3                   	ret    

00801e97 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e9d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ea2:	89 c2                	mov    %eax,%edx
  801ea4:	c1 ea 16             	shr    $0x16,%edx
  801ea7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801eae:	f6 c2 01             	test   $0x1,%dl
  801eb1:	74 11                	je     801ec4 <fd_alloc+0x2d>
  801eb3:	89 c2                	mov    %eax,%edx
  801eb5:	c1 ea 0c             	shr    $0xc,%edx
  801eb8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ebf:	f6 c2 01             	test   $0x1,%dl
  801ec2:	75 09                	jne    801ecd <fd_alloc+0x36>
			*fd_store = fd;
  801ec4:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecb:	eb 17                	jmp    801ee4 <fd_alloc+0x4d>
  801ecd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ed2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801ed7:	75 c9                	jne    801ea2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ed9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801edf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801ee4:	5d                   	pop    %ebp
  801ee5:	c3                   	ret    

00801ee6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801eec:	83 f8 1f             	cmp    $0x1f,%eax
  801eef:	77 36                	ja     801f27 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801ef1:	c1 e0 0c             	shl    $0xc,%eax
  801ef4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ef9:	89 c2                	mov    %eax,%edx
  801efb:	c1 ea 16             	shr    $0x16,%edx
  801efe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801f05:	f6 c2 01             	test   $0x1,%dl
  801f08:	74 24                	je     801f2e <fd_lookup+0x48>
  801f0a:	89 c2                	mov    %eax,%edx
  801f0c:	c1 ea 0c             	shr    $0xc,%edx
  801f0f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f16:	f6 c2 01             	test   $0x1,%dl
  801f19:	74 1a                	je     801f35 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1e:	89 02                	mov    %eax,(%edx)
	return 0;
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
  801f25:	eb 13                	jmp    801f3a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f2c:	eb 0c                	jmp    801f3a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f33:	eb 05                	jmp    801f3a <fd_lookup+0x54>
  801f35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    

00801f3c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 18             	sub    $0x18,%esp
  801f42:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801f45:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4a:	eb 13                	jmp    801f5f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  801f4c:	39 08                	cmp    %ecx,(%eax)
  801f4e:	75 0c                	jne    801f5c <dev_lookup+0x20>
			*dev = devtab[i];
  801f50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f53:	89 01                	mov    %eax,(%ecx)
			return 0;
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5a:	eb 38                	jmp    801f94 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  801f5c:	83 c2 01             	add    $0x1,%edx
  801f5f:	8b 04 95 28 43 80 00 	mov    0x804328(,%edx,4),%eax
  801f66:	85 c0                	test   %eax,%eax
  801f68:	75 e2                	jne    801f4c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f6a:	a1 28 64 80 00       	mov    0x806428,%eax
  801f6f:	8b 40 48             	mov    0x48(%eax),%eax
  801f72:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f76:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7a:	c7 04 24 ac 42 80 00 	movl   $0x8042ac,(%esp)
  801f81:	e8 c4 eb ff ff       	call   800b4a <cprintf>
	*dev = 0;
  801f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801f8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	56                   	push   %esi
  801f9a:	53                   	push   %ebx
  801f9b:	83 ec 20             	sub    $0x20,%esp
  801f9e:	8b 75 08             	mov    0x8(%ebp),%esi
  801fa1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fab:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801fb1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fb4:	89 04 24             	mov    %eax,(%esp)
  801fb7:	e8 2a ff ff ff       	call   801ee6 <fd_lookup>
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	78 05                	js     801fc5 <fd_close+0x2f>
	    || fd != fd2)
  801fc0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801fc3:	74 0c                	je     801fd1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801fc5:	84 db                	test   %bl,%bl
  801fc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fcc:	0f 44 c2             	cmove  %edx,%eax
  801fcf:	eb 3f                	jmp    802010 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fd1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd8:	8b 06                	mov    (%esi),%eax
  801fda:	89 04 24             	mov    %eax,(%esp)
  801fdd:	e8 5a ff ff ff       	call   801f3c <dev_lookup>
  801fe2:	89 c3                	mov    %eax,%ebx
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	78 16                	js     801ffe <fd_close+0x68>
		if (dev->dev_close)
  801fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801feb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801fee:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	74 07                	je     801ffe <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801ff7:	89 34 24             	mov    %esi,(%esp)
  801ffa:	ff d0                	call   *%eax
  801ffc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ffe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802002:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802009:	e8 1c f7 ff ff       	call   80172a <sys_page_unmap>
	return r;
  80200e:	89 d8                	mov    %ebx,%eax
}
  802010:	83 c4 20             	add    $0x20,%esp
  802013:	5b                   	pop    %ebx
  802014:	5e                   	pop    %esi
  802015:	5d                   	pop    %ebp
  802016:	c3                   	ret    

00802017 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80201d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802020:	89 44 24 04          	mov    %eax,0x4(%esp)
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	89 04 24             	mov    %eax,(%esp)
  80202a:	e8 b7 fe ff ff       	call   801ee6 <fd_lookup>
  80202f:	89 c2                	mov    %eax,%edx
  802031:	85 d2                	test   %edx,%edx
  802033:	78 13                	js     802048 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  802035:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80203c:	00 
  80203d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802040:	89 04 24             	mov    %eax,(%esp)
  802043:	e8 4e ff ff ff       	call   801f96 <fd_close>
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <close_all>:

void
close_all(void)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	53                   	push   %ebx
  80204e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802051:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802056:	89 1c 24             	mov    %ebx,(%esp)
  802059:	e8 b9 ff ff ff       	call   802017 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80205e:	83 c3 01             	add    $0x1,%ebx
  802061:	83 fb 20             	cmp    $0x20,%ebx
  802064:	75 f0                	jne    802056 <close_all+0xc>
		close(i);
}
  802066:	83 c4 14             	add    $0x14,%esp
  802069:	5b                   	pop    %ebx
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    

0080206c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	57                   	push   %edi
  802070:	56                   	push   %esi
  802071:	53                   	push   %ebx
  802072:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802075:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802078:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	89 04 24             	mov    %eax,(%esp)
  802082:	e8 5f fe ff ff       	call   801ee6 <fd_lookup>
  802087:	89 c2                	mov    %eax,%edx
  802089:	85 d2                	test   %edx,%edx
  80208b:	0f 88 e1 00 00 00    	js     802172 <dup+0x106>
		return r;
	close(newfdnum);
  802091:	8b 45 0c             	mov    0xc(%ebp),%eax
  802094:	89 04 24             	mov    %eax,(%esp)
  802097:	e8 7b ff ff ff       	call   802017 <close>

	newfd = INDEX2FD(newfdnum);
  80209c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80209f:	c1 e3 0c             	shl    $0xc,%ebx
  8020a2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8020a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ab:	89 04 24             	mov    %eax,(%esp)
  8020ae:	e8 cd fd ff ff       	call   801e80 <fd2data>
  8020b3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8020b5:	89 1c 24             	mov    %ebx,(%esp)
  8020b8:	e8 c3 fd ff ff       	call   801e80 <fd2data>
  8020bd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020bf:	89 f0                	mov    %esi,%eax
  8020c1:	c1 e8 16             	shr    $0x16,%eax
  8020c4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8020cb:	a8 01                	test   $0x1,%al
  8020cd:	74 43                	je     802112 <dup+0xa6>
  8020cf:	89 f0                	mov    %esi,%eax
  8020d1:	c1 e8 0c             	shr    $0xc,%eax
  8020d4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8020db:	f6 c2 01             	test   $0x1,%dl
  8020de:	74 32                	je     802112 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8020ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8020f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020fb:	00 
  8020fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802100:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802107:	e8 cb f5 ff ff       	call   8016d7 <sys_page_map>
  80210c:	89 c6                	mov    %eax,%esi
  80210e:	85 c0                	test   %eax,%eax
  802110:	78 3e                	js     802150 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802115:	89 c2                	mov    %eax,%edx
  802117:	c1 ea 0c             	shr    $0xc,%edx
  80211a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802121:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802127:	89 54 24 10          	mov    %edx,0x10(%esp)
  80212b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80212f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802136:	00 
  802137:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802142:	e8 90 f5 ff ff       	call   8016d7 <sys_page_map>
  802147:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  802149:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80214c:	85 f6                	test   %esi,%esi
  80214e:	79 22                	jns    802172 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802150:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802154:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80215b:	e8 ca f5 ff ff       	call   80172a <sys_page_unmap>
	sys_page_unmap(0, nva);
  802160:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802164:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80216b:	e8 ba f5 ff ff       	call   80172a <sys_page_unmap>
	return r;
  802170:	89 f0                	mov    %esi,%eax
}
  802172:	83 c4 3c             	add    $0x3c,%esp
  802175:	5b                   	pop    %ebx
  802176:	5e                   	pop    %esi
  802177:	5f                   	pop    %edi
  802178:	5d                   	pop    %ebp
  802179:	c3                   	ret    

0080217a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	53                   	push   %ebx
  80217e:	83 ec 24             	sub    $0x24,%esp
  802181:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802184:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802187:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218b:	89 1c 24             	mov    %ebx,(%esp)
  80218e:	e8 53 fd ff ff       	call   801ee6 <fd_lookup>
  802193:	89 c2                	mov    %eax,%edx
  802195:	85 d2                	test   %edx,%edx
  802197:	78 6d                	js     802206 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802199:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80219c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a3:	8b 00                	mov    (%eax),%eax
  8021a5:	89 04 24             	mov    %eax,(%esp)
  8021a8:	e8 8f fd ff ff       	call   801f3c <dev_lookup>
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	78 55                	js     802206 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b4:	8b 50 08             	mov    0x8(%eax),%edx
  8021b7:	83 e2 03             	and    $0x3,%edx
  8021ba:	83 fa 01             	cmp    $0x1,%edx
  8021bd:	75 23                	jne    8021e2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021bf:	a1 28 64 80 00       	mov    0x806428,%eax
  8021c4:	8b 40 48             	mov    0x48(%eax),%eax
  8021c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cf:	c7 04 24 ed 42 80 00 	movl   $0x8042ed,(%esp)
  8021d6:	e8 6f e9 ff ff       	call   800b4a <cprintf>
		return -E_INVAL;
  8021db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021e0:	eb 24                	jmp    802206 <read+0x8c>
	}
	if (!dev->dev_read)
  8021e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e5:	8b 52 08             	mov    0x8(%edx),%edx
  8021e8:	85 d2                	test   %edx,%edx
  8021ea:	74 15                	je     802201 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8021ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021fa:	89 04 24             	mov    %eax,(%esp)
  8021fd:	ff d2                	call   *%edx
  8021ff:	eb 05                	jmp    802206 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  802201:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  802206:	83 c4 24             	add    $0x24,%esp
  802209:	5b                   	pop    %ebx
  80220a:	5d                   	pop    %ebp
  80220b:	c3                   	ret    

0080220c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	57                   	push   %edi
  802210:	56                   	push   %esi
  802211:	53                   	push   %ebx
  802212:	83 ec 1c             	sub    $0x1c,%esp
  802215:	8b 7d 08             	mov    0x8(%ebp),%edi
  802218:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80221b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802220:	eb 23                	jmp    802245 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802222:	89 f0                	mov    %esi,%eax
  802224:	29 d8                	sub    %ebx,%eax
  802226:	89 44 24 08          	mov    %eax,0x8(%esp)
  80222a:	89 d8                	mov    %ebx,%eax
  80222c:	03 45 0c             	add    0xc(%ebp),%eax
  80222f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802233:	89 3c 24             	mov    %edi,(%esp)
  802236:	e8 3f ff ff ff       	call   80217a <read>
		if (m < 0)
  80223b:	85 c0                	test   %eax,%eax
  80223d:	78 10                	js     80224f <readn+0x43>
			return m;
		if (m == 0)
  80223f:	85 c0                	test   %eax,%eax
  802241:	74 0a                	je     80224d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802243:	01 c3                	add    %eax,%ebx
  802245:	39 f3                	cmp    %esi,%ebx
  802247:	72 d9                	jb     802222 <readn+0x16>
  802249:	89 d8                	mov    %ebx,%eax
  80224b:	eb 02                	jmp    80224f <readn+0x43>
  80224d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80224f:	83 c4 1c             	add    $0x1c,%esp
  802252:	5b                   	pop    %ebx
  802253:	5e                   	pop    %esi
  802254:	5f                   	pop    %edi
  802255:	5d                   	pop    %ebp
  802256:	c3                   	ret    

00802257 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	53                   	push   %ebx
  80225b:	83 ec 24             	sub    $0x24,%esp
  80225e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802261:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802264:	89 44 24 04          	mov    %eax,0x4(%esp)
  802268:	89 1c 24             	mov    %ebx,(%esp)
  80226b:	e8 76 fc ff ff       	call   801ee6 <fd_lookup>
  802270:	89 c2                	mov    %eax,%edx
  802272:	85 d2                	test   %edx,%edx
  802274:	78 68                	js     8022de <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802276:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802279:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802280:	8b 00                	mov    (%eax),%eax
  802282:	89 04 24             	mov    %eax,(%esp)
  802285:	e8 b2 fc ff ff       	call   801f3c <dev_lookup>
  80228a:	85 c0                	test   %eax,%eax
  80228c:	78 50                	js     8022de <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80228e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802291:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802295:	75 23                	jne    8022ba <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802297:	a1 28 64 80 00       	mov    0x806428,%eax
  80229c:	8b 40 48             	mov    0x48(%eax),%eax
  80229f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a7:	c7 04 24 09 43 80 00 	movl   $0x804309,(%esp)
  8022ae:	e8 97 e8 ff ff       	call   800b4a <cprintf>
		return -E_INVAL;
  8022b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022b8:	eb 24                	jmp    8022de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8022ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bd:	8b 52 0c             	mov    0xc(%edx),%edx
  8022c0:	85 d2                	test   %edx,%edx
  8022c2:	74 15                	je     8022d9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8022c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022d2:	89 04 24             	mov    %eax,(%esp)
  8022d5:	ff d2                	call   *%edx
  8022d7:	eb 05                	jmp    8022de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8022d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8022de:	83 c4 24             	add    $0x24,%esp
  8022e1:	5b                   	pop    %ebx
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    

008022e4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022ea:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8022ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	89 04 24             	mov    %eax,(%esp)
  8022f7:	e8 ea fb ff ff       	call   801ee6 <fd_lookup>
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	78 0e                	js     80230e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  802300:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802303:	8b 55 0c             	mov    0xc(%ebp),%edx
  802306:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802309:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	53                   	push   %ebx
  802314:	83 ec 24             	sub    $0x24,%esp
  802317:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80231a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80231d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802321:	89 1c 24             	mov    %ebx,(%esp)
  802324:	e8 bd fb ff ff       	call   801ee6 <fd_lookup>
  802329:	89 c2                	mov    %eax,%edx
  80232b:	85 d2                	test   %edx,%edx
  80232d:	78 61                	js     802390 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80232f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802332:	89 44 24 04          	mov    %eax,0x4(%esp)
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	8b 00                	mov    (%eax),%eax
  80233b:	89 04 24             	mov    %eax,(%esp)
  80233e:	e8 f9 fb ff ff       	call   801f3c <dev_lookup>
  802343:	85 c0                	test   %eax,%eax
  802345:	78 49                	js     802390 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80234e:	75 23                	jne    802373 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802350:	a1 28 64 80 00       	mov    0x806428,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802355:	8b 40 48             	mov    0x48(%eax),%eax
  802358:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80235c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802360:	c7 04 24 cc 42 80 00 	movl   $0x8042cc,(%esp)
  802367:	e8 de e7 ff ff       	call   800b4a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80236c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802371:	eb 1d                	jmp    802390 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  802373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802376:	8b 52 18             	mov    0x18(%edx),%edx
  802379:	85 d2                	test   %edx,%edx
  80237b:	74 0e                	je     80238b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80237d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802380:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802384:	89 04 24             	mov    %eax,(%esp)
  802387:	ff d2                	call   *%edx
  802389:	eb 05                	jmp    802390 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80238b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  802390:	83 c4 24             	add    $0x24,%esp
  802393:	5b                   	pop    %ebx
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    

00802396 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	53                   	push   %ebx
  80239a:	83 ec 24             	sub    $0x24,%esp
  80239d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023aa:	89 04 24             	mov    %eax,(%esp)
  8023ad:	e8 34 fb ff ff       	call   801ee6 <fd_lookup>
  8023b2:	89 c2                	mov    %eax,%edx
  8023b4:	85 d2                	test   %edx,%edx
  8023b6:	78 52                	js     80240a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	89 04 24             	mov    %eax,(%esp)
  8023c7:	e8 70 fb ff ff       	call   801f3c <dev_lookup>
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	78 3a                	js     80240a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8023d7:	74 2c                	je     802405 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8023d9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8023dc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8023e3:	00 00 00 
	stat->st_isdir = 0;
  8023e6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023ed:	00 00 00 
	stat->st_dev = dev;
  8023f0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8023f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023fd:	89 14 24             	mov    %edx,(%esp)
  802400:	ff 50 14             	call   *0x14(%eax)
  802403:	eb 05                	jmp    80240a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  802405:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80240a:	83 c4 24             	add    $0x24,%esp
  80240d:	5b                   	pop    %ebx
  80240e:	5d                   	pop    %ebp
  80240f:	c3                   	ret    

00802410 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	56                   	push   %esi
  802414:	53                   	push   %ebx
  802415:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802418:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80241f:	00 
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	89 04 24             	mov    %eax,(%esp)
  802426:	e8 28 02 00 00       	call   802653 <open>
  80242b:	89 c3                	mov    %eax,%ebx
  80242d:	85 db                	test   %ebx,%ebx
  80242f:	78 1b                	js     80244c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  802431:	8b 45 0c             	mov    0xc(%ebp),%eax
  802434:	89 44 24 04          	mov    %eax,0x4(%esp)
  802438:	89 1c 24             	mov    %ebx,(%esp)
  80243b:	e8 56 ff ff ff       	call   802396 <fstat>
  802440:	89 c6                	mov    %eax,%esi
	close(fd);
  802442:	89 1c 24             	mov    %ebx,(%esp)
  802445:	e8 cd fb ff ff       	call   802017 <close>
	return r;
  80244a:	89 f0                	mov    %esi,%eax
}
  80244c:	83 c4 10             	add    $0x10,%esp
  80244f:	5b                   	pop    %ebx
  802450:	5e                   	pop    %esi
  802451:	5d                   	pop    %ebp
  802452:	c3                   	ret    

00802453 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
  802456:	56                   	push   %esi
  802457:	53                   	push   %ebx
  802458:	83 ec 10             	sub    $0x10,%esp
  80245b:	89 c6                	mov    %eax,%esi
  80245d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80245f:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  802466:	75 11                	jne    802479 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802468:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80246f:	e8 26 14 00 00       	call   80389a <ipc_find_env>
  802474:	a3 20 64 80 00       	mov    %eax,0x806420
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802479:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802480:	00 
  802481:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802488:	00 
  802489:	89 74 24 04          	mov    %esi,0x4(%esp)
  80248d:	a1 20 64 80 00       	mov    0x806420,%eax
  802492:	89 04 24             	mov    %eax,(%esp)
  802495:	e8 a2 13 00 00       	call   80383c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80249a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024a1:	00 
  8024a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024ad:	e8 20 13 00 00       	call   8037d2 <ipc_recv>
}
  8024b2:	83 c4 10             	add    $0x10,%esp
  8024b5:	5b                   	pop    %ebx
  8024b6:	5e                   	pop    %esi
  8024b7:	5d                   	pop    %ebp
  8024b8:	c3                   	ret    

008024b9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c5:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8024ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024cd:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8024d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8024dc:	e8 72 ff ff ff       	call   802453 <fsipc>
}
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
  8024e6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ef:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8024f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f9:	b8 06 00 00 00       	mov    $0x6,%eax
  8024fe:	e8 50 ff ff ff       	call   802453 <fsipc>
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	53                   	push   %ebx
  802509:	83 ec 14             	sub    $0x14,%esp
  80250c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	8b 40 0c             	mov    0xc(%eax),%eax
  802515:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80251a:	ba 00 00 00 00       	mov    $0x0,%edx
  80251f:	b8 05 00 00 00       	mov    $0x5,%eax
  802524:	e8 2a ff ff ff       	call   802453 <fsipc>
  802529:	89 c2                	mov    %eax,%edx
  80252b:	85 d2                	test   %edx,%edx
  80252d:	78 2b                	js     80255a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80252f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802536:	00 
  802537:	89 1c 24             	mov    %ebx,(%esp)
  80253a:	e8 28 ed ff ff       	call   801267 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80253f:	a1 80 70 80 00       	mov    0x807080,%eax
  802544:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80254a:	a1 84 70 80 00       	mov    0x807084,%eax
  80254f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802555:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255a:	83 c4 14             	add    $0x14,%esp
  80255d:	5b                   	pop    %ebx
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    

00802560 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 18             	sub    $0x18,%esp
  802566:	8b 45 10             	mov    0x10(%ebp),%eax
  802569:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80256e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  802573:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  802576:	a3 04 70 80 00       	mov    %eax,0x807004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80257b:	8b 55 08             	mov    0x8(%ebp),%edx
  80257e:	8b 52 0c             	mov    0xc(%edx),%edx
  802581:	89 15 00 70 80 00    	mov    %edx,0x807000
    memmove(fsipcbuf.write.req_buf,buf,n);
  802587:	89 44 24 08          	mov    %eax,0x8(%esp)
  80258b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80258e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802592:	c7 04 24 08 70 80 00 	movl   $0x807008,(%esp)
  802599:	e8 66 ee ff ff       	call   801404 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  80259e:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a3:	b8 04 00 00 00       	mov    $0x4,%eax
  8025a8:	e8 a6 fe ff ff       	call   802453 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	56                   	push   %esi
  8025b3:	53                   	push   %ebx
  8025b4:	83 ec 10             	sub    $0x10,%esp
  8025b7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c0:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8025c5:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8025cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d0:	b8 03 00 00 00       	mov    $0x3,%eax
  8025d5:	e8 79 fe ff ff       	call   802453 <fsipc>
  8025da:	89 c3                	mov    %eax,%ebx
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	78 6a                	js     80264a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8025e0:	39 c6                	cmp    %eax,%esi
  8025e2:	73 24                	jae    802608 <devfile_read+0x59>
  8025e4:	c7 44 24 0c 3c 43 80 	movl   $0x80433c,0xc(%esp)
  8025eb:	00 
  8025ec:	c7 44 24 08 dd 3c 80 	movl   $0x803cdd,0x8(%esp)
  8025f3:	00 
  8025f4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8025fb:	00 
  8025fc:	c7 04 24 43 43 80 00 	movl   $0x804343,(%esp)
  802603:	e8 49 e4 ff ff       	call   800a51 <_panic>
	assert(r <= PGSIZE);
  802608:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80260d:	7e 24                	jle    802633 <devfile_read+0x84>
  80260f:	c7 44 24 0c 4e 43 80 	movl   $0x80434e,0xc(%esp)
  802616:	00 
  802617:	c7 44 24 08 dd 3c 80 	movl   $0x803cdd,0x8(%esp)
  80261e:	00 
  80261f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802626:	00 
  802627:	c7 04 24 43 43 80 00 	movl   $0x804343,(%esp)
  80262e:	e8 1e e4 ff ff       	call   800a51 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802633:	89 44 24 08          	mov    %eax,0x8(%esp)
  802637:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80263e:	00 
  80263f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802642:	89 04 24             	mov    %eax,(%esp)
  802645:	e8 ba ed ff ff       	call   801404 <memmove>
	return r;
}
  80264a:	89 d8                	mov    %ebx,%eax
  80264c:	83 c4 10             	add    $0x10,%esp
  80264f:	5b                   	pop    %ebx
  802650:	5e                   	pop    %esi
  802651:	5d                   	pop    %ebp
  802652:	c3                   	ret    

00802653 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
  802656:	53                   	push   %ebx
  802657:	83 ec 24             	sub    $0x24,%esp
  80265a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80265d:	89 1c 24             	mov    %ebx,(%esp)
  802660:	e8 cb eb ff ff       	call   801230 <strlen>
  802665:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80266a:	7f 60                	jg     8026cc <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80266c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80266f:	89 04 24             	mov    %eax,(%esp)
  802672:	e8 20 f8 ff ff       	call   801e97 <fd_alloc>
  802677:	89 c2                	mov    %eax,%edx
  802679:	85 d2                	test   %edx,%edx
  80267b:	78 54                	js     8026d1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80267d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802681:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  802688:	e8 da eb ff ff       	call   801267 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80268d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802690:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802695:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802698:	b8 01 00 00 00       	mov    $0x1,%eax
  80269d:	e8 b1 fd ff ff       	call   802453 <fsipc>
  8026a2:	89 c3                	mov    %eax,%ebx
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	79 17                	jns    8026bf <open+0x6c>
		fd_close(fd, 0);
  8026a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8026af:	00 
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	89 04 24             	mov    %eax,(%esp)
  8026b6:	e8 db f8 ff ff       	call   801f96 <fd_close>
		return r;
  8026bb:	89 d8                	mov    %ebx,%eax
  8026bd:	eb 12                	jmp    8026d1 <open+0x7e>
	}

	return fd2num(fd);
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	89 04 24             	mov    %eax,(%esp)
  8026c5:	e8 a6 f7 ff ff       	call   801e70 <fd2num>
  8026ca:	eb 05                	jmp    8026d1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8026cc:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8026d1:	83 c4 24             	add    $0x24,%esp
  8026d4:	5b                   	pop    %ebx
  8026d5:	5d                   	pop    %ebp
  8026d6:	c3                   	ret    

008026d7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
  8026da:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8026dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e2:	b8 08 00 00 00       	mov    $0x8,%eax
  8026e7:	e8 67 fd ff ff       	call   802453 <fsipc>
}
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    

008026ee <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
  8026f1:	53                   	push   %ebx
  8026f2:	83 ec 14             	sub    $0x14,%esp
  8026f5:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8026f7:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8026fb:	7e 31                	jle    80272e <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8026fd:	8b 40 04             	mov    0x4(%eax),%eax
  802700:	89 44 24 08          	mov    %eax,0x8(%esp)
  802704:	8d 43 10             	lea    0x10(%ebx),%eax
  802707:	89 44 24 04          	mov    %eax,0x4(%esp)
  80270b:	8b 03                	mov    (%ebx),%eax
  80270d:	89 04 24             	mov    %eax,(%esp)
  802710:	e8 42 fb ff ff       	call   802257 <write>
		if (result > 0)
  802715:	85 c0                	test   %eax,%eax
  802717:	7e 03                	jle    80271c <writebuf+0x2e>
			b->result += result;
  802719:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80271c:	39 43 04             	cmp    %eax,0x4(%ebx)
  80271f:	74 0d                	je     80272e <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  802721:	85 c0                	test   %eax,%eax
  802723:	ba 00 00 00 00       	mov    $0x0,%edx
  802728:	0f 4f c2             	cmovg  %edx,%eax
  80272b:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80272e:	83 c4 14             	add    $0x14,%esp
  802731:	5b                   	pop    %ebx
  802732:	5d                   	pop    %ebp
  802733:	c3                   	ret    

00802734 <putch>:

static void
putch(int ch, void *thunk)
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
  802737:	53                   	push   %ebx
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80273e:	8b 53 04             	mov    0x4(%ebx),%edx
  802741:	8d 42 01             	lea    0x1(%edx),%eax
  802744:	89 43 04             	mov    %eax,0x4(%ebx)
  802747:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80274a:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80274e:	3d 00 01 00 00       	cmp    $0x100,%eax
  802753:	75 0e                	jne    802763 <putch+0x2f>
		writebuf(b);
  802755:	89 d8                	mov    %ebx,%eax
  802757:	e8 92 ff ff ff       	call   8026ee <writebuf>
		b->idx = 0;
  80275c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  802763:	83 c4 04             	add    $0x4,%esp
  802766:	5b                   	pop    %ebx
  802767:	5d                   	pop    %ebp
  802768:	c3                   	ret    

00802769 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802769:	55                   	push   %ebp
  80276a:	89 e5                	mov    %esp,%ebp
  80276c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  802772:	8b 45 08             	mov    0x8(%ebp),%eax
  802775:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80277b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802782:	00 00 00 
	b.result = 0;
  802785:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80278c:	00 00 00 
	b.error = 1;
  80278f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802796:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802799:	8b 45 10             	mov    0x10(%ebp),%eax
  80279c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027a7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8027ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b1:	c7 04 24 34 27 80 00 	movl   $0x802734,(%esp)
  8027b8:	e8 21 e5 ff ff       	call   800cde <vprintfmt>
	if (b.idx > 0)
  8027bd:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8027c4:	7e 0b                	jle    8027d1 <vfprintf+0x68>
		writebuf(&b);
  8027c6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8027cc:	e8 1d ff ff ff       	call   8026ee <writebuf>

	return (b.result ? b.result : b.error);
  8027d1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8027e0:	c9                   	leave  
  8027e1:	c3                   	ret    

008027e2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8027e8:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8027eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	89 04 24             	mov    %eax,(%esp)
  8027fc:	e8 68 ff ff ff       	call   802769 <vfprintf>
	va_end(ap);

	return cnt;
}
  802801:	c9                   	leave  
  802802:	c3                   	ret    

00802803 <printf>:

int
printf(const char *fmt, ...)
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
  802806:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802809:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80280c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	89 44 24 04          	mov    %eax,0x4(%esp)
  802817:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80281e:	e8 46 ff ff ff       	call   802769 <vfprintf>
	va_end(ap);

	return cnt;
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    
  802825:	66 90                	xchg   %ax,%ax
  802827:	66 90                	xchg   %ax,%ax
  802829:	66 90                	xchg   %ax,%ax
  80282b:	66 90                	xchg   %ax,%ax
  80282d:	66 90                	xchg   %ax,%ax
  80282f:	90                   	nop

00802830 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
  802833:	57                   	push   %edi
  802834:	56                   	push   %esi
  802835:	53                   	push   %ebx
  802836:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80283c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802843:	00 
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	89 04 24             	mov    %eax,(%esp)
  80284a:	e8 04 fe ff ff       	call   802653 <open>
  80284f:	89 c2                	mov    %eax,%edx
  802851:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  802857:	85 c0                	test   %eax,%eax
  802859:	0f 88 0f 05 00 00    	js     802d6e <spawn+0x53e>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80285f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802866:	00 
  802867:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80286d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802871:	89 14 24             	mov    %edx,(%esp)
  802874:	e8 93 f9 ff ff       	call   80220c <readn>
  802879:	3d 00 02 00 00       	cmp    $0x200,%eax
  80287e:	75 0c                	jne    80288c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  802880:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802887:	45 4c 46 
  80288a:	74 36                	je     8028c2 <spawn+0x92>
		close(fd);
  80288c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802892:	89 04 24             	mov    %eax,(%esp)
  802895:	e8 7d f7 ff ff       	call   802017 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80289a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  8028a1:	46 
  8028a2:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  8028a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ac:	c7 04 24 5a 43 80 00 	movl   $0x80435a,(%esp)
  8028b3:	e8 92 e2 ff ff       	call   800b4a <cprintf>
		return -E_NOT_EXEC;
  8028b8:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8028bd:	e9 0b 05 00 00       	jmp    802dcd <spawn+0x59d>
  8028c2:	b8 07 00 00 00       	mov    $0x7,%eax
  8028c7:	cd 30                	int    $0x30
  8028c9:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8028cf:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	0f 88 99 04 00 00    	js     802d76 <spawn+0x546>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8028dd:	89 c6                	mov    %eax,%esi
  8028df:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8028e5:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8028e8:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8028ee:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8028f4:	b9 11 00 00 00       	mov    $0x11,%ecx
  8028f9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8028fb:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802901:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802907:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80290c:	be 00 00 00 00       	mov    $0x0,%esi
  802911:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802914:	eb 0f                	jmp    802925 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  802916:	89 04 24             	mov    %eax,(%esp)
  802919:	e8 12 e9 ff ff       	call   801230 <strlen>
  80291e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802922:	83 c3 01             	add    $0x1,%ebx
  802925:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80292c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80292f:	85 c0                	test   %eax,%eax
  802931:	75 e3                	jne    802916 <spawn+0xe6>
  802933:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802939:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80293f:	bf 00 10 40 00       	mov    $0x401000,%edi
  802944:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802946:	89 fa                	mov    %edi,%edx
  802948:	83 e2 fc             	and    $0xfffffffc,%edx
  80294b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802952:	29 c2                	sub    %eax,%edx
  802954:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80295a:	8d 42 f8             	lea    -0x8(%edx),%eax
  80295d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802962:	0f 86 1e 04 00 00    	jbe    802d86 <spawn+0x556>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802968:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80296f:	00 
  802970:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802977:	00 
  802978:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80297f:	e8 ff ec ff ff       	call   801683 <sys_page_alloc>
  802984:	85 c0                	test   %eax,%eax
  802986:	0f 88 41 04 00 00    	js     802dcd <spawn+0x59d>
  80298c:	be 00 00 00 00       	mov    $0x0,%esi
  802991:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802997:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80299a:	eb 30                	jmp    8029cc <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  80299c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8029a2:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8029a8:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8029ab:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8029ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b2:	89 3c 24             	mov    %edi,(%esp)
  8029b5:	e8 ad e8 ff ff       	call   801267 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8029ba:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8029bd:	89 04 24             	mov    %eax,(%esp)
  8029c0:	e8 6b e8 ff ff       	call   801230 <strlen>
  8029c5:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8029c9:	83 c6 01             	add    $0x1,%esi
  8029cc:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  8029d2:	7f c8                	jg     80299c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8029d4:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8029da:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8029e0:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8029e7:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8029ed:	74 24                	je     802a13 <spawn+0x1e3>
  8029ef:	c7 44 24 0c d0 43 80 	movl   $0x8043d0,0xc(%esp)
  8029f6:	00 
  8029f7:	c7 44 24 08 dd 3c 80 	movl   $0x803cdd,0x8(%esp)
  8029fe:	00 
  8029ff:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  802a06:	00 
  802a07:	c7 04 24 74 43 80 00 	movl   $0x804374,(%esp)
  802a0e:	e8 3e e0 ff ff       	call   800a51 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802a13:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802a19:	89 c8                	mov    %ecx,%eax
  802a1b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802a20:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802a23:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802a29:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802a2c:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  802a32:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802a38:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802a3f:	00 
  802a40:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802a47:	ee 
  802a48:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802a4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a52:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802a59:	00 
  802a5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a61:	e8 71 ec ff ff       	call   8016d7 <sys_page_map>
  802a66:	89 c3                	mov    %eax,%ebx
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	0f 88 47 03 00 00    	js     802db7 <spawn+0x587>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802a70:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802a77:	00 
  802a78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a7f:	e8 a6 ec ff ff       	call   80172a <sys_page_unmap>
  802a84:	89 c3                	mov    %eax,%ebx
  802a86:	85 c0                	test   %eax,%eax
  802a88:	0f 88 29 03 00 00    	js     802db7 <spawn+0x587>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802a8e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802a94:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802a9b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802aa1:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802aa8:	00 00 00 
  802aab:	e9 b6 01 00 00       	jmp    802c66 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  802ab0:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802ab6:	83 38 01             	cmpl   $0x1,(%eax)
  802ab9:	0f 85 99 01 00 00    	jne    802c58 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802abf:	89 c2                	mov    %eax,%edx
  802ac1:	8b 40 18             	mov    0x18(%eax),%eax
  802ac4:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802ac7:	83 f8 01             	cmp    $0x1,%eax
  802aca:	19 c0                	sbb    %eax,%eax
  802acc:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802ad2:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  802ad9:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802ae0:	89 d0                	mov    %edx,%eax
  802ae2:	8b 7a 04             	mov    0x4(%edx),%edi
  802ae5:	89 bd 80 fd ff ff    	mov    %edi,-0x280(%ebp)
  802aeb:	8b 52 10             	mov    0x10(%edx),%edx
  802aee:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  802af4:	8b 78 14             	mov    0x14(%eax),%edi
  802af7:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  802afd:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802b00:	89 f0                	mov    %esi,%eax
  802b02:	25 ff 0f 00 00       	and    $0xfff,%eax
  802b07:	74 14                	je     802b1d <spawn+0x2ed>
		va -= i;
  802b09:	29 c6                	sub    %eax,%esi
		memsz += i;
  802b0b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802b11:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  802b17:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802b1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b22:	e9 23 01 00 00       	jmp    802c4a <spawn+0x41a>
		if (i >= filesz) {
  802b27:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  802b2d:	77 2b                	ja     802b5a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802b2f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802b35:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b39:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b3d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802b43:	89 04 24             	mov    %eax,(%esp)
  802b46:	e8 38 eb ff ff       	call   801683 <sys_page_alloc>
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	0f 89 eb 00 00 00    	jns    802c3e <spawn+0x40e>
  802b53:	89 c3                	mov    %eax,%ebx
  802b55:	e9 3d 02 00 00       	jmp    802d97 <spawn+0x567>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802b5a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802b61:	00 
  802b62:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802b69:	00 
  802b6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b71:	e8 0d eb ff ff       	call   801683 <sys_page_alloc>
  802b76:	85 c0                	test   %eax,%eax
  802b78:	0f 88 0f 02 00 00    	js     802d8d <spawn+0x55d>
  802b7e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802b84:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802b86:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b8a:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802b90:	89 04 24             	mov    %eax,(%esp)
  802b93:	e8 4c f7 ff ff       	call   8022e4 <seek>
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	0f 88 f1 01 00 00    	js     802d91 <spawn+0x561>
  802ba0:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802ba6:	29 f9                	sub    %edi,%ecx
  802ba8:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802baa:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  802bb0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802bb5:	0f 47 c1             	cmova  %ecx,%eax
  802bb8:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bbc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802bc3:	00 
  802bc4:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802bca:	89 04 24             	mov    %eax,(%esp)
  802bcd:	e8 3a f6 ff ff       	call   80220c <readn>
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	0f 88 bb 01 00 00    	js     802d95 <spawn+0x565>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802bda:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802be0:	89 44 24 10          	mov    %eax,0x10(%esp)
  802be4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802be8:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802bee:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bf2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802bf9:	00 
  802bfa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c01:	e8 d1 ea ff ff       	call   8016d7 <sys_page_map>
  802c06:	85 c0                	test   %eax,%eax
  802c08:	79 20                	jns    802c2a <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  802c0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c0e:	c7 44 24 08 80 43 80 	movl   $0x804380,0x8(%esp)
  802c15:	00 
  802c16:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  802c1d:	00 
  802c1e:	c7 04 24 74 43 80 00 	movl   $0x804374,(%esp)
  802c25:	e8 27 de ff ff       	call   800a51 <_panic>
			sys_page_unmap(0, UTEMP);
  802c2a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c31:	00 
  802c32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c39:	e8 ec ea ff ff       	call   80172a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802c3e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802c44:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802c4a:	89 df                	mov    %ebx,%edi
  802c4c:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  802c52:	0f 87 cf fe ff ff    	ja     802b27 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c58:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  802c5f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802c66:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802c6d:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  802c73:	0f 8c 37 fe ff ff    	jl     802ab0 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802c79:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802c7f:	89 04 24             	mov    %eax,(%esp)
  802c82:	e8 90 f3 ff ff       	call   802017 <close>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  802c87:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c8c:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	{
		if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U))&&((uvpt[i/PGSIZE]&(PTE_SHARE))==PTE_SHARE))
  802c92:	89 d8                	mov    %ebx,%eax
  802c94:	c1 e8 16             	shr    $0x16,%eax
  802c97:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802c9e:	a8 01                	test   $0x1,%al
  802ca0:	74 48                	je     802cea <spawn+0x4ba>
  802ca2:	89 d8                	mov    %ebx,%eax
  802ca4:	c1 e8 0c             	shr    $0xc,%eax
  802ca7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802cae:	83 e2 05             	and    $0x5,%edx
  802cb1:	83 fa 05             	cmp    $0x5,%edx
  802cb4:	75 34                	jne    802cea <spawn+0x4ba>
  802cb6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802cbd:	f6 c6 04             	test   $0x4,%dh
  802cc0:	74 28                	je     802cea <spawn+0x4ba>
		{
			//cprintf("in copy_shared_pages\n");
			//cprintf("%08x\n",PDX(i));
			sys_page_map(0,(void*)i,child,(void*)i,uvpt[i/PGSIZE]&PTE_SYSCALL);
  802cc2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802cc9:	25 07 0e 00 00       	and    $0xe07,%eax
  802cce:	89 44 24 10          	mov    %eax,0x10(%esp)
  802cd2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802cd6:	89 74 24 08          	mov    %esi,0x8(%esp)
  802cda:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802cde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ce5:	e8 ed e9 ff ff       	call   8016d7 <sys_page_map>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  802cea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802cf0:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  802cf6:	75 9a                	jne    802c92 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802cf8:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d02:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802d08:	89 04 24             	mov    %eax,(%esp)
  802d0b:	e8 c0 ea ff ff       	call   8017d0 <sys_env_set_trapframe>
  802d10:	85 c0                	test   %eax,%eax
  802d12:	79 20                	jns    802d34 <spawn+0x504>
		panic("sys_env_set_trapframe: %e", r);
  802d14:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d18:	c7 44 24 08 9d 43 80 	movl   $0x80439d,0x8(%esp)
  802d1f:	00 
  802d20:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  802d27:	00 
  802d28:	c7 04 24 74 43 80 00 	movl   $0x804374,(%esp)
  802d2f:	e8 1d dd ff ff       	call   800a51 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802d34:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802d3b:	00 
  802d3c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802d42:	89 04 24             	mov    %eax,(%esp)
  802d45:	e8 33 ea ff ff       	call   80177d <sys_env_set_status>
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	79 30                	jns    802d7e <spawn+0x54e>
		panic("sys_env_set_status: %e", r);
  802d4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d52:	c7 44 24 08 b7 43 80 	movl   $0x8043b7,0x8(%esp)
  802d59:	00 
  802d5a:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  802d61:	00 
  802d62:	c7 04 24 74 43 80 00 	movl   $0x804374,(%esp)
  802d69:	e8 e3 dc ff ff       	call   800a51 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  802d6e:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802d74:	eb 57                	jmp    802dcd <spawn+0x59d>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  802d76:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802d7c:	eb 4f                	jmp    802dcd <spawn+0x59d>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  802d7e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802d84:	eb 47                	jmp    802dcd <spawn+0x59d>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802d86:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802d8b:	eb 40                	jmp    802dcd <spawn+0x59d>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802d8d:	89 c3                	mov    %eax,%ebx
  802d8f:	eb 06                	jmp    802d97 <spawn+0x567>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802d91:	89 c3                	mov    %eax,%ebx
  802d93:	eb 02                	jmp    802d97 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802d95:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802d97:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802d9d:	89 04 24             	mov    %eax,(%esp)
  802da0:	e8 4e e8 ff ff       	call   8015f3 <sys_env_destroy>
	close(fd);
  802da5:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802dab:	89 04 24             	mov    %eax,(%esp)
  802dae:	e8 64 f2 ff ff       	call   802017 <close>
	return r;
  802db3:	89 d8                	mov    %ebx,%eax
  802db5:	eb 16                	jmp    802dcd <spawn+0x59d>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802db7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802dbe:	00 
  802dbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dc6:	e8 5f e9 ff ff       	call   80172a <sys_page_unmap>
  802dcb:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802dcd:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802dd3:	5b                   	pop    %ebx
  802dd4:	5e                   	pop    %esi
  802dd5:	5f                   	pop    %edi
  802dd6:	5d                   	pop    %ebp
  802dd7:	c3                   	ret    

00802dd8 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802dd8:	55                   	push   %ebp
  802dd9:	89 e5                	mov    %esp,%ebp
  802ddb:	56                   	push   %esi
  802ddc:	53                   	push   %ebx
  802ddd:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802de0:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802de3:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802de8:	eb 03                	jmp    802ded <spawnl+0x15>
		argc++;
  802dea:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802ded:	83 c0 04             	add    $0x4,%eax
  802df0:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  802df4:	75 f4                	jne    802dea <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802df6:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  802dfd:	83 e0 f0             	and    $0xfffffff0,%eax
  802e00:	29 c4                	sub    %eax,%esp
  802e02:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802e06:	c1 e8 02             	shr    $0x2,%eax
  802e09:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  802e10:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802e12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e15:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  802e1c:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  802e23:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802e24:	b8 00 00 00 00       	mov    $0x0,%eax
  802e29:	eb 0a                	jmp    802e35 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  802e2b:	83 c0 01             	add    $0x1,%eax
  802e2e:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  802e32:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802e35:	39 d0                	cmp    %edx,%eax
  802e37:	75 f2                	jne    802e2b <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802e39:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	89 04 24             	mov    %eax,(%esp)
  802e43:	e8 e8 f9 ff ff       	call   802830 <spawn>
}
  802e48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e4b:	5b                   	pop    %ebx
  802e4c:	5e                   	pop    %esi
  802e4d:	5d                   	pop    %ebp
  802e4e:	c3                   	ret    
  802e4f:	90                   	nop

00802e50 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802e50:	55                   	push   %ebp
  802e51:	89 e5                	mov    %esp,%ebp
  802e53:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802e56:	c7 44 24 04 f6 43 80 	movl   $0x8043f6,0x4(%esp)
  802e5d:	00 
  802e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e61:	89 04 24             	mov    %eax,(%esp)
  802e64:	e8 fe e3 ff ff       	call   801267 <strcpy>
	return 0;
}
  802e69:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6e:	c9                   	leave  
  802e6f:	c3                   	ret    

00802e70 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802e70:	55                   	push   %ebp
  802e71:	89 e5                	mov    %esp,%ebp
  802e73:	53                   	push   %ebx
  802e74:	83 ec 14             	sub    $0x14,%esp
  802e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802e7a:	89 1c 24             	mov    %ebx,(%esp)
  802e7d:	e8 50 0a 00 00       	call   8038d2 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802e82:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802e87:	83 f8 01             	cmp    $0x1,%eax
  802e8a:	75 0d                	jne    802e99 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  802e8c:	8b 43 0c             	mov    0xc(%ebx),%eax
  802e8f:	89 04 24             	mov    %eax,(%esp)
  802e92:	e8 29 03 00 00       	call   8031c0 <nsipc_close>
  802e97:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802e99:	89 d0                	mov    %edx,%eax
  802e9b:	83 c4 14             	add    $0x14,%esp
  802e9e:	5b                   	pop    %ebx
  802e9f:	5d                   	pop    %ebp
  802ea0:	c3                   	ret    

00802ea1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802ea1:	55                   	push   %ebp
  802ea2:	89 e5                	mov    %esp,%ebp
  802ea4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802ea7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802eae:	00 
  802eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  802eb2:	89 44 24 08          	mov    %eax,0x8(%esp)
  802eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec3:	89 04 24             	mov    %eax,(%esp)
  802ec6:	e8 f0 03 00 00       	call   8032bb <nsipc_send>
}
  802ecb:	c9                   	leave  
  802ecc:	c3                   	ret    

00802ecd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802ecd:	55                   	push   %ebp
  802ece:	89 e5                	mov    %esp,%ebp
  802ed0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802ed3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802eda:	00 
  802edb:	8b 45 10             	mov    0x10(%ebp),%eax
  802ede:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	8b 40 0c             	mov    0xc(%eax),%eax
  802eef:	89 04 24             	mov    %eax,(%esp)
  802ef2:	e8 44 03 00 00       	call   80323b <nsipc_recv>
}
  802ef7:	c9                   	leave  
  802ef8:	c3                   	ret    

00802ef9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802ef9:	55                   	push   %ebp
  802efa:	89 e5                	mov    %esp,%ebp
  802efc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802eff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802f02:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f06:	89 04 24             	mov    %eax,(%esp)
  802f09:	e8 d8 ef ff ff       	call   801ee6 <fd_lookup>
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	78 17                	js     802f29 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  802f1b:	39 08                	cmp    %ecx,(%eax)
  802f1d:	75 05                	jne    802f24 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f22:	eb 05                	jmp    802f29 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802f24:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802f29:	c9                   	leave  
  802f2a:	c3                   	ret    

00802f2b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802f2b:	55                   	push   %ebp
  802f2c:	89 e5                	mov    %esp,%ebp
  802f2e:	56                   	push   %esi
  802f2f:	53                   	push   %ebx
  802f30:	83 ec 20             	sub    $0x20,%esp
  802f33:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802f35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f38:	89 04 24             	mov    %eax,(%esp)
  802f3b:	e8 57 ef ff ff       	call   801e97 <fd_alloc>
  802f40:	89 c3                	mov    %eax,%ebx
  802f42:	85 c0                	test   %eax,%eax
  802f44:	78 21                	js     802f67 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802f46:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802f4d:	00 
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f5c:	e8 22 e7 ff ff       	call   801683 <sys_page_alloc>
  802f61:	89 c3                	mov    %eax,%ebx
  802f63:	85 c0                	test   %eax,%eax
  802f65:	79 0c                	jns    802f73 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802f67:	89 34 24             	mov    %esi,(%esp)
  802f6a:	e8 51 02 00 00       	call   8031c0 <nsipc_close>
		return r;
  802f6f:	89 d8                	mov    %ebx,%eax
  802f71:	eb 20                	jmp    802f93 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f73:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802f7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f81:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802f88:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  802f8b:	89 14 24             	mov    %edx,(%esp)
  802f8e:	e8 dd ee ff ff       	call   801e70 <fd2num>
}
  802f93:	83 c4 20             	add    $0x20,%esp
  802f96:	5b                   	pop    %ebx
  802f97:	5e                   	pop    %esi
  802f98:	5d                   	pop    %ebp
  802f99:	c3                   	ret    

00802f9a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f9a:	55                   	push   %ebp
  802f9b:	89 e5                	mov    %esp,%ebp
  802f9d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	e8 51 ff ff ff       	call   802ef9 <fd2sockid>
		return r;
  802fa8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  802faa:	85 c0                	test   %eax,%eax
  802fac:	78 23                	js     802fd1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802fae:	8b 55 10             	mov    0x10(%ebp),%edx
  802fb1:	89 54 24 08          	mov    %edx,0x8(%esp)
  802fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb8:	89 54 24 04          	mov    %edx,0x4(%esp)
  802fbc:	89 04 24             	mov    %eax,(%esp)
  802fbf:	e8 45 01 00 00       	call   803109 <nsipc_accept>
		return r;
  802fc4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	78 07                	js     802fd1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  802fca:	e8 5c ff ff ff       	call   802f2b <alloc_sockfd>
  802fcf:	89 c1                	mov    %eax,%ecx
}
  802fd1:	89 c8                	mov    %ecx,%eax
  802fd3:	c9                   	leave  
  802fd4:	c3                   	ret    

00802fd5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
  802fd8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	e8 16 ff ff ff       	call   802ef9 <fd2sockid>
  802fe3:	89 c2                	mov    %eax,%edx
  802fe5:	85 d2                	test   %edx,%edx
  802fe7:	78 16                	js     802fff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  802fec:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ff7:	89 14 24             	mov    %edx,(%esp)
  802ffa:	e8 60 01 00 00       	call   80315f <nsipc_bind>
}
  802fff:	c9                   	leave  
  803000:	c3                   	ret    

00803001 <shutdown>:

int
shutdown(int s, int how)
{
  803001:	55                   	push   %ebp
  803002:	89 e5                	mov    %esp,%ebp
  803004:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	e8 ea fe ff ff       	call   802ef9 <fd2sockid>
  80300f:	89 c2                	mov    %eax,%edx
  803011:	85 d2                	test   %edx,%edx
  803013:	78 0f                	js     803024 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  803015:	8b 45 0c             	mov    0xc(%ebp),%eax
  803018:	89 44 24 04          	mov    %eax,0x4(%esp)
  80301c:	89 14 24             	mov    %edx,(%esp)
  80301f:	e8 7a 01 00 00       	call   80319e <nsipc_shutdown>
}
  803024:	c9                   	leave  
  803025:	c3                   	ret    

00803026 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803026:	55                   	push   %ebp
  803027:	89 e5                	mov    %esp,%ebp
  803029:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	e8 c5 fe ff ff       	call   802ef9 <fd2sockid>
  803034:	89 c2                	mov    %eax,%edx
  803036:	85 d2                	test   %edx,%edx
  803038:	78 16                	js     803050 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80303a:	8b 45 10             	mov    0x10(%ebp),%eax
  80303d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803041:	8b 45 0c             	mov    0xc(%ebp),%eax
  803044:	89 44 24 04          	mov    %eax,0x4(%esp)
  803048:	89 14 24             	mov    %edx,(%esp)
  80304b:	e8 8a 01 00 00       	call   8031da <nsipc_connect>
}
  803050:	c9                   	leave  
  803051:	c3                   	ret    

00803052 <listen>:

int
listen(int s, int backlog)
{
  803052:	55                   	push   %ebp
  803053:	89 e5                	mov    %esp,%ebp
  803055:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	e8 99 fe ff ff       	call   802ef9 <fd2sockid>
  803060:	89 c2                	mov    %eax,%edx
  803062:	85 d2                	test   %edx,%edx
  803064:	78 0f                	js     803075 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  803066:	8b 45 0c             	mov    0xc(%ebp),%eax
  803069:	89 44 24 04          	mov    %eax,0x4(%esp)
  80306d:	89 14 24             	mov    %edx,(%esp)
  803070:	e8 a4 01 00 00       	call   803219 <nsipc_listen>
}
  803075:	c9                   	leave  
  803076:	c3                   	ret    

00803077 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803077:	55                   	push   %ebp
  803078:	89 e5                	mov    %esp,%ebp
  80307a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80307d:	8b 45 10             	mov    0x10(%ebp),%eax
  803080:	89 44 24 08          	mov    %eax,0x8(%esp)
  803084:	8b 45 0c             	mov    0xc(%ebp),%eax
  803087:	89 44 24 04          	mov    %eax,0x4(%esp)
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	89 04 24             	mov    %eax,(%esp)
  803091:	e8 98 02 00 00       	call   80332e <nsipc_socket>
  803096:	89 c2                	mov    %eax,%edx
  803098:	85 d2                	test   %edx,%edx
  80309a:	78 05                	js     8030a1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80309c:	e8 8a fe ff ff       	call   802f2b <alloc_sockfd>
}
  8030a1:	c9                   	leave  
  8030a2:	c3                   	ret    

008030a3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
  8030a6:	53                   	push   %ebx
  8030a7:	83 ec 14             	sub    $0x14,%esp
  8030aa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8030ac:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  8030b3:	75 11                	jne    8030c6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8030b5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8030bc:	e8 d9 07 00 00       	call   80389a <ipc_find_env>
  8030c1:	a3 24 64 80 00       	mov    %eax,0x806424
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8030c6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8030cd:	00 
  8030ce:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8030d5:	00 
  8030d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8030da:	a1 24 64 80 00       	mov    0x806424,%eax
  8030df:	89 04 24             	mov    %eax,(%esp)
  8030e2:	e8 55 07 00 00       	call   80383c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8030e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8030ee:	00 
  8030ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8030f6:	00 
  8030f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030fe:	e8 cf 06 00 00       	call   8037d2 <ipc_recv>
}
  803103:	83 c4 14             	add    $0x14,%esp
  803106:	5b                   	pop    %ebx
  803107:	5d                   	pop    %ebp
  803108:	c3                   	ret    

00803109 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803109:	55                   	push   %ebp
  80310a:	89 e5                	mov    %esp,%ebp
  80310c:	56                   	push   %esi
  80310d:	53                   	push   %ebx
  80310e:	83 ec 10             	sub    $0x10,%esp
  803111:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80311c:	8b 06                	mov    (%esi),%eax
  80311e:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803123:	b8 01 00 00 00       	mov    $0x1,%eax
  803128:	e8 76 ff ff ff       	call   8030a3 <nsipc>
  80312d:	89 c3                	mov    %eax,%ebx
  80312f:	85 c0                	test   %eax,%eax
  803131:	78 23                	js     803156 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803133:	a1 10 80 80 00       	mov    0x808010,%eax
  803138:	89 44 24 08          	mov    %eax,0x8(%esp)
  80313c:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803143:	00 
  803144:	8b 45 0c             	mov    0xc(%ebp),%eax
  803147:	89 04 24             	mov    %eax,(%esp)
  80314a:	e8 b5 e2 ff ff       	call   801404 <memmove>
		*addrlen = ret->ret_addrlen;
  80314f:	a1 10 80 80 00       	mov    0x808010,%eax
  803154:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  803156:	89 d8                	mov    %ebx,%eax
  803158:	83 c4 10             	add    $0x10,%esp
  80315b:	5b                   	pop    %ebx
  80315c:	5e                   	pop    %esi
  80315d:	5d                   	pop    %ebp
  80315e:	c3                   	ret    

0080315f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80315f:	55                   	push   %ebp
  803160:	89 e5                	mov    %esp,%ebp
  803162:	53                   	push   %ebx
  803163:	83 ec 14             	sub    $0x14,%esp
  803166:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803171:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803175:	8b 45 0c             	mov    0xc(%ebp),%eax
  803178:	89 44 24 04          	mov    %eax,0x4(%esp)
  80317c:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803183:	e8 7c e2 ff ff       	call   801404 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803188:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  80318e:	b8 02 00 00 00       	mov    $0x2,%eax
  803193:	e8 0b ff ff ff       	call   8030a3 <nsipc>
}
  803198:	83 c4 14             	add    $0x14,%esp
  80319b:	5b                   	pop    %ebx
  80319c:	5d                   	pop    %ebp
  80319d:	c3                   	ret    

0080319e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80319e:	55                   	push   %ebp
  80319f:	89 e5                	mov    %esp,%ebp
  8031a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8031ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031af:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8031b4:	b8 03 00 00 00       	mov    $0x3,%eax
  8031b9:	e8 e5 fe ff ff       	call   8030a3 <nsipc>
}
  8031be:	c9                   	leave  
  8031bf:	c3                   	ret    

008031c0 <nsipc_close>:

int
nsipc_close(int s)
{
  8031c0:	55                   	push   %ebp
  8031c1:	89 e5                	mov    %esp,%ebp
  8031c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8031ce:	b8 04 00 00 00       	mov    $0x4,%eax
  8031d3:	e8 cb fe ff ff       	call   8030a3 <nsipc>
}
  8031d8:	c9                   	leave  
  8031d9:	c3                   	ret    

008031da <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8031da:	55                   	push   %ebp
  8031db:	89 e5                	mov    %esp,%ebp
  8031dd:	53                   	push   %ebx
  8031de:	83 ec 14             	sub    $0x14,%esp
  8031e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8031ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031f7:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8031fe:	e8 01 e2 ff ff       	call   801404 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803203:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803209:	b8 05 00 00 00       	mov    $0x5,%eax
  80320e:	e8 90 fe ff ff       	call   8030a3 <nsipc>
}
  803213:	83 c4 14             	add    $0x14,%esp
  803216:	5b                   	pop    %ebx
  803217:	5d                   	pop    %ebp
  803218:	c3                   	ret    

00803219 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803219:	55                   	push   %ebp
  80321a:	89 e5                	mov    %esp,%ebp
  80321c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80322a:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80322f:	b8 06 00 00 00       	mov    $0x6,%eax
  803234:	e8 6a fe ff ff       	call   8030a3 <nsipc>
}
  803239:	c9                   	leave  
  80323a:	c3                   	ret    

0080323b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80323b:	55                   	push   %ebp
  80323c:	89 e5                	mov    %esp,%ebp
  80323e:	56                   	push   %esi
  80323f:	53                   	push   %ebx
  803240:	83 ec 10             	sub    $0x10,%esp
  803243:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80324e:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  803254:	8b 45 14             	mov    0x14(%ebp),%eax
  803257:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80325c:	b8 07 00 00 00       	mov    $0x7,%eax
  803261:	e8 3d fe ff ff       	call   8030a3 <nsipc>
  803266:	89 c3                	mov    %eax,%ebx
  803268:	85 c0                	test   %eax,%eax
  80326a:	78 46                	js     8032b2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80326c:	39 f0                	cmp    %esi,%eax
  80326e:	7f 07                	jg     803277 <nsipc_recv+0x3c>
  803270:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803275:	7e 24                	jle    80329b <nsipc_recv+0x60>
  803277:	c7 44 24 0c 02 44 80 	movl   $0x804402,0xc(%esp)
  80327e:	00 
  80327f:	c7 44 24 08 dd 3c 80 	movl   $0x803cdd,0x8(%esp)
  803286:	00 
  803287:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80328e:	00 
  80328f:	c7 04 24 17 44 80 00 	movl   $0x804417,(%esp)
  803296:	e8 b6 d7 ff ff       	call   800a51 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80329b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80329f:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8032a6:	00 
  8032a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032aa:	89 04 24             	mov    %eax,(%esp)
  8032ad:	e8 52 e1 ff ff       	call   801404 <memmove>
	}

	return r;
}
  8032b2:	89 d8                	mov    %ebx,%eax
  8032b4:	83 c4 10             	add    $0x10,%esp
  8032b7:	5b                   	pop    %ebx
  8032b8:	5e                   	pop    %esi
  8032b9:	5d                   	pop    %ebp
  8032ba:	c3                   	ret    

008032bb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8032bb:	55                   	push   %ebp
  8032bc:	89 e5                	mov    %esp,%ebp
  8032be:	53                   	push   %ebx
  8032bf:	83 ec 14             	sub    $0x14,%esp
  8032c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8032cd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8032d3:	7e 24                	jle    8032f9 <nsipc_send+0x3e>
  8032d5:	c7 44 24 0c 23 44 80 	movl   $0x804423,0xc(%esp)
  8032dc:	00 
  8032dd:	c7 44 24 08 dd 3c 80 	movl   $0x803cdd,0x8(%esp)
  8032e4:	00 
  8032e5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8032ec:	00 
  8032ed:	c7 04 24 17 44 80 00 	movl   $0x804417,(%esp)
  8032f4:	e8 58 d7 ff ff       	call   800a51 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8032f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803300:	89 44 24 04          	mov    %eax,0x4(%esp)
  803304:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  80330b:	e8 f4 e0 ff ff       	call   801404 <memmove>
	nsipcbuf.send.req_size = size;
  803310:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  803316:	8b 45 14             	mov    0x14(%ebp),%eax
  803319:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  80331e:	b8 08 00 00 00       	mov    $0x8,%eax
  803323:	e8 7b fd ff ff       	call   8030a3 <nsipc>
}
  803328:	83 c4 14             	add    $0x14,%esp
  80332b:	5b                   	pop    %ebx
  80332c:	5d                   	pop    %ebp
  80332d:	c3                   	ret    

0080332e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80332e:	55                   	push   %ebp
  80332f:	89 e5                	mov    %esp,%ebp
  803331:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80333c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803344:	8b 45 10             	mov    0x10(%ebp),%eax
  803347:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80334c:	b8 09 00 00 00       	mov    $0x9,%eax
  803351:	e8 4d fd ff ff       	call   8030a3 <nsipc>
}
  803356:	c9                   	leave  
  803357:	c3                   	ret    

00803358 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803358:	55                   	push   %ebp
  803359:	89 e5                	mov    %esp,%ebp
  80335b:	56                   	push   %esi
  80335c:	53                   	push   %ebx
  80335d:	83 ec 10             	sub    $0x10,%esp
  803360:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	89 04 24             	mov    %eax,(%esp)
  803369:	e8 12 eb ff ff       	call   801e80 <fd2data>
  80336e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803370:	c7 44 24 04 2f 44 80 	movl   $0x80442f,0x4(%esp)
  803377:	00 
  803378:	89 1c 24             	mov    %ebx,(%esp)
  80337b:	e8 e7 de ff ff       	call   801267 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803380:	8b 46 04             	mov    0x4(%esi),%eax
  803383:	2b 06                	sub    (%esi),%eax
  803385:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80338b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803392:	00 00 00 
	stat->st_dev = &devpipe;
  803395:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  80339c:	50 80 00 
	return 0;
}
  80339f:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a4:	83 c4 10             	add    $0x10,%esp
  8033a7:	5b                   	pop    %ebx
  8033a8:	5e                   	pop    %esi
  8033a9:	5d                   	pop    %ebp
  8033aa:	c3                   	ret    

008033ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8033ab:	55                   	push   %ebp
  8033ac:	89 e5                	mov    %esp,%ebp
  8033ae:	53                   	push   %ebx
  8033af:	83 ec 14             	sub    $0x14,%esp
  8033b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8033b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8033b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8033c0:	e8 65 e3 ff ff       	call   80172a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8033c5:	89 1c 24             	mov    %ebx,(%esp)
  8033c8:	e8 b3 ea ff ff       	call   801e80 <fd2data>
  8033cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8033d8:	e8 4d e3 ff ff       	call   80172a <sys_page_unmap>
}
  8033dd:	83 c4 14             	add    $0x14,%esp
  8033e0:	5b                   	pop    %ebx
  8033e1:	5d                   	pop    %ebp
  8033e2:	c3                   	ret    

008033e3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8033e3:	55                   	push   %ebp
  8033e4:	89 e5                	mov    %esp,%ebp
  8033e6:	57                   	push   %edi
  8033e7:	56                   	push   %esi
  8033e8:	53                   	push   %ebx
  8033e9:	83 ec 2c             	sub    $0x2c,%esp
  8033ec:	89 c6                	mov    %eax,%esi
  8033ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8033f1:	a1 28 64 80 00       	mov    0x806428,%eax
  8033f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8033f9:	89 34 24             	mov    %esi,(%esp)
  8033fc:	e8 d1 04 00 00       	call   8038d2 <pageref>
  803401:	89 c7                	mov    %eax,%edi
  803403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803406:	89 04 24             	mov    %eax,(%esp)
  803409:	e8 c4 04 00 00       	call   8038d2 <pageref>
  80340e:	39 c7                	cmp    %eax,%edi
  803410:	0f 94 c2             	sete   %dl
  803413:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  803416:	8b 0d 28 64 80 00    	mov    0x806428,%ecx
  80341c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80341f:	39 fb                	cmp    %edi,%ebx
  803421:	74 21                	je     803444 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  803423:	84 d2                	test   %dl,%dl
  803425:	74 ca                	je     8033f1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803427:	8b 51 58             	mov    0x58(%ecx),%edx
  80342a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80342e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803432:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803436:	c7 04 24 36 44 80 00 	movl   $0x804436,(%esp)
  80343d:	e8 08 d7 ff ff       	call   800b4a <cprintf>
  803442:	eb ad                	jmp    8033f1 <_pipeisclosed+0xe>
	}
}
  803444:	83 c4 2c             	add    $0x2c,%esp
  803447:	5b                   	pop    %ebx
  803448:	5e                   	pop    %esi
  803449:	5f                   	pop    %edi
  80344a:	5d                   	pop    %ebp
  80344b:	c3                   	ret    

0080344c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80344c:	55                   	push   %ebp
  80344d:	89 e5                	mov    %esp,%ebp
  80344f:	57                   	push   %edi
  803450:	56                   	push   %esi
  803451:	53                   	push   %ebx
  803452:	83 ec 1c             	sub    $0x1c,%esp
  803455:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803458:	89 34 24             	mov    %esi,(%esp)
  80345b:	e8 20 ea ff ff       	call   801e80 <fd2data>
  803460:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803462:	bf 00 00 00 00       	mov    $0x0,%edi
  803467:	eb 45                	jmp    8034ae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803469:	89 da                	mov    %ebx,%edx
  80346b:	89 f0                	mov    %esi,%eax
  80346d:	e8 71 ff ff ff       	call   8033e3 <_pipeisclosed>
  803472:	85 c0                	test   %eax,%eax
  803474:	75 41                	jne    8034b7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803476:	e8 e9 e1 ff ff       	call   801664 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80347b:	8b 43 04             	mov    0x4(%ebx),%eax
  80347e:	8b 0b                	mov    (%ebx),%ecx
  803480:	8d 51 20             	lea    0x20(%ecx),%edx
  803483:	39 d0                	cmp    %edx,%eax
  803485:	73 e2                	jae    803469 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803487:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80348a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80348e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803491:	99                   	cltd   
  803492:	c1 ea 1b             	shr    $0x1b,%edx
  803495:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  803498:	83 e1 1f             	and    $0x1f,%ecx
  80349b:	29 d1                	sub    %edx,%ecx
  80349d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8034a1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8034a5:	83 c0 01             	add    $0x1,%eax
  8034a8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034ab:	83 c7 01             	add    $0x1,%edi
  8034ae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8034b1:	75 c8                	jne    80347b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8034b3:	89 f8                	mov    %edi,%eax
  8034b5:	eb 05                	jmp    8034bc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8034b7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8034bc:	83 c4 1c             	add    $0x1c,%esp
  8034bf:	5b                   	pop    %ebx
  8034c0:	5e                   	pop    %esi
  8034c1:	5f                   	pop    %edi
  8034c2:	5d                   	pop    %ebp
  8034c3:	c3                   	ret    

008034c4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034c4:	55                   	push   %ebp
  8034c5:	89 e5                	mov    %esp,%ebp
  8034c7:	57                   	push   %edi
  8034c8:	56                   	push   %esi
  8034c9:	53                   	push   %ebx
  8034ca:	83 ec 1c             	sub    $0x1c,%esp
  8034cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8034d0:	89 3c 24             	mov    %edi,(%esp)
  8034d3:	e8 a8 e9 ff ff       	call   801e80 <fd2data>
  8034d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034da:	be 00 00 00 00       	mov    $0x0,%esi
  8034df:	eb 3d                	jmp    80351e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8034e1:	85 f6                	test   %esi,%esi
  8034e3:	74 04                	je     8034e9 <devpipe_read+0x25>
				return i;
  8034e5:	89 f0                	mov    %esi,%eax
  8034e7:	eb 43                	jmp    80352c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8034e9:	89 da                	mov    %ebx,%edx
  8034eb:	89 f8                	mov    %edi,%eax
  8034ed:	e8 f1 fe ff ff       	call   8033e3 <_pipeisclosed>
  8034f2:	85 c0                	test   %eax,%eax
  8034f4:	75 31                	jne    803527 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8034f6:	e8 69 e1 ff ff       	call   801664 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8034fb:	8b 03                	mov    (%ebx),%eax
  8034fd:	3b 43 04             	cmp    0x4(%ebx),%eax
  803500:	74 df                	je     8034e1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803502:	99                   	cltd   
  803503:	c1 ea 1b             	shr    $0x1b,%edx
  803506:	01 d0                	add    %edx,%eax
  803508:	83 e0 1f             	and    $0x1f,%eax
  80350b:	29 d0                	sub    %edx,%eax
  80350d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803512:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803515:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803518:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80351b:	83 c6 01             	add    $0x1,%esi
  80351e:	3b 75 10             	cmp    0x10(%ebp),%esi
  803521:	75 d8                	jne    8034fb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803523:	89 f0                	mov    %esi,%eax
  803525:	eb 05                	jmp    80352c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803527:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80352c:	83 c4 1c             	add    $0x1c,%esp
  80352f:	5b                   	pop    %ebx
  803530:	5e                   	pop    %esi
  803531:	5f                   	pop    %edi
  803532:	5d                   	pop    %ebp
  803533:	c3                   	ret    

00803534 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803534:	55                   	push   %ebp
  803535:	89 e5                	mov    %esp,%ebp
  803537:	56                   	push   %esi
  803538:	53                   	push   %ebx
  803539:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80353c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80353f:	89 04 24             	mov    %eax,(%esp)
  803542:	e8 50 e9 ff ff       	call   801e97 <fd_alloc>
  803547:	89 c2                	mov    %eax,%edx
  803549:	85 d2                	test   %edx,%edx
  80354b:	0f 88 4d 01 00 00    	js     80369e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803551:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803558:	00 
  803559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803560:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803567:	e8 17 e1 ff ff       	call   801683 <sys_page_alloc>
  80356c:	89 c2                	mov    %eax,%edx
  80356e:	85 d2                	test   %edx,%edx
  803570:	0f 88 28 01 00 00    	js     80369e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803576:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803579:	89 04 24             	mov    %eax,(%esp)
  80357c:	e8 16 e9 ff ff       	call   801e97 <fd_alloc>
  803581:	89 c3                	mov    %eax,%ebx
  803583:	85 c0                	test   %eax,%eax
  803585:	0f 88 fe 00 00 00    	js     803689 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80358b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803592:	00 
  803593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803596:	89 44 24 04          	mov    %eax,0x4(%esp)
  80359a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035a1:	e8 dd e0 ff ff       	call   801683 <sys_page_alloc>
  8035a6:	89 c3                	mov    %eax,%ebx
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	0f 88 d9 00 00 00    	js     803689 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8035b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b3:	89 04 24             	mov    %eax,(%esp)
  8035b6:	e8 c5 e8 ff ff       	call   801e80 <fd2data>
  8035bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035bd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8035c4:	00 
  8035c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035d0:	e8 ae e0 ff ff       	call   801683 <sys_page_alloc>
  8035d5:	89 c3                	mov    %eax,%ebx
  8035d7:	85 c0                	test   %eax,%eax
  8035d9:	0f 88 97 00 00 00    	js     803676 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e2:	89 04 24             	mov    %eax,(%esp)
  8035e5:	e8 96 e8 ff ff       	call   801e80 <fd2data>
  8035ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8035f1:	00 
  8035f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8035fd:	00 
  8035fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  803602:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803609:	e8 c9 e0 ff ff       	call   8016d7 <sys_page_map>
  80360e:	89 c3                	mov    %eax,%ebx
  803610:	85 c0                	test   %eax,%eax
  803612:	78 52                	js     803666 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803614:	8b 15 58 50 80 00    	mov    0x805058,%edx
  80361a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803622:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803629:	8b 15 58 50 80 00    	mov    0x805058,%edx
  80362f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803632:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803637:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80363e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803641:	89 04 24             	mov    %eax,(%esp)
  803644:	e8 27 e8 ff ff       	call   801e70 <fd2num>
  803649:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80364c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80364e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803651:	89 04 24             	mov    %eax,(%esp)
  803654:	e8 17 e8 ff ff       	call   801e70 <fd2num>
  803659:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80365c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80365f:	b8 00 00 00 00       	mov    $0x0,%eax
  803664:	eb 38                	jmp    80369e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  803666:	89 74 24 04          	mov    %esi,0x4(%esp)
  80366a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803671:	e8 b4 e0 ff ff       	call   80172a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803679:	89 44 24 04          	mov    %eax,0x4(%esp)
  80367d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803684:	e8 a1 e0 ff ff       	call   80172a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  803689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803690:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803697:	e8 8e e0 ff ff       	call   80172a <sys_page_unmap>
  80369c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80369e:	83 c4 30             	add    $0x30,%esp
  8036a1:	5b                   	pop    %ebx
  8036a2:	5e                   	pop    %esi
  8036a3:	5d                   	pop    %ebp
  8036a4:	c3                   	ret    

008036a5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8036a5:	55                   	push   %ebp
  8036a6:	89 e5                	mov    %esp,%ebp
  8036a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	89 04 24             	mov    %eax,(%esp)
  8036b8:	e8 29 e8 ff ff       	call   801ee6 <fd_lookup>
  8036bd:	89 c2                	mov    %eax,%edx
  8036bf:	85 d2                	test   %edx,%edx
  8036c1:	78 15                	js     8036d8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c6:	89 04 24             	mov    %eax,(%esp)
  8036c9:	e8 b2 e7 ff ff       	call   801e80 <fd2data>
	return _pipeisclosed(fd, p);
  8036ce:	89 c2                	mov    %eax,%edx
  8036d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d3:	e8 0b fd ff ff       	call   8033e3 <_pipeisclosed>
}
  8036d8:	c9                   	leave  
  8036d9:	c3                   	ret    

008036da <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8036da:	55                   	push   %ebp
  8036db:	89 e5                	mov    %esp,%ebp
  8036dd:	56                   	push   %esi
  8036de:	53                   	push   %ebx
  8036df:	83 ec 10             	sub    $0x10,%esp
  8036e2:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8036e5:	85 f6                	test   %esi,%esi
  8036e7:	75 24                	jne    80370d <wait+0x33>
  8036e9:	c7 44 24 0c 4e 44 80 	movl   $0x80444e,0xc(%esp)
  8036f0:	00 
  8036f1:	c7 44 24 08 dd 3c 80 	movl   $0x803cdd,0x8(%esp)
  8036f8:	00 
  8036f9:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  803700:	00 
  803701:	c7 04 24 59 44 80 00 	movl   $0x804459,(%esp)
  803708:	e8 44 d3 ff ff       	call   800a51 <_panic>
	e = &envs[ENVX(envid)];
  80370d:	89 f3                	mov    %esi,%ebx
  80370f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  803715:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803718:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80371e:	eb 05                	jmp    803725 <wait+0x4b>
		sys_yield();
  803720:	e8 3f df ff ff       	call   801664 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803725:	8b 43 48             	mov    0x48(%ebx),%eax
  803728:	39 f0                	cmp    %esi,%eax
  80372a:	75 07                	jne    803733 <wait+0x59>
  80372c:	8b 43 54             	mov    0x54(%ebx),%eax
  80372f:	85 c0                	test   %eax,%eax
  803731:	75 ed                	jne    803720 <wait+0x46>
		sys_yield();
}
  803733:	83 c4 10             	add    $0x10,%esp
  803736:	5b                   	pop    %ebx
  803737:	5e                   	pop    %esi
  803738:	5d                   	pop    %ebp
  803739:	c3                   	ret    

0080373a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80373a:	55                   	push   %ebp
  80373b:	89 e5                	mov    %esp,%ebp
  80373d:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  803740:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  803747:	75 58                	jne    8037a1 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  803749:	a1 28 64 80 00       	mov    0x806428,%eax
  80374e:	8b 40 48             	mov    0x48(%eax),%eax
  803751:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803758:	00 
  803759:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803760:	ee 
  803761:	89 04 24             	mov    %eax,(%esp)
  803764:	e8 1a df ff ff       	call   801683 <sys_page_alloc>
		if(return_code!=0)
  803769:	85 c0                	test   %eax,%eax
  80376b:	74 1c                	je     803789 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  80376d:	c7 44 24 08 64 44 80 	movl   $0x804464,0x8(%esp)
  803774:	00 
  803775:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80377c:	00 
  80377d:	c7 04 24 c0 44 80 00 	movl   $0x8044c0,(%esp)
  803784:	e8 c8 d2 ff ff       	call   800a51 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  803789:	a1 28 64 80 00       	mov    0x806428,%eax
  80378e:	8b 40 48             	mov    0x48(%eax),%eax
  803791:	c7 44 24 04 ab 37 80 	movl   $0x8037ab,0x4(%esp)
  803798:	00 
  803799:	89 04 24             	mov    %eax,(%esp)
  80379c:	e8 82 e0 ff ff       	call   801823 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	a3 00 90 80 00       	mov    %eax,0x809000
}
  8037a9:	c9                   	leave  
  8037aa:	c3                   	ret    

008037ab <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8037ab:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8037ac:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  8037b1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8037b3:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  8037b6:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  8037b8:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  8037bc:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  8037c0:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  8037c1:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  8037c3:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  8037c5:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  8037c9:	58                   	pop    %eax
	popl %eax;
  8037ca:	58                   	pop    %eax
	popal;
  8037cb:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  8037cc:	83 c4 04             	add    $0x4,%esp
	popfl;
  8037cf:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  8037d0:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  8037d1:	c3                   	ret    

008037d2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8037d2:	55                   	push   %ebp
  8037d3:	89 e5                	mov    %esp,%ebp
  8037d5:	56                   	push   %esi
  8037d6:	53                   	push   %ebx
  8037d7:	83 ec 10             	sub    $0x10,%esp
  8037da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8037dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e0:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8037e3:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8037e5:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8037ea:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8037ed:	89 04 24             	mov    %eax,(%esp)
  8037f0:	e8 a4 e0 ff ff       	call   801899 <sys_ipc_recv>
  8037f5:	85 c0                	test   %eax,%eax
  8037f7:	75 1e                	jne    803817 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  8037f9:	85 db                	test   %ebx,%ebx
  8037fb:	74 0a                	je     803807 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8037fd:	a1 28 64 80 00       	mov    0x806428,%eax
  803802:	8b 40 74             	mov    0x74(%eax),%eax
  803805:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  803807:	85 f6                	test   %esi,%esi
  803809:	74 22                	je     80382d <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  80380b:	a1 28 64 80 00       	mov    0x806428,%eax
  803810:	8b 40 78             	mov    0x78(%eax),%eax
  803813:	89 06                	mov    %eax,(%esi)
  803815:	eb 16                	jmp    80382d <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  803817:	85 f6                	test   %esi,%esi
  803819:	74 06                	je     803821 <ipc_recv+0x4f>
				*perm_store = 0;
  80381b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  803821:	85 db                	test   %ebx,%ebx
  803823:	74 10                	je     803835 <ipc_recv+0x63>
				*from_env_store=0;
  803825:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80382b:	eb 08                	jmp    803835 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  80382d:	a1 28 64 80 00       	mov    0x806428,%eax
  803832:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  803835:	83 c4 10             	add    $0x10,%esp
  803838:	5b                   	pop    %ebx
  803839:	5e                   	pop    %esi
  80383a:	5d                   	pop    %ebp
  80383b:	c3                   	ret    

0080383c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80383c:	55                   	push   %ebp
  80383d:	89 e5                	mov    %esp,%ebp
  80383f:	57                   	push   %edi
  803840:	56                   	push   %esi
  803841:	53                   	push   %ebx
  803842:	83 ec 1c             	sub    $0x1c,%esp
  803845:	8b 75 0c             	mov    0xc(%ebp),%esi
  803848:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80384b:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  80384e:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  803850:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  803855:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  803858:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80385c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803860:	89 74 24 04          	mov    %esi,0x4(%esp)
  803864:	8b 45 08             	mov    0x8(%ebp),%eax
  803867:	89 04 24             	mov    %eax,(%esp)
  80386a:	e8 07 e0 ff ff       	call   801876 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  80386f:	eb 1c                	jmp    80388d <ipc_send+0x51>
	{
		sys_yield();
  803871:	e8 ee dd ff ff       	call   801664 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  803876:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80387a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80387e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803882:	8b 45 08             	mov    0x8(%ebp),%eax
  803885:	89 04 24             	mov    %eax,(%esp)
  803888:	e8 e9 df ff ff       	call   801876 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  80388d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803890:	74 df                	je     803871 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  803892:	83 c4 1c             	add    $0x1c,%esp
  803895:	5b                   	pop    %ebx
  803896:	5e                   	pop    %esi
  803897:	5f                   	pop    %edi
  803898:	5d                   	pop    %ebp
  803899:	c3                   	ret    

0080389a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80389a:	55                   	push   %ebp
  80389b:	89 e5                	mov    %esp,%ebp
  80389d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8038a0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8038a5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8038a8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8038ae:	8b 52 50             	mov    0x50(%edx),%edx
  8038b1:	39 ca                	cmp    %ecx,%edx
  8038b3:	75 0d                	jne    8038c2 <ipc_find_env+0x28>
			return envs[i].env_id;
  8038b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8038b8:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8038bd:	8b 40 40             	mov    0x40(%eax),%eax
  8038c0:	eb 0e                	jmp    8038d0 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8038c2:	83 c0 01             	add    $0x1,%eax
  8038c5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8038ca:	75 d9                	jne    8038a5 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8038cc:	66 b8 00 00          	mov    $0x0,%ax
}
  8038d0:	5d                   	pop    %ebp
  8038d1:	c3                   	ret    

008038d2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8038d2:	55                   	push   %ebp
  8038d3:	89 e5                	mov    %esp,%ebp
  8038d5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8038d8:	89 d0                	mov    %edx,%eax
  8038da:	c1 e8 16             	shr    $0x16,%eax
  8038dd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8038e4:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8038e9:	f6 c1 01             	test   $0x1,%cl
  8038ec:	74 1d                	je     80390b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8038ee:	c1 ea 0c             	shr    $0xc,%edx
  8038f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8038f8:	f6 c2 01             	test   $0x1,%dl
  8038fb:	74 0e                	je     80390b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8038fd:	c1 ea 0c             	shr    $0xc,%edx
  803900:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803907:	ef 
  803908:	0f b7 c0             	movzwl %ax,%eax
}
  80390b:	5d                   	pop    %ebp
  80390c:	c3                   	ret    
  80390d:	66 90                	xchg   %ax,%ax
  80390f:	90                   	nop

00803910 <__udivdi3>:
  803910:	55                   	push   %ebp
  803911:	57                   	push   %edi
  803912:	56                   	push   %esi
  803913:	83 ec 0c             	sub    $0xc,%esp
  803916:	8b 44 24 28          	mov    0x28(%esp),%eax
  80391a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80391e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803922:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803926:	85 c0                	test   %eax,%eax
  803928:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80392c:	89 ea                	mov    %ebp,%edx
  80392e:	89 0c 24             	mov    %ecx,(%esp)
  803931:	75 2d                	jne    803960 <__udivdi3+0x50>
  803933:	39 e9                	cmp    %ebp,%ecx
  803935:	77 61                	ja     803998 <__udivdi3+0x88>
  803937:	85 c9                	test   %ecx,%ecx
  803939:	89 ce                	mov    %ecx,%esi
  80393b:	75 0b                	jne    803948 <__udivdi3+0x38>
  80393d:	b8 01 00 00 00       	mov    $0x1,%eax
  803942:	31 d2                	xor    %edx,%edx
  803944:	f7 f1                	div    %ecx
  803946:	89 c6                	mov    %eax,%esi
  803948:	31 d2                	xor    %edx,%edx
  80394a:	89 e8                	mov    %ebp,%eax
  80394c:	f7 f6                	div    %esi
  80394e:	89 c5                	mov    %eax,%ebp
  803950:	89 f8                	mov    %edi,%eax
  803952:	f7 f6                	div    %esi
  803954:	89 ea                	mov    %ebp,%edx
  803956:	83 c4 0c             	add    $0xc,%esp
  803959:	5e                   	pop    %esi
  80395a:	5f                   	pop    %edi
  80395b:	5d                   	pop    %ebp
  80395c:	c3                   	ret    
  80395d:	8d 76 00             	lea    0x0(%esi),%esi
  803960:	39 e8                	cmp    %ebp,%eax
  803962:	77 24                	ja     803988 <__udivdi3+0x78>
  803964:	0f bd e8             	bsr    %eax,%ebp
  803967:	83 f5 1f             	xor    $0x1f,%ebp
  80396a:	75 3c                	jne    8039a8 <__udivdi3+0x98>
  80396c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803970:	39 34 24             	cmp    %esi,(%esp)
  803973:	0f 86 9f 00 00 00    	jbe    803a18 <__udivdi3+0x108>
  803979:	39 d0                	cmp    %edx,%eax
  80397b:	0f 82 97 00 00 00    	jb     803a18 <__udivdi3+0x108>
  803981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803988:	31 d2                	xor    %edx,%edx
  80398a:	31 c0                	xor    %eax,%eax
  80398c:	83 c4 0c             	add    $0xc,%esp
  80398f:	5e                   	pop    %esi
  803990:	5f                   	pop    %edi
  803991:	5d                   	pop    %ebp
  803992:	c3                   	ret    
  803993:	90                   	nop
  803994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803998:	89 f8                	mov    %edi,%eax
  80399a:	f7 f1                	div    %ecx
  80399c:	31 d2                	xor    %edx,%edx
  80399e:	83 c4 0c             	add    $0xc,%esp
  8039a1:	5e                   	pop    %esi
  8039a2:	5f                   	pop    %edi
  8039a3:	5d                   	pop    %ebp
  8039a4:	c3                   	ret    
  8039a5:	8d 76 00             	lea    0x0(%esi),%esi
  8039a8:	89 e9                	mov    %ebp,%ecx
  8039aa:	8b 3c 24             	mov    (%esp),%edi
  8039ad:	d3 e0                	shl    %cl,%eax
  8039af:	89 c6                	mov    %eax,%esi
  8039b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8039b6:	29 e8                	sub    %ebp,%eax
  8039b8:	89 c1                	mov    %eax,%ecx
  8039ba:	d3 ef                	shr    %cl,%edi
  8039bc:	89 e9                	mov    %ebp,%ecx
  8039be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8039c2:	8b 3c 24             	mov    (%esp),%edi
  8039c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8039c9:	89 d6                	mov    %edx,%esi
  8039cb:	d3 e7                	shl    %cl,%edi
  8039cd:	89 c1                	mov    %eax,%ecx
  8039cf:	89 3c 24             	mov    %edi,(%esp)
  8039d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8039d6:	d3 ee                	shr    %cl,%esi
  8039d8:	89 e9                	mov    %ebp,%ecx
  8039da:	d3 e2                	shl    %cl,%edx
  8039dc:	89 c1                	mov    %eax,%ecx
  8039de:	d3 ef                	shr    %cl,%edi
  8039e0:	09 d7                	or     %edx,%edi
  8039e2:	89 f2                	mov    %esi,%edx
  8039e4:	89 f8                	mov    %edi,%eax
  8039e6:	f7 74 24 08          	divl   0x8(%esp)
  8039ea:	89 d6                	mov    %edx,%esi
  8039ec:	89 c7                	mov    %eax,%edi
  8039ee:	f7 24 24             	mull   (%esp)
  8039f1:	39 d6                	cmp    %edx,%esi
  8039f3:	89 14 24             	mov    %edx,(%esp)
  8039f6:	72 30                	jb     803a28 <__udivdi3+0x118>
  8039f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039fc:	89 e9                	mov    %ebp,%ecx
  8039fe:	d3 e2                	shl    %cl,%edx
  803a00:	39 c2                	cmp    %eax,%edx
  803a02:	73 05                	jae    803a09 <__udivdi3+0xf9>
  803a04:	3b 34 24             	cmp    (%esp),%esi
  803a07:	74 1f                	je     803a28 <__udivdi3+0x118>
  803a09:	89 f8                	mov    %edi,%eax
  803a0b:	31 d2                	xor    %edx,%edx
  803a0d:	e9 7a ff ff ff       	jmp    80398c <__udivdi3+0x7c>
  803a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803a18:	31 d2                	xor    %edx,%edx
  803a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a1f:	e9 68 ff ff ff       	jmp    80398c <__udivdi3+0x7c>
  803a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803a28:	8d 47 ff             	lea    -0x1(%edi),%eax
  803a2b:	31 d2                	xor    %edx,%edx
  803a2d:	83 c4 0c             	add    $0xc,%esp
  803a30:	5e                   	pop    %esi
  803a31:	5f                   	pop    %edi
  803a32:	5d                   	pop    %ebp
  803a33:	c3                   	ret    
  803a34:	66 90                	xchg   %ax,%ax
  803a36:	66 90                	xchg   %ax,%ax
  803a38:	66 90                	xchg   %ax,%ax
  803a3a:	66 90                	xchg   %ax,%ax
  803a3c:	66 90                	xchg   %ax,%ax
  803a3e:	66 90                	xchg   %ax,%ax

00803a40 <__umoddi3>:
  803a40:	55                   	push   %ebp
  803a41:	57                   	push   %edi
  803a42:	56                   	push   %esi
  803a43:	83 ec 14             	sub    $0x14,%esp
  803a46:	8b 44 24 28          	mov    0x28(%esp),%eax
  803a4a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803a4e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803a52:	89 c7                	mov    %eax,%edi
  803a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a58:	8b 44 24 30          	mov    0x30(%esp),%eax
  803a5c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803a60:	89 34 24             	mov    %esi,(%esp)
  803a63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a67:	85 c0                	test   %eax,%eax
  803a69:	89 c2                	mov    %eax,%edx
  803a6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a6f:	75 17                	jne    803a88 <__umoddi3+0x48>
  803a71:	39 fe                	cmp    %edi,%esi
  803a73:	76 4b                	jbe    803ac0 <__umoddi3+0x80>
  803a75:	89 c8                	mov    %ecx,%eax
  803a77:	89 fa                	mov    %edi,%edx
  803a79:	f7 f6                	div    %esi
  803a7b:	89 d0                	mov    %edx,%eax
  803a7d:	31 d2                	xor    %edx,%edx
  803a7f:	83 c4 14             	add    $0x14,%esp
  803a82:	5e                   	pop    %esi
  803a83:	5f                   	pop    %edi
  803a84:	5d                   	pop    %ebp
  803a85:	c3                   	ret    
  803a86:	66 90                	xchg   %ax,%ax
  803a88:	39 f8                	cmp    %edi,%eax
  803a8a:	77 54                	ja     803ae0 <__umoddi3+0xa0>
  803a8c:	0f bd e8             	bsr    %eax,%ebp
  803a8f:	83 f5 1f             	xor    $0x1f,%ebp
  803a92:	75 5c                	jne    803af0 <__umoddi3+0xb0>
  803a94:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803a98:	39 3c 24             	cmp    %edi,(%esp)
  803a9b:	0f 87 e7 00 00 00    	ja     803b88 <__umoddi3+0x148>
  803aa1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803aa5:	29 f1                	sub    %esi,%ecx
  803aa7:	19 c7                	sbb    %eax,%edi
  803aa9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803aad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ab1:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ab5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803ab9:	83 c4 14             	add    $0x14,%esp
  803abc:	5e                   	pop    %esi
  803abd:	5f                   	pop    %edi
  803abe:	5d                   	pop    %ebp
  803abf:	c3                   	ret    
  803ac0:	85 f6                	test   %esi,%esi
  803ac2:	89 f5                	mov    %esi,%ebp
  803ac4:	75 0b                	jne    803ad1 <__umoddi3+0x91>
  803ac6:	b8 01 00 00 00       	mov    $0x1,%eax
  803acb:	31 d2                	xor    %edx,%edx
  803acd:	f7 f6                	div    %esi
  803acf:	89 c5                	mov    %eax,%ebp
  803ad1:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ad5:	31 d2                	xor    %edx,%edx
  803ad7:	f7 f5                	div    %ebp
  803ad9:	89 c8                	mov    %ecx,%eax
  803adb:	f7 f5                	div    %ebp
  803add:	eb 9c                	jmp    803a7b <__umoddi3+0x3b>
  803adf:	90                   	nop
  803ae0:	89 c8                	mov    %ecx,%eax
  803ae2:	89 fa                	mov    %edi,%edx
  803ae4:	83 c4 14             	add    $0x14,%esp
  803ae7:	5e                   	pop    %esi
  803ae8:	5f                   	pop    %edi
  803ae9:	5d                   	pop    %ebp
  803aea:	c3                   	ret    
  803aeb:	90                   	nop
  803aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803af0:	8b 04 24             	mov    (%esp),%eax
  803af3:	be 20 00 00 00       	mov    $0x20,%esi
  803af8:	89 e9                	mov    %ebp,%ecx
  803afa:	29 ee                	sub    %ebp,%esi
  803afc:	d3 e2                	shl    %cl,%edx
  803afe:	89 f1                	mov    %esi,%ecx
  803b00:	d3 e8                	shr    %cl,%eax
  803b02:	89 e9                	mov    %ebp,%ecx
  803b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b08:	8b 04 24             	mov    (%esp),%eax
  803b0b:	09 54 24 04          	or     %edx,0x4(%esp)
  803b0f:	89 fa                	mov    %edi,%edx
  803b11:	d3 e0                	shl    %cl,%eax
  803b13:	89 f1                	mov    %esi,%ecx
  803b15:	89 44 24 08          	mov    %eax,0x8(%esp)
  803b19:	8b 44 24 10          	mov    0x10(%esp),%eax
  803b1d:	d3 ea                	shr    %cl,%edx
  803b1f:	89 e9                	mov    %ebp,%ecx
  803b21:	d3 e7                	shl    %cl,%edi
  803b23:	89 f1                	mov    %esi,%ecx
  803b25:	d3 e8                	shr    %cl,%eax
  803b27:	89 e9                	mov    %ebp,%ecx
  803b29:	09 f8                	or     %edi,%eax
  803b2b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  803b2f:	f7 74 24 04          	divl   0x4(%esp)
  803b33:	d3 e7                	shl    %cl,%edi
  803b35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b39:	89 d7                	mov    %edx,%edi
  803b3b:	f7 64 24 08          	mull   0x8(%esp)
  803b3f:	39 d7                	cmp    %edx,%edi
  803b41:	89 c1                	mov    %eax,%ecx
  803b43:	89 14 24             	mov    %edx,(%esp)
  803b46:	72 2c                	jb     803b74 <__umoddi3+0x134>
  803b48:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  803b4c:	72 22                	jb     803b70 <__umoddi3+0x130>
  803b4e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803b52:	29 c8                	sub    %ecx,%eax
  803b54:	19 d7                	sbb    %edx,%edi
  803b56:	89 e9                	mov    %ebp,%ecx
  803b58:	89 fa                	mov    %edi,%edx
  803b5a:	d3 e8                	shr    %cl,%eax
  803b5c:	89 f1                	mov    %esi,%ecx
  803b5e:	d3 e2                	shl    %cl,%edx
  803b60:	89 e9                	mov    %ebp,%ecx
  803b62:	d3 ef                	shr    %cl,%edi
  803b64:	09 d0                	or     %edx,%eax
  803b66:	89 fa                	mov    %edi,%edx
  803b68:	83 c4 14             	add    $0x14,%esp
  803b6b:	5e                   	pop    %esi
  803b6c:	5f                   	pop    %edi
  803b6d:	5d                   	pop    %ebp
  803b6e:	c3                   	ret    
  803b6f:	90                   	nop
  803b70:	39 d7                	cmp    %edx,%edi
  803b72:	75 da                	jne    803b4e <__umoddi3+0x10e>
  803b74:	8b 14 24             	mov    (%esp),%edx
  803b77:	89 c1                	mov    %eax,%ecx
  803b79:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  803b7d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803b81:	eb cb                	jmp    803b4e <__umoddi3+0x10e>
  803b83:	90                   	nop
  803b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803b88:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  803b8c:	0f 82 0f ff ff ff    	jb     803aa1 <__umoddi3+0x61>
  803b92:	e9 1a ff ff ff       	jmp    803ab1 <__umoddi3+0x71>
