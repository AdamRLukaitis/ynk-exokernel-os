
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 fa 02 00 00       	call   80032b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
  800048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80004e:	83 3d d0 51 80 00 00 	cmpl   $0x0,0x8051d0
  800055:	74 23                	je     80007a <ls1+0x3a>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800057:	89 f0                	mov    %esi,%eax
  800059:	3c 01                	cmp    $0x1,%al
  80005b:	19 c0                	sbb    %eax,%eax
  80005d:	83 e0 c9             	and    $0xffffffc9,%eax
  800060:	83 c0 64             	add    $0x64,%eax
  800063:	89 44 24 08          	mov    %eax,0x8(%esp)
  800067:	8b 45 10             	mov    0x10(%ebp),%eax
  80006a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006e:	c7 04 24 42 2b 80 00 	movl   $0x802b42,(%esp)
  800075:	e8 79 1c 00 00       	call   801cf3 <printf>
	if(prefix) {
  80007a:	85 db                	test   %ebx,%ebx
  80007c:	74 38                	je     8000b6 <ls1+0x76>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80007e:	b8 a8 2b 80 00       	mov    $0x802ba8,%eax
	const char *sep;

	if(flag['l'])
		printf("%11d %c ", size, isdir ? 'd' : '-');
	if(prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800083:	80 3b 00             	cmpb   $0x0,(%ebx)
  800086:	74 1a                	je     8000a2 <ls1+0x62>
  800088:	89 1c 24             	mov    %ebx,(%esp)
  80008b:	e8 f0 09 00 00       	call   800a80 <strlen>
  800090:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
			sep = "/";
  800095:	b8 40 2b 80 00       	mov    $0x802b40,%eax
  80009a:	ba a8 2b 80 00       	mov    $0x802ba8,%edx
  80009f:	0f 44 c2             	cmove  %edx,%eax
		else
			sep = "";
		printf("%s%s", prefix, sep);
  8000a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000aa:	c7 04 24 4b 2b 80 00 	movl   $0x802b4b,(%esp)
  8000b1:	e8 3d 1c 00 00       	call   801cf3 <printf>
	}
	printf("%s", name);
  8000b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8000b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bd:	c7 04 24 d9 2f 80 00 	movl   $0x802fd9,(%esp)
  8000c4:	e8 2a 1c 00 00       	call   801cf3 <printf>
	if(flag['F'] && isdir)
  8000c9:	83 3d 38 51 80 00 00 	cmpl   $0x0,0x805138
  8000d0:	74 12                	je     8000e4 <ls1+0xa4>
  8000d2:	89 f0                	mov    %esi,%eax
  8000d4:	84 c0                	test   %al,%al
  8000d6:	74 0c                	je     8000e4 <ls1+0xa4>
		printf("/");
  8000d8:	c7 04 24 40 2b 80 00 	movl   $0x802b40,(%esp)
  8000df:	e8 0f 1c 00 00       	call   801cf3 <printf>
	printf("\n");
  8000e4:	c7 04 24 a7 2b 80 00 	movl   $0x802ba7,(%esp)
  8000eb:	e8 03 1c 00 00       	call   801cf3 <printf>
}
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    

008000f7 <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	57                   	push   %edi
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  800103:	8b 7d 08             	mov    0x8(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800106:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80010d:	00 
  80010e:	89 3c 24             	mov    %edi,(%esp)
  800111:	e8 2d 1a 00 00       	call   801b43 <open>
  800116:	89 c3                	mov    %eax,%ebx
  800118:	85 c0                	test   %eax,%eax
  80011a:	78 08                	js     800124 <lsdir+0x2d>
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80011c:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800122:	eb 57                	jmp    80017b <lsdir+0x84>
{
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
  800124:	89 44 24 10          	mov    %eax,0x10(%esp)
  800128:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80012c:	c7 44 24 08 50 2b 80 	movl   $0x802b50,0x8(%esp)
  800133:	00 
  800134:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  80013b:	00 
  80013c:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800143:	e8 4e 02 00 00       	call   800396 <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  800148:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  80014f:	74 2a                	je     80017b <lsdir+0x84>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800151:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800155:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80015b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80015f:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800166:	0f 94 c0             	sete   %al
  800169:	0f b6 c0             	movzbl %al,%eax
  80016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800170:	8b 45 0c             	mov    0xc(%ebp),%eax
  800173:	89 04 24             	mov    %eax,(%esp)
  800176:	e8 c5 fe ff ff       	call   800040 <ls1>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80017b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  800182:	00 
  800183:	89 74 24 04          	mov    %esi,0x4(%esp)
  800187:	89 1c 24             	mov    %ebx,(%esp)
  80018a:	e8 6d 15 00 00       	call   8016fc <readn>
  80018f:	3d 00 01 00 00       	cmp    $0x100,%eax
  800194:	74 b2                	je     800148 <lsdir+0x51>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  800196:	85 c0                	test   %eax,%eax
  800198:	7e 20                	jle    8001ba <lsdir+0xc3>
		panic("short read in directory %s", path);
  80019a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80019e:	c7 44 24 08 66 2b 80 	movl   $0x802b66,0x8(%esp)
  8001a5:	00 
  8001a6:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001ad:	00 
  8001ae:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  8001b5:	e8 dc 01 00 00       	call   800396 <_panic>
	if (n < 0)
  8001ba:	85 c0                	test   %eax,%eax
  8001bc:	79 24                	jns    8001e2 <lsdir+0xeb>
		panic("error reading directory %s: %e", path, n);
  8001be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001c2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001c6:	c7 44 24 08 ac 2b 80 	movl   $0x802bac,0x8(%esp)
  8001cd:	00 
  8001ce:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8001d5:	00 
  8001d6:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  8001dd:	e8 b4 01 00 00       	call   800396 <_panic>
}
  8001e2:	81 c4 2c 01 00 00    	add    $0x12c,%esp
  8001e8:	5b                   	pop    %ebx
  8001e9:	5e                   	pop    %esi
  8001ea:	5f                   	pop    %edi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	53                   	push   %ebx
  8001f1:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  8001f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  8001fa:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  800200:	89 44 24 04          	mov    %eax,0x4(%esp)
  800204:	89 1c 24             	mov    %ebx,(%esp)
  800207:	e8 f4 16 00 00       	call   801900 <stat>
  80020c:	85 c0                	test   %eax,%eax
  80020e:	79 24                	jns    800234 <ls+0x47>
		panic("stat %s: %e", path, r);
  800210:	89 44 24 10          	mov    %eax,0x10(%esp)
  800214:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800218:	c7 44 24 08 81 2b 80 	movl   $0x802b81,0x8(%esp)
  80021f:	00 
  800220:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800227:	00 
  800228:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  80022f:	e8 62 01 00 00       	call   800396 <_panic>
	if (st.st_isdir && !flag['d'])
  800234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800237:	85 c0                	test   %eax,%eax
  800239:	74 1a                	je     800255 <ls+0x68>
  80023b:	83 3d b0 51 80 00 00 	cmpl   $0x0,0x8051b0
  800242:	75 11                	jne    800255 <ls+0x68>
		lsdir(path, prefix);
  800244:	8b 45 0c             	mov    0xc(%ebp),%eax
  800247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024b:	89 1c 24             	mov    %ebx,(%esp)
  80024e:	e8 a4 fe ff ff       	call   8000f7 <lsdir>
  800253:	eb 23                	jmp    800278 <ls+0x8b>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  800255:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800259:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80025c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800260:	85 c0                	test   %eax,%eax
  800262:	0f 95 c0             	setne  %al
  800265:	0f b6 c0             	movzbl %al,%eax
  800268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800273:	e8 c8 fd ff ff       	call   800040 <ls1>
}
  800278:	81 c4 b4 00 00 00    	add    $0xb4,%esp
  80027e:	5b                   	pop    %ebx
  80027f:	5d                   	pop    %ebp
  800280:	c3                   	ret    

00800281 <usage>:
	printf("\n");
}

void
usage(void)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	83 ec 18             	sub    $0x18,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800287:	c7 04 24 8d 2b 80 00 	movl   $0x802b8d,(%esp)
  80028e:	e8 60 1a 00 00       	call   801cf3 <printf>
	exit();
  800293:	e8 e5 00 00 00       	call   80037d <exit>
}
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <umain>:

void
umain(int argc, char **argv)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	56                   	push   %esi
  80029e:	53                   	push   %ebx
  80029f:	83 ec 20             	sub    $0x20,%esp
  8002a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  8002a5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b0:	8d 45 08             	lea    0x8(%ebp),%eax
  8002b3:	89 04 24             	mov    %eax,(%esp)
  8002b6:	e8 45 0f 00 00       	call   801200 <argstart>
	while ((i = argnext(&args)) >= 0)
  8002bb:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  8002be:	eb 1e                	jmp    8002de <umain+0x44>
		switch (i) {
  8002c0:	83 f8 64             	cmp    $0x64,%eax
  8002c3:	74 0a                	je     8002cf <umain+0x35>
  8002c5:	83 f8 6c             	cmp    $0x6c,%eax
  8002c8:	74 05                	je     8002cf <umain+0x35>
  8002ca:	83 f8 46             	cmp    $0x46,%eax
  8002cd:	75 0a                	jne    8002d9 <umain+0x3f>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  8002cf:	83 04 85 20 50 80 00 	addl   $0x1,0x805020(,%eax,4)
  8002d6:	01 
			break;
  8002d7:	eb 05                	jmp    8002de <umain+0x44>
		default:
			usage();
  8002d9:	e8 a3 ff ff ff       	call   800281 <usage>
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8002de:	89 1c 24             	mov    %ebx,(%esp)
  8002e1:	e8 52 0f 00 00       	call   801238 <argnext>
  8002e6:	85 c0                	test   %eax,%eax
  8002e8:	79 d6                	jns    8002c0 <umain+0x26>
			break;
		default:
			usage();
		}

	if (argc == 1)
  8002ea:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8002ee:	74 07                	je     8002f7 <umain+0x5d>
  8002f0:	bb 01 00 00 00       	mov    $0x1,%ebx
  8002f5:	eb 28                	jmp    80031f <umain+0x85>
		ls("/", "");
  8002f7:	c7 44 24 04 a8 2b 80 	movl   $0x802ba8,0x4(%esp)
  8002fe:	00 
  8002ff:	c7 04 24 40 2b 80 00 	movl   $0x802b40,(%esp)
  800306:	e8 e2 fe ff ff       	call   8001ed <ls>
  80030b:	eb 17                	jmp    800324 <umain+0x8a>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
  80030d:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800310:	89 44 24 04          	mov    %eax,0x4(%esp)
  800314:	89 04 24             	mov    %eax,(%esp)
  800317:	e8 d1 fe ff ff       	call   8001ed <ls>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80031c:	83 c3 01             	add    $0x1,%ebx
  80031f:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800322:	7c e9                	jl     80030d <umain+0x73>
			ls(argv[i], argv[i]);
	}
}
  800324:	83 c4 20             	add    $0x20,%esp
  800327:	5b                   	pop    %ebx
  800328:	5e                   	pop    %esi
  800329:	5d                   	pop    %ebp
  80032a:	c3                   	ret    

0080032b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	56                   	push   %esi
  80032f:	53                   	push   %ebx
  800330:	83 ec 10             	sub    $0x10,%esp
  800333:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800336:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800339:	c7 05 20 54 80 00 00 	movl   $0x0,0x805420
  800340:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800343:	e8 4d 0b 00 00       	call   800e95 <sys_getenvid>
  800348:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80034d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800350:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800355:	a3 20 54 80 00       	mov    %eax,0x805420


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80035a:	85 db                	test   %ebx,%ebx
  80035c:	7e 07                	jle    800365 <libmain+0x3a>
		binaryname = argv[0];
  80035e:	8b 06                	mov    (%esi),%eax
  800360:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800365:	89 74 24 04          	mov    %esi,0x4(%esp)
  800369:	89 1c 24             	mov    %ebx,(%esp)
  80036c:	e8 29 ff ff ff       	call   80029a <umain>

	// exit gracefully
	exit();
  800371:	e8 07 00 00 00       	call   80037d <exit>
}
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	5b                   	pop    %ebx
  80037a:	5e                   	pop    %esi
  80037b:	5d                   	pop    %ebp
  80037c:	c3                   	ret    

0080037d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800383:	e8 b2 11 00 00       	call   80153a <close_all>
	sys_env_destroy(0);
  800388:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80038f:	e8 af 0a 00 00       	call   800e43 <sys_env_destroy>
}
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	56                   	push   %esi
  80039a:	53                   	push   %ebx
  80039b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80039e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003a1:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8003a7:	e8 e9 0a 00 00       	call   800e95 <sys_getenvid>
  8003ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003af:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003ba:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c2:	c7 04 24 d8 2b 80 00 	movl   $0x802bd8,(%esp)
  8003c9:	e8 c1 00 00 00       	call   80048f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d5:	89 04 24             	mov    %eax,(%esp)
  8003d8:	e8 51 00 00 00       	call   80042e <vcprintf>
	cprintf("\n");
  8003dd:	c7 04 24 a7 2b 80 00 	movl   $0x802ba7,(%esp)
  8003e4:	e8 a6 00 00 00       	call   80048f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003e9:	cc                   	int3   
  8003ea:	eb fd                	jmp    8003e9 <_panic+0x53>

008003ec <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	53                   	push   %ebx
  8003f0:	83 ec 14             	sub    $0x14,%esp
  8003f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003f6:	8b 13                	mov    (%ebx),%edx
  8003f8:	8d 42 01             	lea    0x1(%edx),%eax
  8003fb:	89 03                	mov    %eax,(%ebx)
  8003fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800400:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800404:	3d ff 00 00 00       	cmp    $0xff,%eax
  800409:	75 19                	jne    800424 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80040b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800412:	00 
  800413:	8d 43 08             	lea    0x8(%ebx),%eax
  800416:	89 04 24             	mov    %eax,(%esp)
  800419:	e8 e8 09 00 00       	call   800e06 <sys_cputs>
		b->idx = 0;
  80041e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800424:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800428:	83 c4 14             	add    $0x14,%esp
  80042b:	5b                   	pop    %ebx
  80042c:	5d                   	pop    %ebp
  80042d:	c3                   	ret    

0080042e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800437:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80043e:	00 00 00 
	b.cnt = 0;
  800441:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800448:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80044b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	89 44 24 08          	mov    %eax,0x8(%esp)
  800459:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80045f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800463:	c7 04 24 ec 03 80 00 	movl   $0x8003ec,(%esp)
  80046a:	e8 af 01 00 00       	call   80061e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80046f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800475:	89 44 24 04          	mov    %eax,0x4(%esp)
  800479:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80047f:	89 04 24             	mov    %eax,(%esp)
  800482:	e8 7f 09 00 00       	call   800e06 <sys_cputs>

	return b.cnt;
}
  800487:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800495:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800498:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	89 04 24             	mov    %eax,(%esp)
  8004a2:	e8 87 ff ff ff       	call   80042e <vcprintf>
	va_end(ap);

	return cnt;
}
  8004a7:	c9                   	leave  
  8004a8:	c3                   	ret    
  8004a9:	66 90                	xchg   %ax,%ax
  8004ab:	66 90                	xchg   %ax,%ax
  8004ad:	66 90                	xchg   %ax,%ax
  8004af:	90                   	nop

008004b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	57                   	push   %edi
  8004b4:	56                   	push   %esi
  8004b5:	53                   	push   %ebx
  8004b6:	83 ec 3c             	sub    $0x3c,%esp
  8004b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004bc:	89 d7                	mov    %edx,%edi
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c7:	89 c3                	mov    %eax,%ebx
  8004c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004da:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004dd:	39 d9                	cmp    %ebx,%ecx
  8004df:	72 05                	jb     8004e6 <printnum+0x36>
  8004e1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004e4:	77 69                	ja     80054f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004e9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004ed:	83 ee 01             	sub    $0x1,%esi
  8004f0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004fc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800500:	89 c3                	mov    %eax,%ebx
  800502:	89 d6                	mov    %edx,%esi
  800504:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800507:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80050a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80050e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800515:	89 04 24             	mov    %eax,(%esp)
  800518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80051b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051f:	e8 7c 23 00 00       	call   8028a0 <__udivdi3>
  800524:	89 d9                	mov    %ebx,%ecx
  800526:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80052a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	89 54 24 04          	mov    %edx,0x4(%esp)
  800535:	89 fa                	mov    %edi,%edx
  800537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80053a:	e8 71 ff ff ff       	call   8004b0 <printnum>
  80053f:	eb 1b                	jmp    80055c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800541:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800545:	8b 45 18             	mov    0x18(%ebp),%eax
  800548:	89 04 24             	mov    %eax,(%esp)
  80054b:	ff d3                	call   *%ebx
  80054d:	eb 03                	jmp    800552 <printnum+0xa2>
  80054f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800552:	83 ee 01             	sub    $0x1,%esi
  800555:	85 f6                	test   %esi,%esi
  800557:	7f e8                	jg     800541 <printnum+0x91>
  800559:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80055c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800560:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800564:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800567:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80056a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80056e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800572:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800575:	89 04 24             	mov    %eax,(%esp)
  800578:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80057b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80057f:	e8 4c 24 00 00       	call   8029d0 <__umoddi3>
  800584:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800588:	0f be 80 fb 2b 80 00 	movsbl 0x802bfb(%eax),%eax
  80058f:	89 04 24             	mov    %eax,(%esp)
  800592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800595:	ff d0                	call   *%eax
}
  800597:	83 c4 3c             	add    $0x3c,%esp
  80059a:	5b                   	pop    %ebx
  80059b:	5e                   	pop    %esi
  80059c:	5f                   	pop    %edi
  80059d:	5d                   	pop    %ebp
  80059e:	c3                   	ret    

0080059f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a2:	83 fa 01             	cmp    $0x1,%edx
  8005a5:	7e 0e                	jle    8005b5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005a7:	8b 10                	mov    (%eax),%edx
  8005a9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005ac:	89 08                	mov    %ecx,(%eax)
  8005ae:	8b 02                	mov    (%edx),%eax
  8005b0:	8b 52 04             	mov    0x4(%edx),%edx
  8005b3:	eb 22                	jmp    8005d7 <getuint+0x38>
	else if (lflag)
  8005b5:	85 d2                	test   %edx,%edx
  8005b7:	74 10                	je     8005c9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005b9:	8b 10                	mov    (%eax),%edx
  8005bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005be:	89 08                	mov    %ecx,(%eax)
  8005c0:	8b 02                	mov    (%edx),%eax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c7:	eb 0e                	jmp    8005d7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ce:	89 08                	mov    %ecx,(%eax)
  8005d0:	8b 02                	mov    (%edx),%eax
  8005d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d7:	5d                   	pop    %ebp
  8005d8:	c3                   	ret    

008005d9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005df:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	3b 50 04             	cmp    0x4(%eax),%edx
  8005e8:	73 0a                	jae    8005f4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005ed:	89 08                	mov    %ecx,(%eax)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	88 02                	mov    %al,(%edx)
}
  8005f4:	5d                   	pop    %ebp
  8005f5:	c3                   	ret    

008005f6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800603:	8b 45 10             	mov    0x10(%ebp),%eax
  800606:	89 44 24 08          	mov    %eax,0x8(%esp)
  80060a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	89 04 24             	mov    %eax,(%esp)
  800617:	e8 02 00 00 00       	call   80061e <vprintfmt>
	va_end(ap);
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	57                   	push   %edi
  800622:	56                   	push   %esi
  800623:	53                   	push   %ebx
  800624:	83 ec 3c             	sub    $0x3c,%esp
  800627:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80062a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80062d:	eb 14                	jmp    800643 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80062f:	85 c0                	test   %eax,%eax
  800631:	0f 84 b3 03 00 00    	je     8009ea <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063b:	89 04 24             	mov    %eax,(%esp)
  80063e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800641:	89 f3                	mov    %esi,%ebx
  800643:	8d 73 01             	lea    0x1(%ebx),%esi
  800646:	0f b6 03             	movzbl (%ebx),%eax
  800649:	83 f8 25             	cmp    $0x25,%eax
  80064c:	75 e1                	jne    80062f <vprintfmt+0x11>
  80064e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800652:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800659:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800660:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800667:	ba 00 00 00 00       	mov    $0x0,%edx
  80066c:	eb 1d                	jmp    80068b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800670:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800674:	eb 15                	jmp    80068b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800676:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800678:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80067c:	eb 0d                	jmp    80068b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80067e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800681:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800684:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80068e:	0f b6 0e             	movzbl (%esi),%ecx
  800691:	0f b6 c1             	movzbl %cl,%eax
  800694:	83 e9 23             	sub    $0x23,%ecx
  800697:	80 f9 55             	cmp    $0x55,%cl
  80069a:	0f 87 2a 03 00 00    	ja     8009ca <vprintfmt+0x3ac>
  8006a0:	0f b6 c9             	movzbl %cl,%ecx
  8006a3:	ff 24 8d 40 2d 80 00 	jmp    *0x802d40(,%ecx,4)
  8006aa:	89 de                	mov    %ebx,%esi
  8006ac:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006b1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006b4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8006b8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006bb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8006be:	83 fb 09             	cmp    $0x9,%ebx
  8006c1:	77 36                	ja     8006f9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006c6:	eb e9                	jmp    8006b1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8d 48 04             	lea    0x4(%eax),%ecx
  8006ce:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006d8:	eb 22                	jmp    8006fc <vprintfmt+0xde>
  8006da:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006dd:	85 c9                	test   %ecx,%ecx
  8006df:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e4:	0f 49 c1             	cmovns %ecx,%eax
  8006e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ea:	89 de                	mov    %ebx,%esi
  8006ec:	eb 9d                	jmp    80068b <vprintfmt+0x6d>
  8006ee:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8006f0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8006f7:	eb 92                	jmp    80068b <vprintfmt+0x6d>
  8006f9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8006fc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800700:	79 89                	jns    80068b <vprintfmt+0x6d>
  800702:	e9 77 ff ff ff       	jmp    80067e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800707:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80070a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80070c:	e9 7a ff ff ff       	jmp    80068b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8d 50 04             	lea    0x4(%eax),%edx
  800717:	89 55 14             	mov    %edx,0x14(%ebp)
  80071a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	89 04 24             	mov    %eax,(%esp)
  800723:	ff 55 08             	call   *0x8(%ebp)
			break;
  800726:	e9 18 ff ff ff       	jmp    800643 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8d 50 04             	lea    0x4(%eax),%edx
  800731:	89 55 14             	mov    %edx,0x14(%ebp)
  800734:	8b 00                	mov    (%eax),%eax
  800736:	99                   	cltd   
  800737:	31 d0                	xor    %edx,%eax
  800739:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80073b:	83 f8 0f             	cmp    $0xf,%eax
  80073e:	7f 0b                	jg     80074b <vprintfmt+0x12d>
  800740:	8b 14 85 a0 2e 80 00 	mov    0x802ea0(,%eax,4),%edx
  800747:	85 d2                	test   %edx,%edx
  800749:	75 20                	jne    80076b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80074b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80074f:	c7 44 24 08 13 2c 80 	movl   $0x802c13,0x8(%esp)
  800756:	00 
  800757:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	89 04 24             	mov    %eax,(%esp)
  800761:	e8 90 fe ff ff       	call   8005f6 <printfmt>
  800766:	e9 d8 fe ff ff       	jmp    800643 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80076b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80076f:	c7 44 24 08 d9 2f 80 	movl   $0x802fd9,0x8(%esp)
  800776:	00 
  800777:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	89 04 24             	mov    %eax,(%esp)
  800781:	e8 70 fe ff ff       	call   8005f6 <printfmt>
  800786:	e9 b8 fe ff ff       	jmp    800643 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80078e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800791:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 50 04             	lea    0x4(%eax),%edx
  80079a:	89 55 14             	mov    %edx,0x14(%ebp)
  80079d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80079f:	85 f6                	test   %esi,%esi
  8007a1:	b8 0c 2c 80 00       	mov    $0x802c0c,%eax
  8007a6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8007a9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8007ad:	0f 84 97 00 00 00    	je     80084a <vprintfmt+0x22c>
  8007b3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007b7:	0f 8e 9b 00 00 00    	jle    800858 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007bd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007c1:	89 34 24             	mov    %esi,(%esp)
  8007c4:	e8 cf 02 00 00       	call   800a98 <strnlen>
  8007c9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007cc:	29 c2                	sub    %eax,%edx
  8007ce:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8007d1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8007d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007d8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007db:	8b 75 08             	mov    0x8(%ebp),%esi
  8007de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007e1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e3:	eb 0f                	jmp    8007f4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8007e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ec:	89 04 24             	mov    %eax,(%esp)
  8007ef:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f1:	83 eb 01             	sub    $0x1,%ebx
  8007f4:	85 db                	test   %ebx,%ebx
  8007f6:	7f ed                	jg     8007e5 <vprintfmt+0x1c7>
  8007f8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8007fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007fe:	85 d2                	test   %edx,%edx
  800800:	b8 00 00 00 00       	mov    $0x0,%eax
  800805:	0f 49 c2             	cmovns %edx,%eax
  800808:	29 c2                	sub    %eax,%edx
  80080a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80080d:	89 d7                	mov    %edx,%edi
  80080f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800812:	eb 50                	jmp    800864 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800814:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800818:	74 1e                	je     800838 <vprintfmt+0x21a>
  80081a:	0f be d2             	movsbl %dl,%edx
  80081d:	83 ea 20             	sub    $0x20,%edx
  800820:	83 fa 5e             	cmp    $0x5e,%edx
  800823:	76 13                	jbe    800838 <vprintfmt+0x21a>
					putch('?', putdat);
  800825:	8b 45 0c             	mov    0xc(%ebp),%eax
  800828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800833:	ff 55 08             	call   *0x8(%ebp)
  800836:	eb 0d                	jmp    800845 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80083f:	89 04 24             	mov    %eax,(%esp)
  800842:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800845:	83 ef 01             	sub    $0x1,%edi
  800848:	eb 1a                	jmp    800864 <vprintfmt+0x246>
  80084a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80084d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800850:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800853:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800856:	eb 0c                	jmp    800864 <vprintfmt+0x246>
  800858:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80085b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80085e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800861:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800864:	83 c6 01             	add    $0x1,%esi
  800867:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80086b:	0f be c2             	movsbl %dl,%eax
  80086e:	85 c0                	test   %eax,%eax
  800870:	74 27                	je     800899 <vprintfmt+0x27b>
  800872:	85 db                	test   %ebx,%ebx
  800874:	78 9e                	js     800814 <vprintfmt+0x1f6>
  800876:	83 eb 01             	sub    $0x1,%ebx
  800879:	79 99                	jns    800814 <vprintfmt+0x1f6>
  80087b:	89 f8                	mov    %edi,%eax
  80087d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800880:	8b 75 08             	mov    0x8(%ebp),%esi
  800883:	89 c3                	mov    %eax,%ebx
  800885:	eb 1a                	jmp    8008a1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800887:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80088b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800892:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800894:	83 eb 01             	sub    $0x1,%ebx
  800897:	eb 08                	jmp    8008a1 <vprintfmt+0x283>
  800899:	89 fb                	mov    %edi,%ebx
  80089b:	8b 75 08             	mov    0x8(%ebp),%esi
  80089e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8008a1:	85 db                	test   %ebx,%ebx
  8008a3:	7f e2                	jg     800887 <vprintfmt+0x269>
  8008a5:	89 75 08             	mov    %esi,0x8(%ebp)
  8008a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008ab:	e9 93 fd ff ff       	jmp    800643 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008b0:	83 fa 01             	cmp    $0x1,%edx
  8008b3:	7e 16                	jle    8008cb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 50 08             	lea    0x8(%eax),%edx
  8008bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8008be:	8b 50 04             	mov    0x4(%eax),%edx
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008c9:	eb 32                	jmp    8008fd <vprintfmt+0x2df>
	else if (lflag)
  8008cb:	85 d2                	test   %edx,%edx
  8008cd:	74 18                	je     8008e7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8d 50 04             	lea    0x4(%eax),%edx
  8008d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d8:	8b 30                	mov    (%eax),%esi
  8008da:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008dd:	89 f0                	mov    %esi,%eax
  8008df:	c1 f8 1f             	sar    $0x1f,%eax
  8008e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e5:	eb 16                	jmp    8008fd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8008f0:	8b 30                	mov    (%eax),%esi
  8008f2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008f5:	89 f0                	mov    %esi,%eax
  8008f7:	c1 f8 1f             	sar    $0x1f,%eax
  8008fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800900:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800903:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090c:	0f 89 80 00 00 00    	jns    800992 <vprintfmt+0x374>
				putch('-', putdat);
  800912:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800916:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80091d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800923:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800926:	f7 d8                	neg    %eax
  800928:	83 d2 00             	adc    $0x0,%edx
  80092b:	f7 da                	neg    %edx
			}
			base = 10;
  80092d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800932:	eb 5e                	jmp    800992 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800934:	8d 45 14             	lea    0x14(%ebp),%eax
  800937:	e8 63 fc ff ff       	call   80059f <getuint>
			base = 10;
  80093c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800941:	eb 4f                	jmp    800992 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800943:	8d 45 14             	lea    0x14(%ebp),%eax
  800946:	e8 54 fc ff ff       	call   80059f <getuint>
			base =8;
  80094b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800950:	eb 40                	jmp    800992 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800952:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800956:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80095d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800960:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800964:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80096b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	8d 50 04             	lea    0x4(%eax),%edx
  800974:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800977:	8b 00                	mov    (%eax),%eax
  800979:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80097e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800983:	eb 0d                	jmp    800992 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800985:	8d 45 14             	lea    0x14(%ebp),%eax
  800988:	e8 12 fc ff ff       	call   80059f <getuint>
			base = 16;
  80098d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800992:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800996:	89 74 24 10          	mov    %esi,0x10(%esp)
  80099a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80099d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009a1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009a5:	89 04 24             	mov    %eax,(%esp)
  8009a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009ac:	89 fa                	mov    %edi,%edx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	e8 fa fa ff ff       	call   8004b0 <printnum>
			break;
  8009b6:	e9 88 fc ff ff       	jmp    800643 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009bf:	89 04 24             	mov    %eax,(%esp)
  8009c2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009c5:	e9 79 fc ff ff       	jmp    800643 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ce:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009d5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d8:	89 f3                	mov    %esi,%ebx
  8009da:	eb 03                	jmp    8009df <vprintfmt+0x3c1>
  8009dc:	83 eb 01             	sub    $0x1,%ebx
  8009df:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009e3:	75 f7                	jne    8009dc <vprintfmt+0x3be>
  8009e5:	e9 59 fc ff ff       	jmp    800643 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8009ea:	83 c4 3c             	add    $0x3c,%esp
  8009ed:	5b                   	pop    %ebx
  8009ee:	5e                   	pop    %esi
  8009ef:	5f                   	pop    %edi
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	83 ec 28             	sub    $0x28,%esp
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a01:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a05:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a0f:	85 c0                	test   %eax,%eax
  800a11:	74 30                	je     800a43 <vsnprintf+0x51>
  800a13:	85 d2                	test   %edx,%edx
  800a15:	7e 2c                	jle    800a43 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a25:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a2c:	c7 04 24 d9 05 80 00 	movl   $0x8005d9,(%esp)
  800a33:	e8 e6 fb ff ff       	call   80061e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a3b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a41:	eb 05                	jmp    800a48 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a48:	c9                   	leave  
  800a49:	c3                   	ret    

00800a4a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a50:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a57:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	89 04 24             	mov    %eax,(%esp)
  800a6b:	e8 82 ff ff ff       	call   8009f2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    
  800a72:	66 90                	xchg   %ax,%ax
  800a74:	66 90                	xchg   %ax,%ax
  800a76:	66 90                	xchg   %ax,%ax
  800a78:	66 90                	xchg   %ax,%ax
  800a7a:	66 90                	xchg   %ax,%ax
  800a7c:	66 90                	xchg   %ax,%ax
  800a7e:	66 90                	xchg   %ax,%ax

00800a80 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8b:	eb 03                	jmp    800a90 <strlen+0x10>
		n++;
  800a8d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a90:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a94:	75 f7                	jne    800a8d <strlen+0xd>
		n++;
	return n;
}
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa6:	eb 03                	jmp    800aab <strnlen+0x13>
		n++;
  800aa8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aab:	39 d0                	cmp    %edx,%eax
  800aad:	74 06                	je     800ab5 <strnlen+0x1d>
  800aaf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ab3:	75 f3                	jne    800aa8 <strnlen+0x10>
		n++;
	return n;
}
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	53                   	push   %ebx
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ac1:	89 c2                	mov    %eax,%edx
  800ac3:	83 c2 01             	add    $0x1,%edx
  800ac6:	83 c1 01             	add    $0x1,%ecx
  800ac9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800acd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ad0:	84 db                	test   %bl,%bl
  800ad2:	75 ef                	jne    800ac3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ad4:	5b                   	pop    %ebx
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	53                   	push   %ebx
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ae1:	89 1c 24             	mov    %ebx,(%esp)
  800ae4:	e8 97 ff ff ff       	call   800a80 <strlen>
	strcpy(dst + len, src);
  800ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aec:	89 54 24 04          	mov    %edx,0x4(%esp)
  800af0:	01 d8                	add    %ebx,%eax
  800af2:	89 04 24             	mov    %eax,(%esp)
  800af5:	e8 bd ff ff ff       	call   800ab7 <strcpy>
	return dst;
}
  800afa:	89 d8                	mov    %ebx,%eax
  800afc:	83 c4 08             	add    $0x8,%esp
  800aff:	5b                   	pop    %ebx
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	56                   	push   %esi
  800b06:	53                   	push   %ebx
  800b07:	8b 75 08             	mov    0x8(%ebp),%esi
  800b0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b0d:	89 f3                	mov    %esi,%ebx
  800b0f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b12:	89 f2                	mov    %esi,%edx
  800b14:	eb 0f                	jmp    800b25 <strncpy+0x23>
		*dst++ = *src;
  800b16:	83 c2 01             	add    $0x1,%edx
  800b19:	0f b6 01             	movzbl (%ecx),%eax
  800b1c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b1f:	80 39 01             	cmpb   $0x1,(%ecx)
  800b22:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b25:	39 da                	cmp    %ebx,%edx
  800b27:	75 ed                	jne    800b16 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b29:	89 f0                	mov    %esi,%eax
  800b2b:	5b                   	pop    %ebx
  800b2c:	5e                   	pop    %esi
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	8b 75 08             	mov    0x8(%ebp),%esi
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b3d:	89 f0                	mov    %esi,%eax
  800b3f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b43:	85 c9                	test   %ecx,%ecx
  800b45:	75 0b                	jne    800b52 <strlcpy+0x23>
  800b47:	eb 1d                	jmp    800b66 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b49:	83 c0 01             	add    $0x1,%eax
  800b4c:	83 c2 01             	add    $0x1,%edx
  800b4f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b52:	39 d8                	cmp    %ebx,%eax
  800b54:	74 0b                	je     800b61 <strlcpy+0x32>
  800b56:	0f b6 0a             	movzbl (%edx),%ecx
  800b59:	84 c9                	test   %cl,%cl
  800b5b:	75 ec                	jne    800b49 <strlcpy+0x1a>
  800b5d:	89 c2                	mov    %eax,%edx
  800b5f:	eb 02                	jmp    800b63 <strlcpy+0x34>
  800b61:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b63:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800b66:	29 f0                	sub    %esi,%eax
}
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b72:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b75:	eb 06                	jmp    800b7d <strcmp+0x11>
		p++, q++;
  800b77:	83 c1 01             	add    $0x1,%ecx
  800b7a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b7d:	0f b6 01             	movzbl (%ecx),%eax
  800b80:	84 c0                	test   %al,%al
  800b82:	74 04                	je     800b88 <strcmp+0x1c>
  800b84:	3a 02                	cmp    (%edx),%al
  800b86:	74 ef                	je     800b77 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b88:	0f b6 c0             	movzbl %al,%eax
  800b8b:	0f b6 12             	movzbl (%edx),%edx
  800b8e:	29 d0                	sub    %edx,%eax
}
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	53                   	push   %ebx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9c:	89 c3                	mov    %eax,%ebx
  800b9e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ba1:	eb 06                	jmp    800ba9 <strncmp+0x17>
		n--, p++, q++;
  800ba3:	83 c0 01             	add    $0x1,%eax
  800ba6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ba9:	39 d8                	cmp    %ebx,%eax
  800bab:	74 15                	je     800bc2 <strncmp+0x30>
  800bad:	0f b6 08             	movzbl (%eax),%ecx
  800bb0:	84 c9                	test   %cl,%cl
  800bb2:	74 04                	je     800bb8 <strncmp+0x26>
  800bb4:	3a 0a                	cmp    (%edx),%cl
  800bb6:	74 eb                	je     800ba3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb8:	0f b6 00             	movzbl (%eax),%eax
  800bbb:	0f b6 12             	movzbl (%edx),%edx
  800bbe:	29 d0                	sub    %edx,%eax
  800bc0:	eb 05                	jmp    800bc7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd4:	eb 07                	jmp    800bdd <strchr+0x13>
		if (*s == c)
  800bd6:	38 ca                	cmp    %cl,%dl
  800bd8:	74 0f                	je     800be9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bda:	83 c0 01             	add    $0x1,%eax
  800bdd:	0f b6 10             	movzbl (%eax),%edx
  800be0:	84 d2                	test   %dl,%dl
  800be2:	75 f2                	jne    800bd6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bf5:	eb 07                	jmp    800bfe <strfind+0x13>
		if (*s == c)
  800bf7:	38 ca                	cmp    %cl,%dl
  800bf9:	74 0a                	je     800c05 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bfb:	83 c0 01             	add    $0x1,%eax
  800bfe:	0f b6 10             	movzbl (%eax),%edx
  800c01:	84 d2                	test   %dl,%dl
  800c03:	75 f2                	jne    800bf7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c13:	85 c9                	test   %ecx,%ecx
  800c15:	74 36                	je     800c4d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c17:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c1d:	75 28                	jne    800c47 <memset+0x40>
  800c1f:	f6 c1 03             	test   $0x3,%cl
  800c22:	75 23                	jne    800c47 <memset+0x40>
		c &= 0xFF;
  800c24:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	c1 e3 08             	shl    $0x8,%ebx
  800c2d:	89 d6                	mov    %edx,%esi
  800c2f:	c1 e6 18             	shl    $0x18,%esi
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	c1 e0 10             	shl    $0x10,%eax
  800c37:	09 f0                	or     %esi,%eax
  800c39:	09 c2                	or     %eax,%edx
  800c3b:	89 d0                	mov    %edx,%eax
  800c3d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c3f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c42:	fc                   	cld    
  800c43:	f3 ab                	rep stos %eax,%es:(%edi)
  800c45:	eb 06                	jmp    800c4d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4a:	fc                   	cld    
  800c4b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c4d:	89 f8                	mov    %edi,%eax
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c62:	39 c6                	cmp    %eax,%esi
  800c64:	73 35                	jae    800c9b <memmove+0x47>
  800c66:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c69:	39 d0                	cmp    %edx,%eax
  800c6b:	73 2e                	jae    800c9b <memmove+0x47>
		s += n;
		d += n;
  800c6d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c70:	89 d6                	mov    %edx,%esi
  800c72:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c74:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c7a:	75 13                	jne    800c8f <memmove+0x3b>
  800c7c:	f6 c1 03             	test   $0x3,%cl
  800c7f:	75 0e                	jne    800c8f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c81:	83 ef 04             	sub    $0x4,%edi
  800c84:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c87:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c8a:	fd                   	std    
  800c8b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c8d:	eb 09                	jmp    800c98 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c8f:	83 ef 01             	sub    $0x1,%edi
  800c92:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c95:	fd                   	std    
  800c96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c98:	fc                   	cld    
  800c99:	eb 1d                	jmp    800cb8 <memmove+0x64>
  800c9b:	89 f2                	mov    %esi,%edx
  800c9d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c9f:	f6 c2 03             	test   $0x3,%dl
  800ca2:	75 0f                	jne    800cb3 <memmove+0x5f>
  800ca4:	f6 c1 03             	test   $0x3,%cl
  800ca7:	75 0a                	jne    800cb3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ca9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800cac:	89 c7                	mov    %eax,%edi
  800cae:	fc                   	cld    
  800caf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cb1:	eb 05                	jmp    800cb8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cb3:	89 c7                	mov    %eax,%edi
  800cb5:	fc                   	cld    
  800cb6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 04 24             	mov    %eax,(%esp)
  800cd6:	e8 79 ff ff ff       	call   800c54 <memmove>
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	89 d6                	mov    %edx,%esi
  800cea:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ced:	eb 1a                	jmp    800d09 <memcmp+0x2c>
		if (*s1 != *s2)
  800cef:	0f b6 02             	movzbl (%edx),%eax
  800cf2:	0f b6 19             	movzbl (%ecx),%ebx
  800cf5:	38 d8                	cmp    %bl,%al
  800cf7:	74 0a                	je     800d03 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800cf9:	0f b6 c0             	movzbl %al,%eax
  800cfc:	0f b6 db             	movzbl %bl,%ebx
  800cff:	29 d8                	sub    %ebx,%eax
  800d01:	eb 0f                	jmp    800d12 <memcmp+0x35>
		s1++, s2++;
  800d03:	83 c2 01             	add    $0x1,%edx
  800d06:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d09:	39 f2                	cmp    %esi,%edx
  800d0b:	75 e2                	jne    800cef <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d1f:	89 c2                	mov    %eax,%edx
  800d21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d24:	eb 07                	jmp    800d2d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d26:	38 08                	cmp    %cl,(%eax)
  800d28:	74 07                	je     800d31 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d2a:	83 c0 01             	add    $0x1,%eax
  800d2d:	39 d0                	cmp    %edx,%eax
  800d2f:	72 f5                	jb     800d26 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3f:	eb 03                	jmp    800d44 <strtol+0x11>
		s++;
  800d41:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d44:	0f b6 0a             	movzbl (%edx),%ecx
  800d47:	80 f9 09             	cmp    $0x9,%cl
  800d4a:	74 f5                	je     800d41 <strtol+0xe>
  800d4c:	80 f9 20             	cmp    $0x20,%cl
  800d4f:	74 f0                	je     800d41 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d51:	80 f9 2b             	cmp    $0x2b,%cl
  800d54:	75 0a                	jne    800d60 <strtol+0x2d>
		s++;
  800d56:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d59:	bf 00 00 00 00       	mov    $0x0,%edi
  800d5e:	eb 11                	jmp    800d71 <strtol+0x3e>
  800d60:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d65:	80 f9 2d             	cmp    $0x2d,%cl
  800d68:	75 07                	jne    800d71 <strtol+0x3e>
		s++, neg = 1;
  800d6a:	8d 52 01             	lea    0x1(%edx),%edx
  800d6d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d71:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d76:	75 15                	jne    800d8d <strtol+0x5a>
  800d78:	80 3a 30             	cmpb   $0x30,(%edx)
  800d7b:	75 10                	jne    800d8d <strtol+0x5a>
  800d7d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d81:	75 0a                	jne    800d8d <strtol+0x5a>
		s += 2, base = 16;
  800d83:	83 c2 02             	add    $0x2,%edx
  800d86:	b8 10 00 00 00       	mov    $0x10,%eax
  800d8b:	eb 10                	jmp    800d9d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	75 0c                	jne    800d9d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d91:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d93:	80 3a 30             	cmpb   $0x30,(%edx)
  800d96:	75 05                	jne    800d9d <strtol+0x6a>
		s++, base = 8;
  800d98:	83 c2 01             	add    $0x1,%edx
  800d9b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800da5:	0f b6 0a             	movzbl (%edx),%ecx
  800da8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800dab:	89 f0                	mov    %esi,%eax
  800dad:	3c 09                	cmp    $0x9,%al
  800daf:	77 08                	ja     800db9 <strtol+0x86>
			dig = *s - '0';
  800db1:	0f be c9             	movsbl %cl,%ecx
  800db4:	83 e9 30             	sub    $0x30,%ecx
  800db7:	eb 20                	jmp    800dd9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800db9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800dbc:	89 f0                	mov    %esi,%eax
  800dbe:	3c 19                	cmp    $0x19,%al
  800dc0:	77 08                	ja     800dca <strtol+0x97>
			dig = *s - 'a' + 10;
  800dc2:	0f be c9             	movsbl %cl,%ecx
  800dc5:	83 e9 57             	sub    $0x57,%ecx
  800dc8:	eb 0f                	jmp    800dd9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800dca:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800dcd:	89 f0                	mov    %esi,%eax
  800dcf:	3c 19                	cmp    $0x19,%al
  800dd1:	77 16                	ja     800de9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800dd3:	0f be c9             	movsbl %cl,%ecx
  800dd6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800dd9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ddc:	7d 0f                	jge    800ded <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800dde:	83 c2 01             	add    $0x1,%edx
  800de1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800de5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800de7:	eb bc                	jmp    800da5 <strtol+0x72>
  800de9:	89 d8                	mov    %ebx,%eax
  800deb:	eb 02                	jmp    800def <strtol+0xbc>
  800ded:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800def:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df3:	74 05                	je     800dfa <strtol+0xc7>
		*endptr = (char *) s;
  800df5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800df8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800dfa:	f7 d8                	neg    %eax
  800dfc:	85 ff                	test   %edi,%edi
  800dfe:	0f 44 c3             	cmove  %ebx,%eax
}
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	89 c3                	mov    %eax,%ebx
  800e19:	89 c7                	mov    %eax,%edi
  800e1b:	89 c6                	mov    %eax,%esi
  800e1d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	57                   	push   %edi
  800e28:	56                   	push   %esi
  800e29:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e34:	89 d1                	mov    %edx,%ecx
  800e36:	89 d3                	mov    %edx,%ebx
  800e38:	89 d7                	mov    %edx,%edi
  800e3a:	89 d6                	mov    %edx,%esi
  800e3c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e3e:	5b                   	pop    %ebx
  800e3f:	5e                   	pop    %esi
  800e40:	5f                   	pop    %edi
  800e41:	5d                   	pop    %ebp
  800e42:	c3                   	ret    

00800e43 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	57                   	push   %edi
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
  800e49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e51:	b8 03 00 00 00       	mov    $0x3,%eax
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	89 cb                	mov    %ecx,%ebx
  800e5b:	89 cf                	mov    %ecx,%edi
  800e5d:	89 ce                	mov    %ecx,%esi
  800e5f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e61:	85 c0                	test   %eax,%eax
  800e63:	7e 28                	jle    800e8d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e65:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e69:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e70:	00 
  800e71:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800e78:	00 
  800e79:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e80:	00 
  800e81:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800e88:	e8 09 f5 ff ff       	call   800396 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e8d:	83 c4 2c             	add    $0x2c,%esp
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	57                   	push   %edi
  800e99:	56                   	push   %esi
  800e9a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ea5:	89 d1                	mov    %edx,%ecx
  800ea7:	89 d3                	mov    %edx,%ebx
  800ea9:	89 d7                	mov    %edx,%edi
  800eab:	89 d6                	mov    %edx,%esi
  800ead:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <sys_yield>:

void
sys_yield(void)
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
  800ebf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ec4:	89 d1                	mov    %edx,%ecx
  800ec6:	89 d3                	mov    %edx,%ebx
  800ec8:	89 d7                	mov    %edx,%edi
  800eca:	89 d6                	mov    %edx,%esi
  800ecc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800edc:	be 00 00 00 00       	mov    $0x0,%esi
  800ee1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eef:	89 f7                	mov    %esi,%edi
  800ef1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	7e 28                	jle    800f1f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f02:	00 
  800f03:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800f0a:	00 
  800f0b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f12:	00 
  800f13:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800f1a:	e8 77 f4 ff ff       	call   800396 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f1f:	83 c4 2c             	add    $0x2c,%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5f                   	pop    %edi
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	57                   	push   %edi
  800f2b:	56                   	push   %esi
  800f2c:	53                   	push   %ebx
  800f2d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f30:	b8 05 00 00 00       	mov    $0x5,%eax
  800f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f38:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f41:	8b 75 18             	mov    0x18(%ebp),%esi
  800f44:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f46:	85 c0                	test   %eax,%eax
  800f48:	7e 28                	jle    800f72 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f4e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f55:	00 
  800f56:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800f5d:	00 
  800f5e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f65:	00 
  800f66:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800f6d:	e8 24 f4 ff ff       	call   800396 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f72:	83 c4 2c             	add    $0x2c,%esp
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    

00800f7a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	57                   	push   %edi
  800f7e:	56                   	push   %esi
  800f7f:	53                   	push   %ebx
  800f80:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f88:	b8 06 00 00 00       	mov    $0x6,%eax
  800f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f90:	8b 55 08             	mov    0x8(%ebp),%edx
  800f93:	89 df                	mov    %ebx,%edi
  800f95:	89 de                	mov    %ebx,%esi
  800f97:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	7e 28                	jle    800fc5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fa8:	00 
  800fa9:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800fb0:	00 
  800fb1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb8:	00 
  800fb9:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800fc0:	e8 d1 f3 ff ff       	call   800396 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fc5:	83 c4 2c             	add    $0x2c,%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	57                   	push   %edi
  800fd1:	56                   	push   %esi
  800fd2:	53                   	push   %ebx
  800fd3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	b8 08 00 00 00       	mov    $0x8,%eax
  800fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe6:	89 df                	mov    %ebx,%edi
  800fe8:	89 de                	mov    %ebx,%esi
  800fea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	7e 28                	jle    801018 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  801003:	00 
  801004:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80100b:	00 
  80100c:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  801013:	e8 7e f3 ff ff       	call   800396 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801018:	83 c4 2c             	add    $0x2c,%esp
  80101b:	5b                   	pop    %ebx
  80101c:	5e                   	pop    %esi
  80101d:	5f                   	pop    %edi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
  801026:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801029:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102e:	b8 09 00 00 00       	mov    $0x9,%eax
  801033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	89 df                	mov    %ebx,%edi
  80103b:	89 de                	mov    %ebx,%esi
  80103d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80103f:	85 c0                	test   %eax,%eax
  801041:	7e 28                	jle    80106b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801043:	89 44 24 10          	mov    %eax,0x10(%esp)
  801047:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80104e:	00 
  80104f:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  801056:	00 
  801057:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80105e:	00 
  80105f:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  801066:	e8 2b f3 ff ff       	call   800396 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80106b:	83 c4 2c             	add    $0x2c,%esp
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	57                   	push   %edi
  801077:	56                   	push   %esi
  801078:	53                   	push   %ebx
  801079:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801081:	b8 0a 00 00 00       	mov    $0xa,%eax
  801086:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801089:	8b 55 08             	mov    0x8(%ebp),%edx
  80108c:	89 df                	mov    %ebx,%edi
  80108e:	89 de                	mov    %ebx,%esi
  801090:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801092:	85 c0                	test   %eax,%eax
  801094:	7e 28                	jle    8010be <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801096:	89 44 24 10          	mov    %eax,0x10(%esp)
  80109a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010a1:	00 
  8010a2:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  8010a9:	00 
  8010aa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b1:	00 
  8010b2:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  8010b9:	e8 d8 f2 ff ff       	call   800396 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010be:	83 c4 2c             	add    $0x2c,%esp
  8010c1:	5b                   	pop    %ebx
  8010c2:	5e                   	pop    %esi
  8010c3:	5f                   	pop    %edi
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	57                   	push   %edi
  8010ca:	56                   	push   %esi
  8010cb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010cc:	be 00 00 00 00       	mov    $0x0,%esi
  8010d1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010df:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010e4:	5b                   	pop    %ebx
  8010e5:	5e                   	pop    %esi
  8010e6:	5f                   	pop    %edi
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    

008010e9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	57                   	push   %edi
  8010ed:	56                   	push   %esi
  8010ee:	53                   	push   %ebx
  8010ef:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ff:	89 cb                	mov    %ecx,%ebx
  801101:	89 cf                	mov    %ecx,%edi
  801103:	89 ce                	mov    %ecx,%esi
  801105:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801107:	85 c0                	test   %eax,%eax
  801109:	7e 28                	jle    801133 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80110b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801116:	00 
  801117:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  80111e:	00 
  80111f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801126:	00 
  801127:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  80112e:	e8 63 f2 ff ff       	call   800396 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801133:	83 c4 2c             	add    $0x2c,%esp
  801136:	5b                   	pop    %ebx
  801137:	5e                   	pop    %esi
  801138:	5f                   	pop    %edi
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    

0080113b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	57                   	push   %edi
  80113f:	56                   	push   %esi
  801140:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801141:	ba 00 00 00 00       	mov    $0x0,%edx
  801146:	b8 0e 00 00 00       	mov    $0xe,%eax
  80114b:	89 d1                	mov    %edx,%ecx
  80114d:	89 d3                	mov    %edx,%ebx
  80114f:	89 d7                	mov    %edx,%edi
  801151:	89 d6                	mov    %edx,%esi
  801153:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5f                   	pop    %edi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    

0080115a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	57                   	push   %edi
  80115e:	56                   	push   %esi
  80115f:	53                   	push   %ebx
  801160:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801163:	bb 00 00 00 00       	mov    $0x0,%ebx
  801168:	b8 0f 00 00 00       	mov    $0xf,%eax
  80116d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801170:	8b 55 08             	mov    0x8(%ebp),%edx
  801173:	89 df                	mov    %ebx,%edi
  801175:	89 de                	mov    %ebx,%esi
  801177:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801179:	85 c0                	test   %eax,%eax
  80117b:	7e 28                	jle    8011a5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80117d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801181:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801188:	00 
  801189:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  801190:	00 
  801191:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801198:	00 
  801199:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  8011a0:	e8 f1 f1 ff ff       	call   800396 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  8011a5:	83 c4 2c             	add    $0x2c,%esp
  8011a8:	5b                   	pop    %ebx
  8011a9:	5e                   	pop    %esi
  8011aa:	5f                   	pop    %edi
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    

008011ad <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	57                   	push   %edi
  8011b1:	56                   	push   %esi
  8011b2:	53                   	push   %ebx
  8011b3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bb:	b8 10 00 00 00       	mov    $0x10,%eax
  8011c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c6:	89 df                	mov    %ebx,%edi
  8011c8:	89 de                	mov    %ebx,%esi
  8011ca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	7e 28                	jle    8011f8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8011db:	00 
  8011dc:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011eb:	00 
  8011ec:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  8011f3:	e8 9e f1 ff ff       	call   800396 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  8011f8:	83 c4 2c             	add    $0x2c,%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5f                   	pop    %edi
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	53                   	push   %ebx
  801204:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801207:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  80120d:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  80120f:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801212:	bb 00 00 00 00       	mov    $0x0,%ebx
  801217:	83 39 01             	cmpl   $0x1,(%ecx)
  80121a:	7e 0f                	jle    80122b <argstart+0x2b>
  80121c:	85 d2                	test   %edx,%edx
  80121e:	ba 00 00 00 00       	mov    $0x0,%edx
  801223:	bb a8 2b 80 00       	mov    $0x802ba8,%ebx
  801228:	0f 44 da             	cmove  %edx,%ebx
  80122b:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  80122e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801235:	5b                   	pop    %ebx
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    

00801238 <argnext>:

int
argnext(struct Argstate *args)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	53                   	push   %ebx
  80123c:	83 ec 14             	sub    $0x14,%esp
  80123f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801242:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801249:	8b 43 08             	mov    0x8(%ebx),%eax
  80124c:	85 c0                	test   %eax,%eax
  80124e:	74 71                	je     8012c1 <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801250:	80 38 00             	cmpb   $0x0,(%eax)
  801253:	75 50                	jne    8012a5 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801255:	8b 0b                	mov    (%ebx),%ecx
  801257:	83 39 01             	cmpl   $0x1,(%ecx)
  80125a:	74 57                	je     8012b3 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  80125c:	8b 53 04             	mov    0x4(%ebx),%edx
  80125f:	8b 42 04             	mov    0x4(%edx),%eax
  801262:	80 38 2d             	cmpb   $0x2d,(%eax)
  801265:	75 4c                	jne    8012b3 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801267:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80126b:	74 46                	je     8012b3 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80126d:	83 c0 01             	add    $0x1,%eax
  801270:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801273:	8b 01                	mov    (%ecx),%eax
  801275:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  80127c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801280:	8d 42 08             	lea    0x8(%edx),%eax
  801283:	89 44 24 04          	mov    %eax,0x4(%esp)
  801287:	83 c2 04             	add    $0x4,%edx
  80128a:	89 14 24             	mov    %edx,(%esp)
  80128d:	e8 c2 f9 ff ff       	call   800c54 <memmove>
		(*args->argc)--;
  801292:	8b 03                	mov    (%ebx),%eax
  801294:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801297:	8b 43 08             	mov    0x8(%ebx),%eax
  80129a:	80 38 2d             	cmpb   $0x2d,(%eax)
  80129d:	75 06                	jne    8012a5 <argnext+0x6d>
  80129f:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8012a3:	74 0e                	je     8012b3 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8012a5:	8b 53 08             	mov    0x8(%ebx),%edx
  8012a8:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8012ab:	83 c2 01             	add    $0x1,%edx
  8012ae:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  8012b1:	eb 13                	jmp    8012c6 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  8012b3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8012ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8012bf:	eb 05                	jmp    8012c6 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  8012c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8012c6:	83 c4 14             	add    $0x14,%esp
  8012c9:	5b                   	pop    %ebx
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    

008012cc <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	53                   	push   %ebx
  8012d0:	83 ec 14             	sub    $0x14,%esp
  8012d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8012d6:	8b 43 08             	mov    0x8(%ebx),%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 5a                	je     801337 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  8012dd:	80 38 00             	cmpb   $0x0,(%eax)
  8012e0:	74 0c                	je     8012ee <argnextvalue+0x22>
		args->argvalue = args->curarg;
  8012e2:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8012e5:	c7 43 08 a8 2b 80 00 	movl   $0x802ba8,0x8(%ebx)
  8012ec:	eb 44                	jmp    801332 <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  8012ee:	8b 03                	mov    (%ebx),%eax
  8012f0:	83 38 01             	cmpl   $0x1,(%eax)
  8012f3:	7e 2f                	jle    801324 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  8012f5:	8b 53 04             	mov    0x4(%ebx),%edx
  8012f8:	8b 4a 04             	mov    0x4(%edx),%ecx
  8012fb:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8012fe:	8b 00                	mov    (%eax),%eax
  801300:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801307:	89 44 24 08          	mov    %eax,0x8(%esp)
  80130b:	8d 42 08             	lea    0x8(%edx),%eax
  80130e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801312:	83 c2 04             	add    $0x4,%edx
  801315:	89 14 24             	mov    %edx,(%esp)
  801318:	e8 37 f9 ff ff       	call   800c54 <memmove>
		(*args->argc)--;
  80131d:	8b 03                	mov    (%ebx),%eax
  80131f:	83 28 01             	subl   $0x1,(%eax)
  801322:	eb 0e                	jmp    801332 <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  801324:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80132b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801332:	8b 43 0c             	mov    0xc(%ebx),%eax
  801335:	eb 05                	jmp    80133c <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801337:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  80133c:	83 c4 14             	add    $0x14,%esp
  80133f:	5b                   	pop    %ebx
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 18             	sub    $0x18,%esp
  801348:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80134b:	8b 51 0c             	mov    0xc(%ecx),%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	85 d2                	test   %edx,%edx
  801352:	75 08                	jne    80135c <argvalue+0x1a>
  801354:	89 0c 24             	mov    %ecx,(%esp)
  801357:	e8 70 ff ff ff       	call   8012cc <argnextvalue>
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    
  80135e:	66 90                	xchg   %ax,%ax

00801360 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	05 00 00 00 30       	add    $0x30000000,%eax
  80136b:	c1 e8 0c             	shr    $0xc,%eax
}
  80136e:	5d                   	pop    %ebp
  80136f:	c3                   	ret    

00801370 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80137b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801380:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801385:	5d                   	pop    %ebp
  801386:	c3                   	ret    

00801387 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80138d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801392:	89 c2                	mov    %eax,%edx
  801394:	c1 ea 16             	shr    $0x16,%edx
  801397:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80139e:	f6 c2 01             	test   $0x1,%dl
  8013a1:	74 11                	je     8013b4 <fd_alloc+0x2d>
  8013a3:	89 c2                	mov    %eax,%edx
  8013a5:	c1 ea 0c             	shr    $0xc,%edx
  8013a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013af:	f6 c2 01             	test   $0x1,%dl
  8013b2:	75 09                	jne    8013bd <fd_alloc+0x36>
			*fd_store = fd;
  8013b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bb:	eb 17                	jmp    8013d4 <fd_alloc+0x4d>
  8013bd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013c7:	75 c9                	jne    801392 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013c9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013d4:	5d                   	pop    %ebp
  8013d5:	c3                   	ret    

008013d6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013dc:	83 f8 1f             	cmp    $0x1f,%eax
  8013df:	77 36                	ja     801417 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013e1:	c1 e0 0c             	shl    $0xc,%eax
  8013e4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013e9:	89 c2                	mov    %eax,%edx
  8013eb:	c1 ea 16             	shr    $0x16,%edx
  8013ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013f5:	f6 c2 01             	test   $0x1,%dl
  8013f8:	74 24                	je     80141e <fd_lookup+0x48>
  8013fa:	89 c2                	mov    %eax,%edx
  8013fc:	c1 ea 0c             	shr    $0xc,%edx
  8013ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801406:	f6 c2 01             	test   $0x1,%dl
  801409:	74 1a                	je     801425 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80140b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140e:	89 02                	mov    %eax,(%edx)
	return 0;
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	eb 13                	jmp    80142a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801417:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80141c:	eb 0c                	jmp    80142a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80141e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801423:	eb 05                	jmp    80142a <fd_lookup+0x54>
  801425:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 18             	sub    $0x18,%esp
  801432:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801435:	ba 00 00 00 00       	mov    $0x0,%edx
  80143a:	eb 13                	jmp    80144f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80143c:	39 08                	cmp    %ecx,(%eax)
  80143e:	75 0c                	jne    80144c <dev_lookup+0x20>
			*dev = devtab[i];
  801440:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801443:	89 01                	mov    %eax,(%ecx)
			return 0;
  801445:	b8 00 00 00 00       	mov    $0x0,%eax
  80144a:	eb 38                	jmp    801484 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80144c:	83 c2 01             	add    $0x1,%edx
  80144f:	8b 04 95 ac 2f 80 00 	mov    0x802fac(,%edx,4),%eax
  801456:	85 c0                	test   %eax,%eax
  801458:	75 e2                	jne    80143c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80145a:	a1 20 54 80 00       	mov    0x805420,%eax
  80145f:	8b 40 48             	mov    0x48(%eax),%eax
  801462:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801466:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146a:	c7 04 24 2c 2f 80 00 	movl   $0x802f2c,(%esp)
  801471:	e8 19 f0 ff ff       	call   80048f <cprintf>
	*dev = 0;
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80147f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	56                   	push   %esi
  80148a:	53                   	push   %ebx
  80148b:	83 ec 20             	sub    $0x20,%esp
  80148e:	8b 75 08             	mov    0x8(%ebp),%esi
  801491:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801494:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801497:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80149b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014a1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014a4:	89 04 24             	mov    %eax,(%esp)
  8014a7:	e8 2a ff ff ff       	call   8013d6 <fd_lookup>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	78 05                	js     8014b5 <fd_close+0x2f>
	    || fd != fd2)
  8014b0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014b3:	74 0c                	je     8014c1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8014b5:	84 db                	test   %bl,%bl
  8014b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014bc:	0f 44 c2             	cmove  %edx,%eax
  8014bf:	eb 3f                	jmp    801500 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c8:	8b 06                	mov    (%esi),%eax
  8014ca:	89 04 24             	mov    %eax,(%esp)
  8014cd:	e8 5a ff ff ff       	call   80142c <dev_lookup>
  8014d2:	89 c3                	mov    %eax,%ebx
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 16                	js     8014ee <fd_close+0x68>
		if (dev->dev_close)
  8014d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	74 07                	je     8014ee <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8014e7:	89 34 24             	mov    %esi,(%esp)
  8014ea:	ff d0                	call   *%eax
  8014ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014f9:	e8 7c fa ff ff       	call   800f7a <sys_page_unmap>
	return r;
  8014fe:	89 d8                	mov    %ebx,%eax
}
  801500:	83 c4 20             	add    $0x20,%esp
  801503:	5b                   	pop    %ebx
  801504:	5e                   	pop    %esi
  801505:	5d                   	pop    %ebp
  801506:	c3                   	ret    

00801507 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80150d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801510:	89 44 24 04          	mov    %eax,0x4(%esp)
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	89 04 24             	mov    %eax,(%esp)
  80151a:	e8 b7 fe ff ff       	call   8013d6 <fd_lookup>
  80151f:	89 c2                	mov    %eax,%edx
  801521:	85 d2                	test   %edx,%edx
  801523:	78 13                	js     801538 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801525:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80152c:	00 
  80152d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801530:	89 04 24             	mov    %eax,(%esp)
  801533:	e8 4e ff ff ff       	call   801486 <fd_close>
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <close_all>:

void
close_all(void)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	53                   	push   %ebx
  80153e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801541:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801546:	89 1c 24             	mov    %ebx,(%esp)
  801549:	e8 b9 ff ff ff       	call   801507 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80154e:	83 c3 01             	add    $0x1,%ebx
  801551:	83 fb 20             	cmp    $0x20,%ebx
  801554:	75 f0                	jne    801546 <close_all+0xc>
		close(i);
}
  801556:	83 c4 14             	add    $0x14,%esp
  801559:	5b                   	pop    %ebx
  80155a:	5d                   	pop    %ebp
  80155b:	c3                   	ret    

0080155c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	57                   	push   %edi
  801560:	56                   	push   %esi
  801561:	53                   	push   %ebx
  801562:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801565:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801568:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	89 04 24             	mov    %eax,(%esp)
  801572:	e8 5f fe ff ff       	call   8013d6 <fd_lookup>
  801577:	89 c2                	mov    %eax,%edx
  801579:	85 d2                	test   %edx,%edx
  80157b:	0f 88 e1 00 00 00    	js     801662 <dup+0x106>
		return r;
	close(newfdnum);
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	89 04 24             	mov    %eax,(%esp)
  801587:	e8 7b ff ff ff       	call   801507 <close>

	newfd = INDEX2FD(newfdnum);
  80158c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80158f:	c1 e3 0c             	shl    $0xc,%ebx
  801592:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80159b:	89 04 24             	mov    %eax,(%esp)
  80159e:	e8 cd fd ff ff       	call   801370 <fd2data>
  8015a3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8015a5:	89 1c 24             	mov    %ebx,(%esp)
  8015a8:	e8 c3 fd ff ff       	call   801370 <fd2data>
  8015ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015af:	89 f0                	mov    %esi,%eax
  8015b1:	c1 e8 16             	shr    $0x16,%eax
  8015b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015bb:	a8 01                	test   $0x1,%al
  8015bd:	74 43                	je     801602 <dup+0xa6>
  8015bf:	89 f0                	mov    %esi,%eax
  8015c1:	c1 e8 0c             	shr    $0xc,%eax
  8015c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015cb:	f6 c2 01             	test   $0x1,%dl
  8015ce:	74 32                	je     801602 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8015dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015e0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015eb:	00 
  8015ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015f7:	e8 2b f9 ff ff       	call   800f27 <sys_page_map>
  8015fc:	89 c6                	mov    %eax,%esi
  8015fe:	85 c0                	test   %eax,%eax
  801600:	78 3e                	js     801640 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801605:	89 c2                	mov    %eax,%edx
  801607:	c1 ea 0c             	shr    $0xc,%edx
  80160a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801611:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801617:	89 54 24 10          	mov    %edx,0x10(%esp)
  80161b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80161f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801626:	00 
  801627:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801632:	e8 f0 f8 ff ff       	call   800f27 <sys_page_map>
  801637:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80163c:	85 f6                	test   %esi,%esi
  80163e:	79 22                	jns    801662 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801640:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801644:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80164b:	e8 2a f9 ff ff       	call   800f7a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801650:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801654:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80165b:	e8 1a f9 ff ff       	call   800f7a <sys_page_unmap>
	return r;
  801660:	89 f0                	mov    %esi,%eax
}
  801662:	83 c4 3c             	add    $0x3c,%esp
  801665:	5b                   	pop    %ebx
  801666:	5e                   	pop    %esi
  801667:	5f                   	pop    %edi
  801668:	5d                   	pop    %ebp
  801669:	c3                   	ret    

0080166a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	53                   	push   %ebx
  80166e:	83 ec 24             	sub    $0x24,%esp
  801671:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801674:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801677:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167b:	89 1c 24             	mov    %ebx,(%esp)
  80167e:	e8 53 fd ff ff       	call   8013d6 <fd_lookup>
  801683:	89 c2                	mov    %eax,%edx
  801685:	85 d2                	test   %edx,%edx
  801687:	78 6d                	js     8016f6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801689:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801693:	8b 00                	mov    (%eax),%eax
  801695:	89 04 24             	mov    %eax,(%esp)
  801698:	e8 8f fd ff ff       	call   80142c <dev_lookup>
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 55                	js     8016f6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a4:	8b 50 08             	mov    0x8(%eax),%edx
  8016a7:	83 e2 03             	and    $0x3,%edx
  8016aa:	83 fa 01             	cmp    $0x1,%edx
  8016ad:	75 23                	jne    8016d2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016af:	a1 20 54 80 00       	mov    0x805420,%eax
  8016b4:	8b 40 48             	mov    0x48(%eax),%eax
  8016b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016bf:	c7 04 24 70 2f 80 00 	movl   $0x802f70,(%esp)
  8016c6:	e8 c4 ed ff ff       	call   80048f <cprintf>
		return -E_INVAL;
  8016cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d0:	eb 24                	jmp    8016f6 <read+0x8c>
	}
	if (!dev->dev_read)
  8016d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d5:	8b 52 08             	mov    0x8(%edx),%edx
  8016d8:	85 d2                	test   %edx,%edx
  8016da:	74 15                	je     8016f1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016ea:	89 04 24             	mov    %eax,(%esp)
  8016ed:	ff d2                	call   *%edx
  8016ef:	eb 05                	jmp    8016f6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8016f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8016f6:	83 c4 24             	add    $0x24,%esp
  8016f9:	5b                   	pop    %ebx
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    

008016fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	57                   	push   %edi
  801700:	56                   	push   %esi
  801701:	53                   	push   %ebx
  801702:	83 ec 1c             	sub    $0x1c,%esp
  801705:	8b 7d 08             	mov    0x8(%ebp),%edi
  801708:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80170b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801710:	eb 23                	jmp    801735 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801712:	89 f0                	mov    %esi,%eax
  801714:	29 d8                	sub    %ebx,%eax
  801716:	89 44 24 08          	mov    %eax,0x8(%esp)
  80171a:	89 d8                	mov    %ebx,%eax
  80171c:	03 45 0c             	add    0xc(%ebp),%eax
  80171f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801723:	89 3c 24             	mov    %edi,(%esp)
  801726:	e8 3f ff ff ff       	call   80166a <read>
		if (m < 0)
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 10                	js     80173f <readn+0x43>
			return m;
		if (m == 0)
  80172f:	85 c0                	test   %eax,%eax
  801731:	74 0a                	je     80173d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801733:	01 c3                	add    %eax,%ebx
  801735:	39 f3                	cmp    %esi,%ebx
  801737:	72 d9                	jb     801712 <readn+0x16>
  801739:	89 d8                	mov    %ebx,%eax
  80173b:	eb 02                	jmp    80173f <readn+0x43>
  80173d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80173f:	83 c4 1c             	add    $0x1c,%esp
  801742:	5b                   	pop    %ebx
  801743:	5e                   	pop    %esi
  801744:	5f                   	pop    %edi
  801745:	5d                   	pop    %ebp
  801746:	c3                   	ret    

00801747 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	53                   	push   %ebx
  80174b:	83 ec 24             	sub    $0x24,%esp
  80174e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801751:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801754:	89 44 24 04          	mov    %eax,0x4(%esp)
  801758:	89 1c 24             	mov    %ebx,(%esp)
  80175b:	e8 76 fc ff ff       	call   8013d6 <fd_lookup>
  801760:	89 c2                	mov    %eax,%edx
  801762:	85 d2                	test   %edx,%edx
  801764:	78 68                	js     8017ce <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801766:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801769:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801770:	8b 00                	mov    (%eax),%eax
  801772:	89 04 24             	mov    %eax,(%esp)
  801775:	e8 b2 fc ff ff       	call   80142c <dev_lookup>
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 50                	js     8017ce <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80177e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801781:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801785:	75 23                	jne    8017aa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801787:	a1 20 54 80 00       	mov    0x805420,%eax
  80178c:	8b 40 48             	mov    0x48(%eax),%eax
  80178f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801793:	89 44 24 04          	mov    %eax,0x4(%esp)
  801797:	c7 04 24 8c 2f 80 00 	movl   $0x802f8c,(%esp)
  80179e:	e8 ec ec ff ff       	call   80048f <cprintf>
		return -E_INVAL;
  8017a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a8:	eb 24                	jmp    8017ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8017b0:	85 d2                	test   %edx,%edx
  8017b2:	74 15                	je     8017c9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017c2:	89 04 24             	mov    %eax,(%esp)
  8017c5:	ff d2                	call   *%edx
  8017c7:	eb 05                	jmp    8017ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8017ce:	83 c4 24             	add    $0x24,%esp
  8017d1:	5b                   	pop    %ebx
  8017d2:	5d                   	pop    %ebp
  8017d3:	c3                   	ret    

008017d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017da:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	89 04 24             	mov    %eax,(%esp)
  8017e7:	e8 ea fb ff ff       	call   8013d6 <fd_lookup>
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	78 0e                	js     8017fe <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	53                   	push   %ebx
  801804:	83 ec 24             	sub    $0x24,%esp
  801807:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80180a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80180d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801811:	89 1c 24             	mov    %ebx,(%esp)
  801814:	e8 bd fb ff ff       	call   8013d6 <fd_lookup>
  801819:	89 c2                	mov    %eax,%edx
  80181b:	85 d2                	test   %edx,%edx
  80181d:	78 61                	js     801880 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80181f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801822:	89 44 24 04          	mov    %eax,0x4(%esp)
  801826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801829:	8b 00                	mov    (%eax),%eax
  80182b:	89 04 24             	mov    %eax,(%esp)
  80182e:	e8 f9 fb ff ff       	call   80142c <dev_lookup>
  801833:	85 c0                	test   %eax,%eax
  801835:	78 49                	js     801880 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80183e:	75 23                	jne    801863 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801840:	a1 20 54 80 00       	mov    0x805420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801845:	8b 40 48             	mov    0x48(%eax),%eax
  801848:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80184c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801850:	c7 04 24 4c 2f 80 00 	movl   $0x802f4c,(%esp)
  801857:	e8 33 ec ff ff       	call   80048f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80185c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801861:	eb 1d                	jmp    801880 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801863:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801866:	8b 52 18             	mov    0x18(%edx),%edx
  801869:	85 d2                	test   %edx,%edx
  80186b:	74 0e                	je     80187b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80186d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801870:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801874:	89 04 24             	mov    %eax,(%esp)
  801877:	ff d2                	call   *%edx
  801879:	eb 05                	jmp    801880 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80187b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801880:	83 c4 24             	add    $0x24,%esp
  801883:	5b                   	pop    %ebx
  801884:	5d                   	pop    %ebp
  801885:	c3                   	ret    

00801886 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	53                   	push   %ebx
  80188a:	83 ec 24             	sub    $0x24,%esp
  80188d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801890:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801893:	89 44 24 04          	mov    %eax,0x4(%esp)
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	89 04 24             	mov    %eax,(%esp)
  80189d:	e8 34 fb ff ff       	call   8013d6 <fd_lookup>
  8018a2:	89 c2                	mov    %eax,%edx
  8018a4:	85 d2                	test   %edx,%edx
  8018a6:	78 52                	js     8018fa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	89 04 24             	mov    %eax,(%esp)
  8018b7:	e8 70 fb ff ff       	call   80142c <dev_lookup>
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	78 3a                	js     8018fa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018c7:	74 2c                	je     8018f5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018c9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018cc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018d3:	00 00 00 
	stat->st_isdir = 0;
  8018d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018dd:	00 00 00 
	stat->st_dev = dev;
  8018e0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ed:	89 14 24             	mov    %edx,(%esp)
  8018f0:	ff 50 14             	call   *0x14(%eax)
  8018f3:	eb 05                	jmp    8018fa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8018f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8018fa:	83 c4 24             	add    $0x24,%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    

00801900 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
  801905:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801908:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80190f:	00 
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	89 04 24             	mov    %eax,(%esp)
  801916:	e8 28 02 00 00       	call   801b43 <open>
  80191b:	89 c3                	mov    %eax,%ebx
  80191d:	85 db                	test   %ebx,%ebx
  80191f:	78 1b                	js     80193c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801921:	8b 45 0c             	mov    0xc(%ebp),%eax
  801924:	89 44 24 04          	mov    %eax,0x4(%esp)
  801928:	89 1c 24             	mov    %ebx,(%esp)
  80192b:	e8 56 ff ff ff       	call   801886 <fstat>
  801930:	89 c6                	mov    %eax,%esi
	close(fd);
  801932:	89 1c 24             	mov    %ebx,(%esp)
  801935:	e8 cd fb ff ff       	call   801507 <close>
	return r;
  80193a:	89 f0                	mov    %esi,%eax
}
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    

00801943 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	56                   	push   %esi
  801947:	53                   	push   %ebx
  801948:	83 ec 10             	sub    $0x10,%esp
  80194b:	89 c6                	mov    %eax,%esi
  80194d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80194f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801956:	75 11                	jne    801969 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801958:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80195f:	e8 ba 0e 00 00       	call   80281e <ipc_find_env>
  801964:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801969:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801970:	00 
  801971:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801978:	00 
  801979:	89 74 24 04          	mov    %esi,0x4(%esp)
  80197d:	a1 00 50 80 00       	mov    0x805000,%eax
  801982:	89 04 24             	mov    %eax,(%esp)
  801985:	e8 36 0e 00 00       	call   8027c0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80198a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801991:	00 
  801992:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801996:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80199d:	e8 b4 0d 00 00       	call   802756 <ipc_recv>
}
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	5b                   	pop    %ebx
  8019a6:	5e                   	pop    %esi
  8019a7:	5d                   	pop    %ebp
  8019a8:	c3                   	ret    

008019a9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8019ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8019cc:	e8 72 ff ff ff       	call   801943 <fsipc>
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019df:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8019e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e9:	b8 06 00 00 00       	mov    $0x6,%eax
  8019ee:	e8 50 ff ff ff       	call   801943 <fsipc>
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	53                   	push   %ebx
  8019f9:	83 ec 14             	sub    $0x14,%esp
  8019fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8b 40 0c             	mov    0xc(%eax),%eax
  801a05:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a14:	e8 2a ff ff ff       	call   801943 <fsipc>
  801a19:	89 c2                	mov    %eax,%edx
  801a1b:	85 d2                	test   %edx,%edx
  801a1d:	78 2b                	js     801a4a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a1f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a26:	00 
  801a27:	89 1c 24             	mov    %ebx,(%esp)
  801a2a:	e8 88 f0 ff ff       	call   800ab7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a2f:	a1 80 60 80 00       	mov    0x806080,%eax
  801a34:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a3a:	a1 84 60 80 00       	mov    0x806084,%eax
  801a3f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4a:	83 c4 14             	add    $0x14,%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    

00801a50 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 18             	sub    $0x18,%esp
  801a56:	8b 45 10             	mov    0x10(%ebp),%eax
  801a59:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a5e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a63:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801a66:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a6b:	8b 55 08             	mov    0x8(%ebp),%edx
  801a6e:	8b 52 0c             	mov    0xc(%edx),%edx
  801a71:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801a77:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a82:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801a89:	e8 c6 f1 ff ff       	call   800c54 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801a8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a93:	b8 04 00 00 00       	mov    $0x4,%eax
  801a98:	e8 a6 fe ff ff       	call   801943 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	56                   	push   %esi
  801aa3:	53                   	push   %ebx
  801aa4:	83 ec 10             	sub    $0x10,%esp
  801aa7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ab5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801abb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac0:	b8 03 00 00 00       	mov    $0x3,%eax
  801ac5:	e8 79 fe ff ff       	call   801943 <fsipc>
  801aca:	89 c3                	mov    %eax,%ebx
  801acc:	85 c0                	test   %eax,%eax
  801ace:	78 6a                	js     801b3a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ad0:	39 c6                	cmp    %eax,%esi
  801ad2:	73 24                	jae    801af8 <devfile_read+0x59>
  801ad4:	c7 44 24 0c c0 2f 80 	movl   $0x802fc0,0xc(%esp)
  801adb:	00 
  801adc:	c7 44 24 08 c7 2f 80 	movl   $0x802fc7,0x8(%esp)
  801ae3:	00 
  801ae4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801aeb:	00 
  801aec:	c7 04 24 dc 2f 80 00 	movl   $0x802fdc,(%esp)
  801af3:	e8 9e e8 ff ff       	call   800396 <_panic>
	assert(r <= PGSIZE);
  801af8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801afd:	7e 24                	jle    801b23 <devfile_read+0x84>
  801aff:	c7 44 24 0c e7 2f 80 	movl   $0x802fe7,0xc(%esp)
  801b06:	00 
  801b07:	c7 44 24 08 c7 2f 80 	movl   $0x802fc7,0x8(%esp)
  801b0e:	00 
  801b0f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801b16:	00 
  801b17:	c7 04 24 dc 2f 80 00 	movl   $0x802fdc,(%esp)
  801b1e:	e8 73 e8 ff ff       	call   800396 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b23:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b27:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b2e:	00 
  801b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b32:	89 04 24             	mov    %eax,(%esp)
  801b35:	e8 1a f1 ff ff       	call   800c54 <memmove>
	return r;
}
  801b3a:	89 d8                	mov    %ebx,%eax
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5d                   	pop    %ebp
  801b42:	c3                   	ret    

00801b43 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	53                   	push   %ebx
  801b47:	83 ec 24             	sub    $0x24,%esp
  801b4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b4d:	89 1c 24             	mov    %ebx,(%esp)
  801b50:	e8 2b ef ff ff       	call   800a80 <strlen>
  801b55:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b5a:	7f 60                	jg     801bbc <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5f:	89 04 24             	mov    %eax,(%esp)
  801b62:	e8 20 f8 ff ff       	call   801387 <fd_alloc>
  801b67:	89 c2                	mov    %eax,%edx
  801b69:	85 d2                	test   %edx,%edx
  801b6b:	78 54                	js     801bc1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b6d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b71:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801b78:	e8 3a ef ff ff       	call   800ab7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b80:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b88:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8d:	e8 b1 fd ff ff       	call   801943 <fsipc>
  801b92:	89 c3                	mov    %eax,%ebx
  801b94:	85 c0                	test   %eax,%eax
  801b96:	79 17                	jns    801baf <open+0x6c>
		fd_close(fd, 0);
  801b98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b9f:	00 
  801ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba3:	89 04 24             	mov    %eax,(%esp)
  801ba6:	e8 db f8 ff ff       	call   801486 <fd_close>
		return r;
  801bab:	89 d8                	mov    %ebx,%eax
  801bad:	eb 12                	jmp    801bc1 <open+0x7e>
	}

	return fd2num(fd);
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb2:	89 04 24             	mov    %eax,(%esp)
  801bb5:	e8 a6 f7 ff ff       	call   801360 <fd2num>
  801bba:	eb 05                	jmp    801bc1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801bbc:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801bc1:	83 c4 24             	add    $0x24,%esp
  801bc4:	5b                   	pop    %ebx
  801bc5:	5d                   	pop    %ebp
  801bc6:	c3                   	ret    

00801bc7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bcd:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd2:	b8 08 00 00 00       	mov    $0x8,%eax
  801bd7:	e8 67 fd ff ff       	call   801943 <fsipc>
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	53                   	push   %ebx
  801be2:	83 ec 14             	sub    $0x14,%esp
  801be5:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801be7:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801beb:	7e 31                	jle    801c1e <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801bed:	8b 40 04             	mov    0x4(%eax),%eax
  801bf0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bf4:	8d 43 10             	lea    0x10(%ebx),%eax
  801bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfb:	8b 03                	mov    (%ebx),%eax
  801bfd:	89 04 24             	mov    %eax,(%esp)
  801c00:	e8 42 fb ff ff       	call   801747 <write>
		if (result > 0)
  801c05:	85 c0                	test   %eax,%eax
  801c07:	7e 03                	jle    801c0c <writebuf+0x2e>
			b->result += result;
  801c09:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801c0c:	39 43 04             	cmp    %eax,0x4(%ebx)
  801c0f:	74 0d                	je     801c1e <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801c11:	85 c0                	test   %eax,%eax
  801c13:	ba 00 00 00 00       	mov    $0x0,%edx
  801c18:	0f 4f c2             	cmovg  %edx,%eax
  801c1b:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801c1e:	83 c4 14             	add    $0x14,%esp
  801c21:	5b                   	pop    %ebx
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    

00801c24 <putch>:

static void
putch(int ch, void *thunk)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	53                   	push   %ebx
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801c2e:	8b 53 04             	mov    0x4(%ebx),%edx
  801c31:	8d 42 01             	lea    0x1(%edx),%eax
  801c34:	89 43 04             	mov    %eax,0x4(%ebx)
  801c37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3a:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801c3e:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c43:	75 0e                	jne    801c53 <putch+0x2f>
		writebuf(b);
  801c45:	89 d8                	mov    %ebx,%eax
  801c47:	e8 92 ff ff ff       	call   801bde <writebuf>
		b->idx = 0;
  801c4c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801c53:	83 c4 04             	add    $0x4,%esp
  801c56:	5b                   	pop    %ebx
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    

00801c59 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801c6b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801c72:	00 00 00 
	b.result = 0;
  801c75:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c7c:	00 00 00 
	b.error = 1;
  801c7f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801c86:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801c89:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c93:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c97:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca1:	c7 04 24 24 1c 80 00 	movl   $0x801c24,(%esp)
  801ca8:	e8 71 e9 ff ff       	call   80061e <vprintfmt>
	if (b.idx > 0)
  801cad:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801cb4:	7e 0b                	jle    801cc1 <vfprintf+0x68>
		writebuf(&b);
  801cb6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801cbc:	e8 1d ff ff ff       	call   801bde <writebuf>

	return (b.result ? b.result : b.error);
  801cc1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cd8:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801cdb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	89 04 24             	mov    %eax,(%esp)
  801cec:	e8 68 ff ff ff       	call   801c59 <vfprintf>
	va_end(ap);

	return cnt;
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <printf>:

int
printf(const char *fmt, ...)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cf9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801cfc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d0e:	e8 46 ff ff ff       	call   801c59 <vfprintf>
	va_end(ap);

	return cnt;
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    
  801d15:	66 90                	xchg   %ax,%ax
  801d17:	66 90                	xchg   %ax,%ax
  801d19:	66 90                	xchg   %ax,%ax
  801d1b:	66 90                	xchg   %ax,%ax
  801d1d:	66 90                	xchg   %ax,%ax
  801d1f:	90                   	nop

00801d20 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d26:	c7 44 24 04 f3 2f 80 	movl   $0x802ff3,0x4(%esp)
  801d2d:	00 
  801d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d31:	89 04 24             	mov    %eax,(%esp)
  801d34:	e8 7e ed ff ff       	call   800ab7 <strcpy>
	return 0;
}
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	53                   	push   %ebx
  801d44:	83 ec 14             	sub    $0x14,%esp
  801d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d4a:	89 1c 24             	mov    %ebx,(%esp)
  801d4d:	e8 04 0b 00 00       	call   802856 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801d52:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801d57:	83 f8 01             	cmp    $0x1,%eax
  801d5a:	75 0d                	jne    801d69 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801d5c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d5f:	89 04 24             	mov    %eax,(%esp)
  801d62:	e8 29 03 00 00       	call   802090 <nsipc_close>
  801d67:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801d69:	89 d0                	mov    %edx,%eax
  801d6b:	83 c4 14             	add    $0x14,%esp
  801d6e:	5b                   	pop    %ebx
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    

00801d71 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d77:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d7e:	00 
  801d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	8b 40 0c             	mov    0xc(%eax),%eax
  801d93:	89 04 24             	mov    %eax,(%esp)
  801d96:	e8 f0 03 00 00       	call   80218b <nsipc_send>
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801da3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801daa:	00 
  801dab:	8b 45 10             	mov    0x10(%ebp),%eax
  801dae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbf:	89 04 24             	mov    %eax,(%esp)
  801dc2:	e8 44 03 00 00       	call   80210b <nsipc_recv>
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801dcf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dd2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dd6:	89 04 24             	mov    %eax,(%esp)
  801dd9:	e8 f8 f5 ff ff       	call   8013d6 <fd_lookup>
  801dde:	85 c0                	test   %eax,%eax
  801de0:	78 17                	js     801df9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801deb:	39 08                	cmp    %ecx,(%eax)
  801ded:	75 05                	jne    801df4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801def:	8b 40 0c             	mov    0xc(%eax),%eax
  801df2:	eb 05                	jmp    801df9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801df4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	56                   	push   %esi
  801dff:	53                   	push   %ebx
  801e00:	83 ec 20             	sub    $0x20,%esp
  801e03:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e08:	89 04 24             	mov    %eax,(%esp)
  801e0b:	e8 77 f5 ff ff       	call   801387 <fd_alloc>
  801e10:	89 c3                	mov    %eax,%ebx
  801e12:	85 c0                	test   %eax,%eax
  801e14:	78 21                	js     801e37 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e1d:	00 
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e2c:	e8 a2 f0 ff ff       	call   800ed3 <sys_page_alloc>
  801e31:	89 c3                	mov    %eax,%ebx
  801e33:	85 c0                	test   %eax,%eax
  801e35:	79 0c                	jns    801e43 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801e37:	89 34 24             	mov    %esi,(%esp)
  801e3a:	e8 51 02 00 00       	call   802090 <nsipc_close>
		return r;
  801e3f:	89 d8                	mov    %ebx,%eax
  801e41:	eb 20                	jmp    801e63 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e43:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e51:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801e58:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801e5b:	89 14 24             	mov    %edx,(%esp)
  801e5e:	e8 fd f4 ff ff       	call   801360 <fd2num>
}
  801e63:	83 c4 20             	add    $0x20,%esp
  801e66:	5b                   	pop    %ebx
  801e67:	5e                   	pop    %esi
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    

00801e6a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	e8 51 ff ff ff       	call   801dc9 <fd2sockid>
		return r;
  801e78:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	78 23                	js     801ea1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e7e:	8b 55 10             	mov    0x10(%ebp),%edx
  801e81:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e88:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e8c:	89 04 24             	mov    %eax,(%esp)
  801e8f:	e8 45 01 00 00       	call   801fd9 <nsipc_accept>
		return r;
  801e94:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e96:	85 c0                	test   %eax,%eax
  801e98:	78 07                	js     801ea1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801e9a:	e8 5c ff ff ff       	call   801dfb <alloc_sockfd>
  801e9f:	89 c1                	mov    %eax,%ecx
}
  801ea1:	89 c8                	mov    %ecx,%eax
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	e8 16 ff ff ff       	call   801dc9 <fd2sockid>
  801eb3:	89 c2                	mov    %eax,%edx
  801eb5:	85 d2                	test   %edx,%edx
  801eb7:	78 16                	js     801ecf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec7:	89 14 24             	mov    %edx,(%esp)
  801eca:	e8 60 01 00 00       	call   80202f <nsipc_bind>
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <shutdown>:

int
shutdown(int s, int how)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	e8 ea fe ff ff       	call   801dc9 <fd2sockid>
  801edf:	89 c2                	mov    %eax,%edx
  801ee1:	85 d2                	test   %edx,%edx
  801ee3:	78 0f                	js     801ef4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eec:	89 14 24             	mov    %edx,(%esp)
  801eef:	e8 7a 01 00 00       	call   80206e <nsipc_shutdown>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	e8 c5 fe ff ff       	call   801dc9 <fd2sockid>
  801f04:	89 c2                	mov    %eax,%edx
  801f06:	85 d2                	test   %edx,%edx
  801f08:	78 16                	js     801f20 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f18:	89 14 24             	mov    %edx,(%esp)
  801f1b:	e8 8a 01 00 00       	call   8020aa <nsipc_connect>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <listen>:

int
listen(int s, int backlog)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	e8 99 fe ff ff       	call   801dc9 <fd2sockid>
  801f30:	89 c2                	mov    %eax,%edx
  801f32:	85 d2                	test   %edx,%edx
  801f34:	78 0f                	js     801f45 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3d:	89 14 24             	mov    %edx,(%esp)
  801f40:	e8 a4 01 00 00       	call   8020e9 <nsipc_listen>
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f50:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	89 04 24             	mov    %eax,(%esp)
  801f61:	e8 98 02 00 00       	call   8021fe <nsipc_socket>
  801f66:	89 c2                	mov    %eax,%edx
  801f68:	85 d2                	test   %edx,%edx
  801f6a:	78 05                	js     801f71 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801f6c:	e8 8a fe ff ff       	call   801dfb <alloc_sockfd>
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	53                   	push   %ebx
  801f77:	83 ec 14             	sub    $0x14,%esp
  801f7a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f7c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f83:	75 11                	jne    801f96 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f85:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f8c:	e8 8d 08 00 00       	call   80281e <ipc_find_env>
  801f91:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f96:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f9d:	00 
  801f9e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801fa5:	00 
  801fa6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801faa:	a1 04 50 80 00       	mov    0x805004,%eax
  801faf:	89 04 24             	mov    %eax,(%esp)
  801fb2:	e8 09 08 00 00       	call   8027c0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fb7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fbe:	00 
  801fbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fc6:	00 
  801fc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fce:	e8 83 07 00 00       	call   802756 <ipc_recv>
}
  801fd3:	83 c4 14             	add    $0x14,%esp
  801fd6:	5b                   	pop    %ebx
  801fd7:	5d                   	pop    %ebp
  801fd8:	c3                   	ret    

00801fd9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	56                   	push   %esi
  801fdd:	53                   	push   %ebx
  801fde:	83 ec 10             	sub    $0x10,%esp
  801fe1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fec:	8b 06                	mov    (%esi),%eax
  801fee:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ff3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff8:	e8 76 ff ff ff       	call   801f73 <nsipc>
  801ffd:	89 c3                	mov    %eax,%ebx
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 23                	js     802026 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802003:	a1 10 70 80 00       	mov    0x807010,%eax
  802008:	89 44 24 08          	mov    %eax,0x8(%esp)
  80200c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802013:	00 
  802014:	8b 45 0c             	mov    0xc(%ebp),%eax
  802017:	89 04 24             	mov    %eax,(%esp)
  80201a:	e8 35 ec ff ff       	call   800c54 <memmove>
		*addrlen = ret->ret_addrlen;
  80201f:	a1 10 70 80 00       	mov    0x807010,%eax
  802024:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802026:	89 d8                	mov    %ebx,%eax
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	5b                   	pop    %ebx
  80202c:	5e                   	pop    %esi
  80202d:	5d                   	pop    %ebp
  80202e:	c3                   	ret    

0080202f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	53                   	push   %ebx
  802033:	83 ec 14             	sub    $0x14,%esp
  802036:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802041:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802045:	8b 45 0c             	mov    0xc(%ebp),%eax
  802048:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802053:	e8 fc eb ff ff       	call   800c54 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802058:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80205e:	b8 02 00 00 00       	mov    $0x2,%eax
  802063:	e8 0b ff ff ff       	call   801f73 <nsipc>
}
  802068:	83 c4 14             	add    $0x14,%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5d                   	pop    %ebp
  80206d:	c3                   	ret    

0080206e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80207c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802084:	b8 03 00 00 00       	mov    $0x3,%eax
  802089:	e8 e5 fe ff ff       	call   801f73 <nsipc>
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <nsipc_close>:

int
nsipc_close(int s)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80209e:	b8 04 00 00 00       	mov    $0x4,%eax
  8020a3:	e8 cb fe ff ff       	call   801f73 <nsipc>
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	53                   	push   %ebx
  8020ae:	83 ec 14             	sub    $0x14,%esp
  8020b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8020ce:	e8 81 eb ff ff       	call   800c54 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020d3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8020de:	e8 90 fe ff ff       	call   801f73 <nsipc>
}
  8020e3:	83 c4 14             	add    $0x14,%esp
  8020e6:	5b                   	pop    %ebx
  8020e7:	5d                   	pop    %ebp
  8020e8:	c3                   	ret    

008020e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020ff:	b8 06 00 00 00       	mov    $0x6,%eax
  802104:	e8 6a fe ff ff       	call   801f73 <nsipc>
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	56                   	push   %esi
  80210f:	53                   	push   %ebx
  802110:	83 ec 10             	sub    $0x10,%esp
  802113:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80211e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802124:	8b 45 14             	mov    0x14(%ebp),%eax
  802127:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80212c:	b8 07 00 00 00       	mov    $0x7,%eax
  802131:	e8 3d fe ff ff       	call   801f73 <nsipc>
  802136:	89 c3                	mov    %eax,%ebx
  802138:	85 c0                	test   %eax,%eax
  80213a:	78 46                	js     802182 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80213c:	39 f0                	cmp    %esi,%eax
  80213e:	7f 07                	jg     802147 <nsipc_recv+0x3c>
  802140:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802145:	7e 24                	jle    80216b <nsipc_recv+0x60>
  802147:	c7 44 24 0c ff 2f 80 	movl   $0x802fff,0xc(%esp)
  80214e:	00 
  80214f:	c7 44 24 08 c7 2f 80 	movl   $0x802fc7,0x8(%esp)
  802156:	00 
  802157:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80215e:	00 
  80215f:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  802166:	e8 2b e2 ff ff       	call   800396 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80216b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80216f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802176:	00 
  802177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217a:	89 04 24             	mov    %eax,(%esp)
  80217d:	e8 d2 ea ff ff       	call   800c54 <memmove>
	}

	return r;
}
  802182:	89 d8                	mov    %ebx,%eax
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	5b                   	pop    %ebx
  802188:	5e                   	pop    %esi
  802189:	5d                   	pop    %ebp
  80218a:	c3                   	ret    

0080218b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	53                   	push   %ebx
  80218f:	83 ec 14             	sub    $0x14,%esp
  802192:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80219d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021a3:	7e 24                	jle    8021c9 <nsipc_send+0x3e>
  8021a5:	c7 44 24 0c 20 30 80 	movl   $0x803020,0xc(%esp)
  8021ac:	00 
  8021ad:	c7 44 24 08 c7 2f 80 	movl   $0x802fc7,0x8(%esp)
  8021b4:	00 
  8021b5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8021bc:	00 
  8021bd:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  8021c4:	e8 cd e1 ff ff       	call   800396 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8021db:	e8 74 ea ff ff       	call   800c54 <memmove>
	nsipcbuf.send.req_size = size;
  8021e0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8021f3:	e8 7b fd ff ff       	call   801f73 <nsipc>
}
  8021f8:	83 c4 14             	add    $0x14,%esp
  8021fb:	5b                   	pop    %ebx
  8021fc:	5d                   	pop    %ebp
  8021fd:	c3                   	ret    

008021fe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80220c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802214:	8b 45 10             	mov    0x10(%ebp),%eax
  802217:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80221c:	b8 09 00 00 00       	mov    $0x9,%eax
  802221:	e8 4d fd ff ff       	call   801f73 <nsipc>
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	56                   	push   %esi
  80222c:	53                   	push   %ebx
  80222d:	83 ec 10             	sub    $0x10,%esp
  802230:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	89 04 24             	mov    %eax,(%esp)
  802239:	e8 32 f1 ff ff       	call   801370 <fd2data>
  80223e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802240:	c7 44 24 04 2c 30 80 	movl   $0x80302c,0x4(%esp)
  802247:	00 
  802248:	89 1c 24             	mov    %ebx,(%esp)
  80224b:	e8 67 e8 ff ff       	call   800ab7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802250:	8b 46 04             	mov    0x4(%esi),%eax
  802253:	2b 06                	sub    (%esi),%eax
  802255:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80225b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802262:	00 00 00 
	stat->st_dev = &devpipe;
  802265:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80226c:	40 80 00 
	return 0;
}
  80226f:	b8 00 00 00 00       	mov    $0x0,%eax
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	5b                   	pop    %ebx
  802278:	5e                   	pop    %esi
  802279:	5d                   	pop    %ebp
  80227a:	c3                   	ret    

0080227b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	53                   	push   %ebx
  80227f:	83 ec 14             	sub    $0x14,%esp
  802282:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802285:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802289:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802290:	e8 e5 ec ff ff       	call   800f7a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802295:	89 1c 24             	mov    %ebx,(%esp)
  802298:	e8 d3 f0 ff ff       	call   801370 <fd2data>
  80229d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a8:	e8 cd ec ff ff       	call   800f7a <sys_page_unmap>
}
  8022ad:	83 c4 14             	add    $0x14,%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5d                   	pop    %ebp
  8022b2:	c3                   	ret    

008022b3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	57                   	push   %edi
  8022b7:	56                   	push   %esi
  8022b8:	53                   	push   %ebx
  8022b9:	83 ec 2c             	sub    $0x2c,%esp
  8022bc:	89 c6                	mov    %eax,%esi
  8022be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8022c1:	a1 20 54 80 00       	mov    0x805420,%eax
  8022c6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022c9:	89 34 24             	mov    %esi,(%esp)
  8022cc:	e8 85 05 00 00       	call   802856 <pageref>
  8022d1:	89 c7                	mov    %eax,%edi
  8022d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022d6:	89 04 24             	mov    %eax,(%esp)
  8022d9:	e8 78 05 00 00       	call   802856 <pageref>
  8022de:	39 c7                	cmp    %eax,%edi
  8022e0:	0f 94 c2             	sete   %dl
  8022e3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8022e6:	8b 0d 20 54 80 00    	mov    0x805420,%ecx
  8022ec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8022ef:	39 fb                	cmp    %edi,%ebx
  8022f1:	74 21                	je     802314 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8022f3:	84 d2                	test   %dl,%dl
  8022f5:	74 ca                	je     8022c1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022f7:	8b 51 58             	mov    0x58(%ecx),%edx
  8022fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022fe:	89 54 24 08          	mov    %edx,0x8(%esp)
  802302:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802306:	c7 04 24 33 30 80 00 	movl   $0x803033,(%esp)
  80230d:	e8 7d e1 ff ff       	call   80048f <cprintf>
  802312:	eb ad                	jmp    8022c1 <_pipeisclosed+0xe>
	}
}
  802314:	83 c4 2c             	add    $0x2c,%esp
  802317:	5b                   	pop    %ebx
  802318:	5e                   	pop    %esi
  802319:	5f                   	pop    %edi
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    

0080231c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	57                   	push   %edi
  802320:	56                   	push   %esi
  802321:	53                   	push   %ebx
  802322:	83 ec 1c             	sub    $0x1c,%esp
  802325:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802328:	89 34 24             	mov    %esi,(%esp)
  80232b:	e8 40 f0 ff ff       	call   801370 <fd2data>
  802330:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802332:	bf 00 00 00 00       	mov    $0x0,%edi
  802337:	eb 45                	jmp    80237e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802339:	89 da                	mov    %ebx,%edx
  80233b:	89 f0                	mov    %esi,%eax
  80233d:	e8 71 ff ff ff       	call   8022b3 <_pipeisclosed>
  802342:	85 c0                	test   %eax,%eax
  802344:	75 41                	jne    802387 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802346:	e8 69 eb ff ff       	call   800eb4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80234b:	8b 43 04             	mov    0x4(%ebx),%eax
  80234e:	8b 0b                	mov    (%ebx),%ecx
  802350:	8d 51 20             	lea    0x20(%ecx),%edx
  802353:	39 d0                	cmp    %edx,%eax
  802355:	73 e2                	jae    802339 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80235a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80235e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802361:	99                   	cltd   
  802362:	c1 ea 1b             	shr    $0x1b,%edx
  802365:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802368:	83 e1 1f             	and    $0x1f,%ecx
  80236b:	29 d1                	sub    %edx,%ecx
  80236d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802371:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802375:	83 c0 01             	add    $0x1,%eax
  802378:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80237b:	83 c7 01             	add    $0x1,%edi
  80237e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802381:	75 c8                	jne    80234b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802383:	89 f8                	mov    %edi,%eax
  802385:	eb 05                	jmp    80238c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80238c:	83 c4 1c             	add    $0x1c,%esp
  80238f:	5b                   	pop    %ebx
  802390:	5e                   	pop    %esi
  802391:	5f                   	pop    %edi
  802392:	5d                   	pop    %ebp
  802393:	c3                   	ret    

00802394 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	57                   	push   %edi
  802398:	56                   	push   %esi
  802399:	53                   	push   %ebx
  80239a:	83 ec 1c             	sub    $0x1c,%esp
  80239d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8023a0:	89 3c 24             	mov    %edi,(%esp)
  8023a3:	e8 c8 ef ff ff       	call   801370 <fd2data>
  8023a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023aa:	be 00 00 00 00       	mov    $0x0,%esi
  8023af:	eb 3d                	jmp    8023ee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8023b1:	85 f6                	test   %esi,%esi
  8023b3:	74 04                	je     8023b9 <devpipe_read+0x25>
				return i;
  8023b5:	89 f0                	mov    %esi,%eax
  8023b7:	eb 43                	jmp    8023fc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8023b9:	89 da                	mov    %ebx,%edx
  8023bb:	89 f8                	mov    %edi,%eax
  8023bd:	e8 f1 fe ff ff       	call   8022b3 <_pipeisclosed>
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	75 31                	jne    8023f7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8023c6:	e8 e9 ea ff ff       	call   800eb4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8023cb:	8b 03                	mov    (%ebx),%eax
  8023cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023d0:	74 df                	je     8023b1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023d2:	99                   	cltd   
  8023d3:	c1 ea 1b             	shr    $0x1b,%edx
  8023d6:	01 d0                	add    %edx,%eax
  8023d8:	83 e0 1f             	and    $0x1f,%eax
  8023db:	29 d0                	sub    %edx,%eax
  8023dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023e8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023eb:	83 c6 01             	add    $0x1,%esi
  8023ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023f1:	75 d8                	jne    8023cb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8023f3:	89 f0                	mov    %esi,%eax
  8023f5:	eb 05                	jmp    8023fc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8023fc:	83 c4 1c             	add    $0x1c,%esp
  8023ff:	5b                   	pop    %ebx
  802400:	5e                   	pop    %esi
  802401:	5f                   	pop    %edi
  802402:	5d                   	pop    %ebp
  802403:	c3                   	ret    

00802404 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
  802407:	56                   	push   %esi
  802408:	53                   	push   %ebx
  802409:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80240c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80240f:	89 04 24             	mov    %eax,(%esp)
  802412:	e8 70 ef ff ff       	call   801387 <fd_alloc>
  802417:	89 c2                	mov    %eax,%edx
  802419:	85 d2                	test   %edx,%edx
  80241b:	0f 88 4d 01 00 00    	js     80256e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802421:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802428:	00 
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802430:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802437:	e8 97 ea ff ff       	call   800ed3 <sys_page_alloc>
  80243c:	89 c2                	mov    %eax,%edx
  80243e:	85 d2                	test   %edx,%edx
  802440:	0f 88 28 01 00 00    	js     80256e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802446:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802449:	89 04 24             	mov    %eax,(%esp)
  80244c:	e8 36 ef ff ff       	call   801387 <fd_alloc>
  802451:	89 c3                	mov    %eax,%ebx
  802453:	85 c0                	test   %eax,%eax
  802455:	0f 88 fe 00 00 00    	js     802559 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80245b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802462:	00 
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	89 44 24 04          	mov    %eax,0x4(%esp)
  80246a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802471:	e8 5d ea ff ff       	call   800ed3 <sys_page_alloc>
  802476:	89 c3                	mov    %eax,%ebx
  802478:	85 c0                	test   %eax,%eax
  80247a:	0f 88 d9 00 00 00    	js     802559 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	89 04 24             	mov    %eax,(%esp)
  802486:	e8 e5 ee ff ff       	call   801370 <fd2data>
  80248b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802494:	00 
  802495:	89 44 24 04          	mov    %eax,0x4(%esp)
  802499:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a0:	e8 2e ea ff ff       	call   800ed3 <sys_page_alloc>
  8024a5:	89 c3                	mov    %eax,%ebx
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	0f 88 97 00 00 00    	js     802546 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b2:	89 04 24             	mov    %eax,(%esp)
  8024b5:	e8 b6 ee ff ff       	call   801370 <fd2data>
  8024ba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8024c1:	00 
  8024c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024cd:	00 
  8024ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d9:	e8 49 ea ff ff       	call   800f27 <sys_page_map>
  8024de:	89 c3                	mov    %eax,%ebx
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	78 52                	js     802536 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8024e4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8024f9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802507:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	89 04 24             	mov    %eax,(%esp)
  802514:	e8 47 ee ff ff       	call   801360 <fd2num>
  802519:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80251c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80251e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802521:	89 04 24             	mov    %eax,(%esp)
  802524:	e8 37 ee ff ff       	call   801360 <fd2num>
  802529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80252c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80252f:	b8 00 00 00 00       	mov    $0x0,%eax
  802534:	eb 38                	jmp    80256e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802536:	89 74 24 04          	mov    %esi,0x4(%esp)
  80253a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802541:	e8 34 ea ff ff       	call   800f7a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802549:	89 44 24 04          	mov    %eax,0x4(%esp)
  80254d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802554:	e8 21 ea ff ff       	call   800f7a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802560:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802567:	e8 0e ea ff ff       	call   800f7a <sys_page_unmap>
  80256c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80256e:	83 c4 30             	add    $0x30,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5d                   	pop    %ebp
  802574:	c3                   	ret    

00802575 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
  802578:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80257b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80257e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802582:	8b 45 08             	mov    0x8(%ebp),%eax
  802585:	89 04 24             	mov    %eax,(%esp)
  802588:	e8 49 ee ff ff       	call   8013d6 <fd_lookup>
  80258d:	89 c2                	mov    %eax,%edx
  80258f:	85 d2                	test   %edx,%edx
  802591:	78 15                	js     8025a8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	89 04 24             	mov    %eax,(%esp)
  802599:	e8 d2 ed ff ff       	call   801370 <fd2data>
	return _pipeisclosed(fd, p);
  80259e:	89 c2                	mov    %eax,%edx
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	e8 0b fd ff ff       	call   8022b3 <_pipeisclosed>
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    
  8025aa:	66 90                	xchg   %ax,%ax
  8025ac:	66 90                	xchg   %ax,%ax
  8025ae:	66 90                	xchg   %ax,%ax

008025b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b8:	5d                   	pop    %ebp
  8025b9:	c3                   	ret    

008025ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8025c0:	c7 44 24 04 4b 30 80 	movl   $0x80304b,0x4(%esp)
  8025c7:	00 
  8025c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025cb:	89 04 24             	mov    %eax,(%esp)
  8025ce:	e8 e4 e4 ff ff       	call   800ab7 <strcpy>
	return 0;
}
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	57                   	push   %edi
  8025de:	56                   	push   %esi
  8025df:	53                   	push   %ebx
  8025e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025f1:	eb 31                	jmp    802624 <devcons_write+0x4a>
		m = n - tot;
  8025f3:	8b 75 10             	mov    0x10(%ebp),%esi
  8025f6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8025f8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8025fb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802600:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802603:	89 74 24 08          	mov    %esi,0x8(%esp)
  802607:	03 45 0c             	add    0xc(%ebp),%eax
  80260a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80260e:	89 3c 24             	mov    %edi,(%esp)
  802611:	e8 3e e6 ff ff       	call   800c54 <memmove>
		sys_cputs(buf, m);
  802616:	89 74 24 04          	mov    %esi,0x4(%esp)
  80261a:	89 3c 24             	mov    %edi,(%esp)
  80261d:	e8 e4 e7 ff ff       	call   800e06 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802622:	01 f3                	add    %esi,%ebx
  802624:	89 d8                	mov    %ebx,%eax
  802626:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802629:	72 c8                	jb     8025f3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80262b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802631:	5b                   	pop    %ebx
  802632:	5e                   	pop    %esi
  802633:	5f                   	pop    %edi
  802634:	5d                   	pop    %ebp
  802635:	c3                   	ret    

00802636 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80263c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802641:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802645:	75 07                	jne    80264e <devcons_read+0x18>
  802647:	eb 2a                	jmp    802673 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802649:	e8 66 e8 ff ff       	call   800eb4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80264e:	66 90                	xchg   %ax,%ax
  802650:	e8 cf e7 ff ff       	call   800e24 <sys_cgetc>
  802655:	85 c0                	test   %eax,%eax
  802657:	74 f0                	je     802649 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802659:	85 c0                	test   %eax,%eax
  80265b:	78 16                	js     802673 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80265d:	83 f8 04             	cmp    $0x4,%eax
  802660:	74 0c                	je     80266e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802662:	8b 55 0c             	mov    0xc(%ebp),%edx
  802665:	88 02                	mov    %al,(%edx)
	return 1;
  802667:	b8 01 00 00 00       	mov    $0x1,%eax
  80266c:	eb 05                	jmp    802673 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802681:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802688:	00 
  802689:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80268c:	89 04 24             	mov    %eax,(%esp)
  80268f:	e8 72 e7 ff ff       	call   800e06 <sys_cputs>
}
  802694:	c9                   	leave  
  802695:	c3                   	ret    

00802696 <getchar>:

int
getchar(void)
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80269c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026a3:	00 
  8026a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b2:	e8 b3 ef ff ff       	call   80166a <read>
	if (r < 0)
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	78 0f                	js     8026ca <getchar+0x34>
		return r;
	if (r < 1)
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	7e 06                	jle    8026c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8026bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8026c3:	eb 05                	jmp    8026ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8026c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8026ca:	c9                   	leave  
  8026cb:	c3                   	ret    

008026cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
  8026cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	89 04 24             	mov    %eax,(%esp)
  8026df:	e8 f2 ec ff ff       	call   8013d6 <fd_lookup>
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	78 11                	js     8026f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026f1:	39 10                	cmp    %edx,(%eax)
  8026f3:	0f 94 c0             	sete   %al
  8026f6:	0f b6 c0             	movzbl %al,%eax
}
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    

008026fb <opencons>:

int
opencons(void)
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
  8026fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802701:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802704:	89 04 24             	mov    %eax,(%esp)
  802707:	e8 7b ec ff ff       	call   801387 <fd_alloc>
		return r;
  80270c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80270e:	85 c0                	test   %eax,%eax
  802710:	78 40                	js     802752 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802712:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802719:	00 
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802721:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802728:	e8 a6 e7 ff ff       	call   800ed3 <sys_page_alloc>
		return r;
  80272d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80272f:	85 c0                	test   %eax,%eax
  802731:	78 1f                	js     802752 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802733:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802748:	89 04 24             	mov    %eax,(%esp)
  80274b:	e8 10 ec ff ff       	call   801360 <fd2num>
  802750:	89 c2                	mov    %eax,%edx
}
  802752:	89 d0                	mov    %edx,%eax
  802754:	c9                   	leave  
  802755:	c3                   	ret    

00802756 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	56                   	push   %esi
  80275a:	53                   	push   %ebx
  80275b:	83 ec 10             	sub    $0x10,%esp
  80275e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802761:	8b 45 0c             	mov    0xc(%ebp),%eax
  802764:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802767:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802769:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80276e:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802771:	89 04 24             	mov    %eax,(%esp)
  802774:	e8 70 e9 ff ff       	call   8010e9 <sys_ipc_recv>
  802779:	85 c0                	test   %eax,%eax
  80277b:	75 1e                	jne    80279b <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  80277d:	85 db                	test   %ebx,%ebx
  80277f:	74 0a                	je     80278b <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802781:	a1 20 54 80 00       	mov    0x805420,%eax
  802786:	8b 40 74             	mov    0x74(%eax),%eax
  802789:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80278b:	85 f6                	test   %esi,%esi
  80278d:	74 22                	je     8027b1 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  80278f:	a1 20 54 80 00       	mov    0x805420,%eax
  802794:	8b 40 78             	mov    0x78(%eax),%eax
  802797:	89 06                	mov    %eax,(%esi)
  802799:	eb 16                	jmp    8027b1 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80279b:	85 f6                	test   %esi,%esi
  80279d:	74 06                	je     8027a5 <ipc_recv+0x4f>
				*perm_store = 0;
  80279f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8027a5:	85 db                	test   %ebx,%ebx
  8027a7:	74 10                	je     8027b9 <ipc_recv+0x63>
				*from_env_store=0;
  8027a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027af:	eb 08                	jmp    8027b9 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8027b1:	a1 20 54 80 00       	mov    0x805420,%eax
  8027b6:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8027b9:	83 c4 10             	add    $0x10,%esp
  8027bc:	5b                   	pop    %ebx
  8027bd:	5e                   	pop    %esi
  8027be:	5d                   	pop    %ebp
  8027bf:	c3                   	ret    

008027c0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	57                   	push   %edi
  8027c4:	56                   	push   %esi
  8027c5:	53                   	push   %ebx
  8027c6:	83 ec 1c             	sub    $0x1c,%esp
  8027c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027cf:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8027d2:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8027d4:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8027d9:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8027dc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027e0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	89 04 24             	mov    %eax,(%esp)
  8027ee:	e8 d3 e8 ff ff       	call   8010c6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  8027f3:	eb 1c                	jmp    802811 <ipc_send+0x51>
	{
		sys_yield();
  8027f5:	e8 ba e6 ff ff       	call   800eb4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8027fa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802802:	89 74 24 04          	mov    %esi,0x4(%esp)
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	89 04 24             	mov    %eax,(%esp)
  80280c:	e8 b5 e8 ff ff       	call   8010c6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802811:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802814:	74 df                	je     8027f5 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802816:	83 c4 1c             	add    $0x1c,%esp
  802819:	5b                   	pop    %ebx
  80281a:	5e                   	pop    %esi
  80281b:	5f                   	pop    %edi
  80281c:	5d                   	pop    %ebp
  80281d:	c3                   	ret    

0080281e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80281e:	55                   	push   %ebp
  80281f:	89 e5                	mov    %esp,%ebp
  802821:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802824:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802829:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80282c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802832:	8b 52 50             	mov    0x50(%edx),%edx
  802835:	39 ca                	cmp    %ecx,%edx
  802837:	75 0d                	jne    802846 <ipc_find_env+0x28>
			return envs[i].env_id;
  802839:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80283c:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802841:	8b 40 40             	mov    0x40(%eax),%eax
  802844:	eb 0e                	jmp    802854 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802846:	83 c0 01             	add    $0x1,%eax
  802849:	3d 00 04 00 00       	cmp    $0x400,%eax
  80284e:	75 d9                	jne    802829 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802850:	66 b8 00 00          	mov    $0x0,%ax
}
  802854:	5d                   	pop    %ebp
  802855:	c3                   	ret    

00802856 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80285c:	89 d0                	mov    %edx,%eax
  80285e:	c1 e8 16             	shr    $0x16,%eax
  802861:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802868:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80286d:	f6 c1 01             	test   $0x1,%cl
  802870:	74 1d                	je     80288f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802872:	c1 ea 0c             	shr    $0xc,%edx
  802875:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80287c:	f6 c2 01             	test   $0x1,%dl
  80287f:	74 0e                	je     80288f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802881:	c1 ea 0c             	shr    $0xc,%edx
  802884:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80288b:	ef 
  80288c:	0f b7 c0             	movzwl %ax,%eax
}
  80288f:	5d                   	pop    %ebp
  802890:	c3                   	ret    
  802891:	66 90                	xchg   %ax,%ax
  802893:	66 90                	xchg   %ax,%ax
  802895:	66 90                	xchg   %ax,%ax
  802897:	66 90                	xchg   %ax,%ax
  802899:	66 90                	xchg   %ax,%ax
  80289b:	66 90                	xchg   %ax,%ax
  80289d:	66 90                	xchg   %ax,%ax
  80289f:	90                   	nop

008028a0 <__udivdi3>:
  8028a0:	55                   	push   %ebp
  8028a1:	57                   	push   %edi
  8028a2:	56                   	push   %esi
  8028a3:	83 ec 0c             	sub    $0xc,%esp
  8028a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028aa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8028ae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8028b2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8028bc:	89 ea                	mov    %ebp,%edx
  8028be:	89 0c 24             	mov    %ecx,(%esp)
  8028c1:	75 2d                	jne    8028f0 <__udivdi3+0x50>
  8028c3:	39 e9                	cmp    %ebp,%ecx
  8028c5:	77 61                	ja     802928 <__udivdi3+0x88>
  8028c7:	85 c9                	test   %ecx,%ecx
  8028c9:	89 ce                	mov    %ecx,%esi
  8028cb:	75 0b                	jne    8028d8 <__udivdi3+0x38>
  8028cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d2:	31 d2                	xor    %edx,%edx
  8028d4:	f7 f1                	div    %ecx
  8028d6:	89 c6                	mov    %eax,%esi
  8028d8:	31 d2                	xor    %edx,%edx
  8028da:	89 e8                	mov    %ebp,%eax
  8028dc:	f7 f6                	div    %esi
  8028de:	89 c5                	mov    %eax,%ebp
  8028e0:	89 f8                	mov    %edi,%eax
  8028e2:	f7 f6                	div    %esi
  8028e4:	89 ea                	mov    %ebp,%edx
  8028e6:	83 c4 0c             	add    $0xc,%esp
  8028e9:	5e                   	pop    %esi
  8028ea:	5f                   	pop    %edi
  8028eb:	5d                   	pop    %ebp
  8028ec:	c3                   	ret    
  8028ed:	8d 76 00             	lea    0x0(%esi),%esi
  8028f0:	39 e8                	cmp    %ebp,%eax
  8028f2:	77 24                	ja     802918 <__udivdi3+0x78>
  8028f4:	0f bd e8             	bsr    %eax,%ebp
  8028f7:	83 f5 1f             	xor    $0x1f,%ebp
  8028fa:	75 3c                	jne    802938 <__udivdi3+0x98>
  8028fc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802900:	39 34 24             	cmp    %esi,(%esp)
  802903:	0f 86 9f 00 00 00    	jbe    8029a8 <__udivdi3+0x108>
  802909:	39 d0                	cmp    %edx,%eax
  80290b:	0f 82 97 00 00 00    	jb     8029a8 <__udivdi3+0x108>
  802911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802918:	31 d2                	xor    %edx,%edx
  80291a:	31 c0                	xor    %eax,%eax
  80291c:	83 c4 0c             	add    $0xc,%esp
  80291f:	5e                   	pop    %esi
  802920:	5f                   	pop    %edi
  802921:	5d                   	pop    %ebp
  802922:	c3                   	ret    
  802923:	90                   	nop
  802924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802928:	89 f8                	mov    %edi,%eax
  80292a:	f7 f1                	div    %ecx
  80292c:	31 d2                	xor    %edx,%edx
  80292e:	83 c4 0c             	add    $0xc,%esp
  802931:	5e                   	pop    %esi
  802932:	5f                   	pop    %edi
  802933:	5d                   	pop    %ebp
  802934:	c3                   	ret    
  802935:	8d 76 00             	lea    0x0(%esi),%esi
  802938:	89 e9                	mov    %ebp,%ecx
  80293a:	8b 3c 24             	mov    (%esp),%edi
  80293d:	d3 e0                	shl    %cl,%eax
  80293f:	89 c6                	mov    %eax,%esi
  802941:	b8 20 00 00 00       	mov    $0x20,%eax
  802946:	29 e8                	sub    %ebp,%eax
  802948:	89 c1                	mov    %eax,%ecx
  80294a:	d3 ef                	shr    %cl,%edi
  80294c:	89 e9                	mov    %ebp,%ecx
  80294e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802952:	8b 3c 24             	mov    (%esp),%edi
  802955:	09 74 24 08          	or     %esi,0x8(%esp)
  802959:	89 d6                	mov    %edx,%esi
  80295b:	d3 e7                	shl    %cl,%edi
  80295d:	89 c1                	mov    %eax,%ecx
  80295f:	89 3c 24             	mov    %edi,(%esp)
  802962:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802966:	d3 ee                	shr    %cl,%esi
  802968:	89 e9                	mov    %ebp,%ecx
  80296a:	d3 e2                	shl    %cl,%edx
  80296c:	89 c1                	mov    %eax,%ecx
  80296e:	d3 ef                	shr    %cl,%edi
  802970:	09 d7                	or     %edx,%edi
  802972:	89 f2                	mov    %esi,%edx
  802974:	89 f8                	mov    %edi,%eax
  802976:	f7 74 24 08          	divl   0x8(%esp)
  80297a:	89 d6                	mov    %edx,%esi
  80297c:	89 c7                	mov    %eax,%edi
  80297e:	f7 24 24             	mull   (%esp)
  802981:	39 d6                	cmp    %edx,%esi
  802983:	89 14 24             	mov    %edx,(%esp)
  802986:	72 30                	jb     8029b8 <__udivdi3+0x118>
  802988:	8b 54 24 04          	mov    0x4(%esp),%edx
  80298c:	89 e9                	mov    %ebp,%ecx
  80298e:	d3 e2                	shl    %cl,%edx
  802990:	39 c2                	cmp    %eax,%edx
  802992:	73 05                	jae    802999 <__udivdi3+0xf9>
  802994:	3b 34 24             	cmp    (%esp),%esi
  802997:	74 1f                	je     8029b8 <__udivdi3+0x118>
  802999:	89 f8                	mov    %edi,%eax
  80299b:	31 d2                	xor    %edx,%edx
  80299d:	e9 7a ff ff ff       	jmp    80291c <__udivdi3+0x7c>
  8029a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029a8:	31 d2                	xor    %edx,%edx
  8029aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8029af:	e9 68 ff ff ff       	jmp    80291c <__udivdi3+0x7c>
  8029b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8029bb:	31 d2                	xor    %edx,%edx
  8029bd:	83 c4 0c             	add    $0xc,%esp
  8029c0:	5e                   	pop    %esi
  8029c1:	5f                   	pop    %edi
  8029c2:	5d                   	pop    %ebp
  8029c3:	c3                   	ret    
  8029c4:	66 90                	xchg   %ax,%ax
  8029c6:	66 90                	xchg   %ax,%ax
  8029c8:	66 90                	xchg   %ax,%ax
  8029ca:	66 90                	xchg   %ax,%ax
  8029cc:	66 90                	xchg   %ax,%ax
  8029ce:	66 90                	xchg   %ax,%ax

008029d0 <__umoddi3>:
  8029d0:	55                   	push   %ebp
  8029d1:	57                   	push   %edi
  8029d2:	56                   	push   %esi
  8029d3:	83 ec 14             	sub    $0x14,%esp
  8029d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8029da:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8029de:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8029e2:	89 c7                	mov    %eax,%edi
  8029e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8029ec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8029f0:	89 34 24             	mov    %esi,(%esp)
  8029f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	89 c2                	mov    %eax,%edx
  8029fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029ff:	75 17                	jne    802a18 <__umoddi3+0x48>
  802a01:	39 fe                	cmp    %edi,%esi
  802a03:	76 4b                	jbe    802a50 <__umoddi3+0x80>
  802a05:	89 c8                	mov    %ecx,%eax
  802a07:	89 fa                	mov    %edi,%edx
  802a09:	f7 f6                	div    %esi
  802a0b:	89 d0                	mov    %edx,%eax
  802a0d:	31 d2                	xor    %edx,%edx
  802a0f:	83 c4 14             	add    $0x14,%esp
  802a12:	5e                   	pop    %esi
  802a13:	5f                   	pop    %edi
  802a14:	5d                   	pop    %ebp
  802a15:	c3                   	ret    
  802a16:	66 90                	xchg   %ax,%ax
  802a18:	39 f8                	cmp    %edi,%eax
  802a1a:	77 54                	ja     802a70 <__umoddi3+0xa0>
  802a1c:	0f bd e8             	bsr    %eax,%ebp
  802a1f:	83 f5 1f             	xor    $0x1f,%ebp
  802a22:	75 5c                	jne    802a80 <__umoddi3+0xb0>
  802a24:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a28:	39 3c 24             	cmp    %edi,(%esp)
  802a2b:	0f 87 e7 00 00 00    	ja     802b18 <__umoddi3+0x148>
  802a31:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a35:	29 f1                	sub    %esi,%ecx
  802a37:	19 c7                	sbb    %eax,%edi
  802a39:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a41:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a45:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802a49:	83 c4 14             	add    $0x14,%esp
  802a4c:	5e                   	pop    %esi
  802a4d:	5f                   	pop    %edi
  802a4e:	5d                   	pop    %ebp
  802a4f:	c3                   	ret    
  802a50:	85 f6                	test   %esi,%esi
  802a52:	89 f5                	mov    %esi,%ebp
  802a54:	75 0b                	jne    802a61 <__umoddi3+0x91>
  802a56:	b8 01 00 00 00       	mov    $0x1,%eax
  802a5b:	31 d2                	xor    %edx,%edx
  802a5d:	f7 f6                	div    %esi
  802a5f:	89 c5                	mov    %eax,%ebp
  802a61:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a65:	31 d2                	xor    %edx,%edx
  802a67:	f7 f5                	div    %ebp
  802a69:	89 c8                	mov    %ecx,%eax
  802a6b:	f7 f5                	div    %ebp
  802a6d:	eb 9c                	jmp    802a0b <__umoddi3+0x3b>
  802a6f:	90                   	nop
  802a70:	89 c8                	mov    %ecx,%eax
  802a72:	89 fa                	mov    %edi,%edx
  802a74:	83 c4 14             	add    $0x14,%esp
  802a77:	5e                   	pop    %esi
  802a78:	5f                   	pop    %edi
  802a79:	5d                   	pop    %ebp
  802a7a:	c3                   	ret    
  802a7b:	90                   	nop
  802a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a80:	8b 04 24             	mov    (%esp),%eax
  802a83:	be 20 00 00 00       	mov    $0x20,%esi
  802a88:	89 e9                	mov    %ebp,%ecx
  802a8a:	29 ee                	sub    %ebp,%esi
  802a8c:	d3 e2                	shl    %cl,%edx
  802a8e:	89 f1                	mov    %esi,%ecx
  802a90:	d3 e8                	shr    %cl,%eax
  802a92:	89 e9                	mov    %ebp,%ecx
  802a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a98:	8b 04 24             	mov    (%esp),%eax
  802a9b:	09 54 24 04          	or     %edx,0x4(%esp)
  802a9f:	89 fa                	mov    %edi,%edx
  802aa1:	d3 e0                	shl    %cl,%eax
  802aa3:	89 f1                	mov    %esi,%ecx
  802aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802aa9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802aad:	d3 ea                	shr    %cl,%edx
  802aaf:	89 e9                	mov    %ebp,%ecx
  802ab1:	d3 e7                	shl    %cl,%edi
  802ab3:	89 f1                	mov    %esi,%ecx
  802ab5:	d3 e8                	shr    %cl,%eax
  802ab7:	89 e9                	mov    %ebp,%ecx
  802ab9:	09 f8                	or     %edi,%eax
  802abb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802abf:	f7 74 24 04          	divl   0x4(%esp)
  802ac3:	d3 e7                	shl    %cl,%edi
  802ac5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ac9:	89 d7                	mov    %edx,%edi
  802acb:	f7 64 24 08          	mull   0x8(%esp)
  802acf:	39 d7                	cmp    %edx,%edi
  802ad1:	89 c1                	mov    %eax,%ecx
  802ad3:	89 14 24             	mov    %edx,(%esp)
  802ad6:	72 2c                	jb     802b04 <__umoddi3+0x134>
  802ad8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802adc:	72 22                	jb     802b00 <__umoddi3+0x130>
  802ade:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802ae2:	29 c8                	sub    %ecx,%eax
  802ae4:	19 d7                	sbb    %edx,%edi
  802ae6:	89 e9                	mov    %ebp,%ecx
  802ae8:	89 fa                	mov    %edi,%edx
  802aea:	d3 e8                	shr    %cl,%eax
  802aec:	89 f1                	mov    %esi,%ecx
  802aee:	d3 e2                	shl    %cl,%edx
  802af0:	89 e9                	mov    %ebp,%ecx
  802af2:	d3 ef                	shr    %cl,%edi
  802af4:	09 d0                	or     %edx,%eax
  802af6:	89 fa                	mov    %edi,%edx
  802af8:	83 c4 14             	add    $0x14,%esp
  802afb:	5e                   	pop    %esi
  802afc:	5f                   	pop    %edi
  802afd:	5d                   	pop    %ebp
  802afe:	c3                   	ret    
  802aff:	90                   	nop
  802b00:	39 d7                	cmp    %edx,%edi
  802b02:	75 da                	jne    802ade <__umoddi3+0x10e>
  802b04:	8b 14 24             	mov    (%esp),%edx
  802b07:	89 c1                	mov    %eax,%ecx
  802b09:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b0d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802b11:	eb cb                	jmp    802ade <__umoddi3+0x10e>
  802b13:	90                   	nop
  802b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b18:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802b1c:	0f 82 0f ff ff ff    	jb     802a31 <__umoddi3+0x61>
  802b22:	e9 1a ff ff ff       	jmp    802a41 <__umoddi3+0x71>
