
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 67 07 00 00       	call   800798 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800040:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  800047:	e8 db 0e 00 00       	call   800f27 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80004c:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800052:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800059:	e8 da 16 00 00       	call   801738 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80005e:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800065:	00 
  800066:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80006d:	00 
  80006e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800075:	00 
  800076:	89 04 24             	mov    %eax,(%esp)
  800079:	e8 5c 16 00 00       	call   8016da <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  80007e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800085:	00 
  800086:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  80008d:	cc 
  80008e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800095:	e8 d6 15 00 00       	call   801670 <ipc_recv>
}
  80009a:	83 c4 14             	add    $0x14,%esp
  80009d:	5b                   	pop    %ebx
  80009e:	5d                   	pop    %ebp
  80009f:	c3                   	ret    

008000a0 <umain>:

void
umain(int argc, char **argv)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	57                   	push   %edi
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	81 ec cc 02 00 00    	sub    $0x2cc,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b1:	b8 00 2d 80 00       	mov    $0x802d00,%eax
  8000b6:	e8 78 ff ff ff       	call   800033 <xopen>
  8000bb:	85 c0                	test   %eax,%eax
  8000bd:	79 25                	jns    8000e4 <umain+0x44>
  8000bf:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8000c2:	74 3c                	je     800100 <umain+0x60>
		panic("serve_open /not-found: %e", r);
  8000c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c8:	c7 44 24 08 0b 2d 80 	movl   $0x802d0b,0x8(%esp)
  8000cf:	00 
  8000d0:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  8000d7:	00 
  8000d8:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8000df:	e8 1f 07 00 00       	call   800803 <_panic>
	else if (r >= 0)
		panic("serve_open /not-found succeeded!");
  8000e4:	c7 44 24 08 cc 2e 80 	movl   $0x802ecc,0x8(%esp)
  8000eb:	00 
  8000ec:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8000f3:	00 
  8000f4:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8000fb:	e8 03 07 00 00       	call   800803 <_panic>

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800100:	ba 00 00 00 00       	mov    $0x0,%edx
  800105:	b8 35 2d 80 00       	mov    $0x802d35,%eax
  80010a:	e8 24 ff ff ff       	call   800033 <xopen>
  80010f:	85 c0                	test   %eax,%eax
  800111:	79 20                	jns    800133 <umain+0x93>
		panic("serve_open /newmotd: %e", r);
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	c7 44 24 08 3e 2d 80 	movl   $0x802d3e,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  80012e:	e8 d0 06 00 00       	call   800803 <_panic>
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  800133:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  80013a:	75 12                	jne    80014e <umain+0xae>
  80013c:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  800143:	75 09                	jne    80014e <umain+0xae>
  800145:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  80014c:	74 1c                	je     80016a <umain+0xca>
		panic("serve_open did not fill struct Fd correctly\n");
  80014e:	c7 44 24 08 f0 2e 80 	movl   $0x802ef0,0x8(%esp)
  800155:	00 
  800156:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80015d:	00 
  80015e:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800165:	e8 99 06 00 00       	call   800803 <_panic>
	cprintf("serve_open is good\n");
  80016a:	c7 04 24 56 2d 80 00 	movl   $0x802d56,(%esp)
  800171:	e8 86 07 00 00       	call   8008fc <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800176:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80017c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800180:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800187:	ff 15 1c 40 80 00    	call   *0x80401c
  80018d:	85 c0                	test   %eax,%eax
  80018f:	79 20                	jns    8001b1 <umain+0x111>
		panic("file_stat: %e", r);
  800191:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800195:	c7 44 24 08 6a 2d 80 	movl   $0x802d6a,0x8(%esp)
  80019c:	00 
  80019d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8001a4:	00 
  8001a5:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8001ac:	e8 52 06 00 00       	call   800803 <_panic>
	if (strlen(msg) != st.st_size)
  8001b1:	a1 00 40 80 00       	mov    0x804000,%eax
  8001b6:	89 04 24             	mov    %eax,(%esp)
  8001b9:	e8 32 0d 00 00       	call   800ef0 <strlen>
  8001be:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c1:	74 34                	je     8001f7 <umain+0x157>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8001c3:	a1 00 40 80 00       	mov    0x804000,%eax
  8001c8:	89 04 24             	mov    %eax,(%esp)
  8001cb:	e8 20 0d 00 00       	call   800ef0 <strlen>
  8001d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001db:	c7 44 24 08 20 2f 80 	movl   $0x802f20,0x8(%esp)
  8001e2:	00 
  8001e3:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8001ea:	00 
  8001eb:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8001f2:	e8 0c 06 00 00       	call   800803 <_panic>
	cprintf("file_stat is good\n");
  8001f7:	c7 04 24 78 2d 80 00 	movl   $0x802d78,(%esp)
  8001fe:	e8 f9 06 00 00       	call   8008fc <cprintf>

	memset(buf, 0, sizeof buf);
  800203:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80020a:	00 
  80020b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800212:	00 
  800213:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800219:	89 1c 24             	mov    %ebx,(%esp)
  80021c:	e8 56 0e 00 00       	call   801077 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800221:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800228:	00 
  800229:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80022d:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800234:	ff 15 10 40 80 00    	call   *0x804010
  80023a:	85 c0                	test   %eax,%eax
  80023c:	79 20                	jns    80025e <umain+0x1be>
		panic("file_read: %e", r);
  80023e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800242:	c7 44 24 08 8b 2d 80 	movl   $0x802d8b,0x8(%esp)
  800249:	00 
  80024a:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  800251:	00 
  800252:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800259:	e8 a5 05 00 00       	call   800803 <_panic>
	cprintf("Message is %s\n",msg);
  80025e:	a1 00 40 80 00       	mov    0x804000,%eax
  800263:	89 44 24 04          	mov    %eax,0x4(%esp)
  800267:	c7 04 24 99 2d 80 00 	movl   $0x802d99,(%esp)
  80026e:	e8 89 06 00 00       	call   8008fc <cprintf>
	if (strcmp(buf, msg) != 0)
  800273:	a1 00 40 80 00       	mov    0x804000,%eax
  800278:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027c:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800282:	89 04 24             	mov    %eax,(%esp)
  800285:	e8 52 0d 00 00       	call   800fdc <strcmp>
  80028a:	85 c0                	test   %eax,%eax
  80028c:	74 1c                	je     8002aa <umain+0x20a>
		panic("file_read returned wrong data");
  80028e:	c7 44 24 08 a8 2d 80 	movl   $0x802da8,0x8(%esp)
  800295:	00 
  800296:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80029d:	00 
  80029e:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8002a5:	e8 59 05 00 00       	call   800803 <_panic>
	cprintf("file_read is good\n");
  8002aa:	c7 04 24 c6 2d 80 00 	movl   $0x802dc6,(%esp)
  8002b1:	e8 46 06 00 00       	call   8008fc <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8002b6:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8002bd:	ff 15 18 40 80 00    	call   *0x804018
  8002c3:	85 c0                	test   %eax,%eax
  8002c5:	79 20                	jns    8002e7 <umain+0x247>
		panic("file_close: %e", r);
  8002c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002cb:	c7 44 24 08 d9 2d 80 	movl   $0x802dd9,0x8(%esp)
  8002d2:	00 
  8002d3:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8002da:	00 
  8002db:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8002e2:	e8 1c 05 00 00       	call   800803 <_panic>
	cprintf("file_close is good\n");
  8002e7:	c7 04 24 e8 2d 80 00 	movl   $0x802de8,(%esp)
  8002ee:	e8 09 06 00 00       	call   8008fc <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8002f3:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8002f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002fb:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  800300:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800303:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  800308:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80030b:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  800310:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  800313:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  80031a:	cc 
  80031b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800322:	e8 c3 10 00 00       	call   8013ea <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  800327:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80032e:	00 
  80032f:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800335:	89 44 24 04          	mov    %eax,0x4(%esp)
  800339:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80033c:	89 04 24             	mov    %eax,(%esp)
  80033f:	ff 15 10 40 80 00    	call   *0x804010
  800345:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800348:	74 20                	je     80036a <umain+0x2ca>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80034a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80034e:	c7 44 24 08 48 2f 80 	movl   $0x802f48,0x8(%esp)
  800355:	00 
  800356:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  80035d:	00 
  80035e:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800365:	e8 99 04 00 00       	call   800803 <_panic>
	cprintf("stale fileid is good\n");
  80036a:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800371:	e8 86 05 00 00       	call   8008fc <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800376:	ba 02 01 00 00       	mov    $0x102,%edx
  80037b:	b8 12 2e 80 00       	mov    $0x802e12,%eax
  800380:	e8 ae fc ff ff       	call   800033 <xopen>
  800385:	85 c0                	test   %eax,%eax
  800387:	79 20                	jns    8003a9 <umain+0x309>
		panic("serve_open /new-file: %e", r);
  800389:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80038d:	c7 44 24 08 1c 2e 80 	movl   $0x802e1c,0x8(%esp)
  800394:	00 
  800395:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  80039c:	00 
  80039d:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8003a4:	e8 5a 04 00 00       	call   800803 <_panic>

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  8003a9:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  8003af:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b4:	89 04 24             	mov    %eax,(%esp)
  8003b7:	e8 34 0b 00 00       	call   800ef0 <strlen>
  8003bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c0:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c9:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8003d0:	ff d3                	call   *%ebx
  8003d2:	89 c3                	mov    %eax,%ebx
  8003d4:	a1 00 40 80 00       	mov    0x804000,%eax
  8003d9:	89 04 24             	mov    %eax,(%esp)
  8003dc:	e8 0f 0b 00 00       	call   800ef0 <strlen>
  8003e1:	39 c3                	cmp    %eax,%ebx
  8003e3:	74 20                	je     800405 <umain+0x365>
		panic("file_write: %e", r);
  8003e5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003e9:	c7 44 24 08 35 2e 80 	movl   $0x802e35,0x8(%esp)
  8003f0:	00 
  8003f1:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  8003f8:	00 
  8003f9:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800400:	e8 fe 03 00 00       	call   800803 <_panic>
	cprintf("file_write is good\n");
  800405:	c7 04 24 44 2e 80 00 	movl   $0x802e44,(%esp)
  80040c:	e8 eb 04 00 00       	call   8008fc <cprintf>

	FVA->fd_offset = 0;
  800411:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800418:	00 00 00 
	memset(buf, 0, sizeof buf);
  80041b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800422:	00 
  800423:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80042a:	00 
  80042b:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800431:	89 1c 24             	mov    %ebx,(%esp)
  800434:	e8 3e 0c 00 00       	call   801077 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800439:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800440:	00 
  800441:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800445:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  80044c:	ff 15 10 40 80 00    	call   *0x804010
  800452:	89 c3                	mov    %eax,%ebx
  800454:	85 c0                	test   %eax,%eax
  800456:	79 20                	jns    800478 <umain+0x3d8>
		panic("file_read after file_write: %e", r);
  800458:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80045c:	c7 44 24 08 80 2f 80 	movl   $0x802f80,0x8(%esp)
  800463:	00 
  800464:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  80046b:	00 
  80046c:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800473:	e8 8b 03 00 00       	call   800803 <_panic>
	if (r != strlen(msg))
  800478:	a1 00 40 80 00       	mov    0x804000,%eax
  80047d:	89 04 24             	mov    %eax,(%esp)
  800480:	e8 6b 0a 00 00       	call   800ef0 <strlen>
  800485:	39 d8                	cmp    %ebx,%eax
  800487:	74 20                	je     8004a9 <umain+0x409>
		panic("file_read after file_write returned wrong length: %d", r);
  800489:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80048d:	c7 44 24 08 a0 2f 80 	movl   $0x802fa0,0x8(%esp)
  800494:	00 
  800495:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  80049c:	00 
  80049d:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8004a4:	e8 5a 03 00 00       	call   800803 <_panic>
	if (strcmp(buf, msg) != 0)
  8004a9:	a1 00 40 80 00       	mov    0x804000,%eax
  8004ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b2:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8004b8:	89 04 24             	mov    %eax,(%esp)
  8004bb:	e8 1c 0b 00 00       	call   800fdc <strcmp>
  8004c0:	85 c0                	test   %eax,%eax
  8004c2:	74 1c                	je     8004e0 <umain+0x440>
		panic("file_read after file_write returned wrong data");
  8004c4:	c7 44 24 08 d8 2f 80 	movl   $0x802fd8,0x8(%esp)
  8004cb:	00 
  8004cc:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  8004d3:	00 
  8004d4:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8004db:	e8 23 03 00 00       	call   800803 <_panic>
	cprintf("file_read after file_write is good\n");
  8004e0:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  8004e7:	e8 10 04 00 00       	call   8008fc <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8004ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004f3:	00 
  8004f4:	c7 04 24 00 2d 80 00 	movl   $0x802d00,(%esp)
  8004fb:	e8 53 1a 00 00       	call   801f53 <open>
  800500:	85 c0                	test   %eax,%eax
  800502:	79 25                	jns    800529 <umain+0x489>
  800504:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800507:	74 3c                	je     800545 <umain+0x4a5>
		panic("open /not-found: %e", r);
  800509:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80050d:	c7 44 24 08 11 2d 80 	movl   $0x802d11,0x8(%esp)
  800514:	00 
  800515:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  80051c:	00 
  80051d:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800524:	e8 da 02 00 00       	call   800803 <_panic>
	else if (r >= 0)
		panic("open /not-found succeeded!");
  800529:	c7 44 24 08 58 2e 80 	movl   $0x802e58,0x8(%esp)
  800530:	00 
  800531:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  800538:	00 
  800539:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800540:	e8 be 02 00 00       	call   800803 <_panic>

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  800545:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80054c:	00 
  80054d:	c7 04 24 35 2d 80 00 	movl   $0x802d35,(%esp)
  800554:	e8 fa 19 00 00       	call   801f53 <open>
  800559:	85 c0                	test   %eax,%eax
  80055b:	79 20                	jns    80057d <umain+0x4dd>
		panic("open /newmotd: %e", r);
  80055d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800561:	c7 44 24 08 44 2d 80 	movl   $0x802d44,0x8(%esp)
  800568:	00 
  800569:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
  800570:	00 
  800571:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800578:	e8 86 02 00 00       	call   800803 <_panic>
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  80057d:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800580:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800587:	75 12                	jne    80059b <umain+0x4fb>
  800589:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  800590:	75 09                	jne    80059b <umain+0x4fb>
  800592:	83 b8 08 00 00 d0 00 	cmpl   $0x0,-0x2ffffff8(%eax)
  800599:	74 1c                	je     8005b7 <umain+0x517>
		panic("open did not fill struct Fd correctly\n");
  80059b:	c7 44 24 08 2c 30 80 	movl   $0x80302c,0x8(%esp)
  8005a2:	00 
  8005a3:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8005aa:	00 
  8005ab:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8005b2:	e8 4c 02 00 00       	call   800803 <_panic>
	cprintf("open is good\n");
  8005b7:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  8005be:	e8 39 03 00 00       	call   8008fc <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8005c3:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  8005ca:	00 
  8005cb:	c7 04 24 73 2e 80 00 	movl   $0x802e73,(%esp)
  8005d2:	e8 7c 19 00 00       	call   801f53 <open>
  8005d7:	89 c6                	mov    %eax,%esi
  8005d9:	85 c0                	test   %eax,%eax
  8005db:	79 20                	jns    8005fd <umain+0x55d>
		panic("creat /big: %e", f);
  8005dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005e1:	c7 44 24 08 78 2e 80 	movl   $0x802e78,0x8(%esp)
  8005e8:	00 
  8005e9:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
  8005f0:	00 
  8005f1:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8005f8:	e8 06 02 00 00       	call   800803 <_panic>
	memset(buf, 0, sizeof(buf));
  8005fd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800604:	00 
  800605:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80060c:	00 
  80060d:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800613:	89 04 24             	mov    %eax,(%esp)
  800616:	e8 5c 0a 00 00       	call   801077 <memset>
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80061b:	bb 00 00 00 00       	mov    $0x0,%ebx
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800620:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  800626:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  80062c:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800633:	00 
  800634:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800638:	89 34 24             	mov    %esi,(%esp)
  80063b:	e8 17 15 00 00       	call   801b57 <write>
  800640:	85 c0                	test   %eax,%eax
  800642:	79 24                	jns    800668 <umain+0x5c8>
			panic("write /big@%d: %e", i, r);
  800644:	89 44 24 10          	mov    %eax,0x10(%esp)
  800648:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80064c:	c7 44 24 08 87 2e 80 	movl   $0x802e87,0x8(%esp)
  800653:	00 
  800654:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80065b:	00 
  80065c:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800663:	e8 9b 01 00 00       	call   800803 <_panic>
  800668:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  80066e:	89 c3                	mov    %eax,%ebx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800670:	3d 00 e0 01 00       	cmp    $0x1e000,%eax
  800675:	75 af                	jne    800626 <umain+0x586>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800677:	89 34 24             	mov    %esi,(%esp)
  80067a:	e8 98 12 00 00       	call   801917 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80067f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800686:	00 
  800687:	c7 04 24 73 2e 80 00 	movl   $0x802e73,(%esp)
  80068e:	e8 c0 18 00 00       	call   801f53 <open>
  800693:	89 c6                	mov    %eax,%esi
  800695:	85 c0                	test   %eax,%eax
  800697:	79 20                	jns    8006b9 <umain+0x619>
		panic("open /big: %e", f);
  800699:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80069d:	c7 44 24 08 99 2e 80 	movl   $0x802e99,0x8(%esp)
  8006a4:	00 
  8006a5:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
  8006ac:	00 
  8006ad:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  8006b4:	e8 4a 01 00 00       	call   800803 <_panic>
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
  8006b9:	bb 00 00 00 00       	mov    $0x0,%ebx
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006be:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  8006c4:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006ca:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8006d1:	00 
  8006d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d6:	89 34 24             	mov    %esi,(%esp)
  8006d9:	e8 2e 14 00 00       	call   801b0c <readn>
  8006de:	85 c0                	test   %eax,%eax
  8006e0:	79 24                	jns    800706 <umain+0x666>
			panic("read /big@%d: %e", i, r);
  8006e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006e6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006ea:	c7 44 24 08 a7 2e 80 	movl   $0x802ea7,0x8(%esp)
  8006f1:	00 
  8006f2:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
  8006f9:	00 
  8006fa:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800701:	e8 fd 00 00 00       	call   800803 <_panic>
		if (r != sizeof(buf))
  800706:	3d 00 02 00 00       	cmp    $0x200,%eax
  80070b:	74 2c                	je     800739 <umain+0x699>
			panic("read /big from %d returned %d < %d bytes",
  80070d:	c7 44 24 14 00 02 00 	movl   $0x200,0x14(%esp)
  800714:	00 
  800715:	89 44 24 10          	mov    %eax,0x10(%esp)
  800719:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80071d:	c7 44 24 08 54 30 80 	movl   $0x803054,0x8(%esp)
  800724:	00 
  800725:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  80072c:	00 
  80072d:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800734:	e8 ca 00 00 00       	call   800803 <_panic>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800739:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  80073f:	39 d8                	cmp    %ebx,%eax
  800741:	74 24                	je     800767 <umain+0x6c7>
			panic("read /big from %d returned bad data %d",
  800743:	89 44 24 10          	mov    %eax,0x10(%esp)
  800747:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80074b:	c7 44 24 08 80 30 80 	movl   $0x803080,0x8(%esp)
  800752:	00 
  800753:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80075a:	00 
  80075b:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800762:	e8 9c 00 00 00       	call   800803 <_panic>
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800767:	8d 98 00 02 00 00    	lea    0x200(%eax),%ebx
  80076d:	81 fb ff df 01 00    	cmp    $0x1dfff,%ebx
  800773:	0f 8e 4b ff ff ff    	jle    8006c4 <umain+0x624>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800779:	89 34 24             	mov    %esi,(%esp)
  80077c:	e8 96 11 00 00       	call   801917 <close>
	cprintf("large file is good\n");
  800781:	c7 04 24 b8 2e 80 00 	movl   $0x802eb8,(%esp)
  800788:	e8 6f 01 00 00       	call   8008fc <cprintf>
}
  80078d:	81 c4 cc 02 00 00    	add    $0x2cc,%esp
  800793:	5b                   	pop    %ebx
  800794:	5e                   	pop    %esi
  800795:	5f                   	pop    %edi
  800796:	5d                   	pop    %ebp
  800797:	c3                   	ret    

00800798 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	56                   	push   %esi
  80079c:	53                   	push   %ebx
  80079d:	83 ec 10             	sub    $0x10,%esp
  8007a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007a3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8007a6:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8007ad:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8007b0:	e8 50 0b 00 00       	call   801305 <sys_getenvid>
  8007b5:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  8007ba:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8007bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c2:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007c7:	85 db                	test   %ebx,%ebx
  8007c9:	7e 07                	jle    8007d2 <libmain+0x3a>
		binaryname = argv[0];
  8007cb:	8b 06                	mov    (%esi),%eax
  8007cd:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8007d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d6:	89 1c 24             	mov    %ebx,(%esp)
  8007d9:	e8 c2 f8 ff ff       	call   8000a0 <umain>

	// exit gracefully
	exit();
  8007de:	e8 07 00 00 00       	call   8007ea <exit>
}
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	5b                   	pop    %ebx
  8007e7:	5e                   	pop    %esi
  8007e8:	5d                   	pop    %ebp
  8007e9:	c3                   	ret    

008007ea <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8007f0:	e8 55 11 00 00       	call   80194a <close_all>
	sys_env_destroy(0);
  8007f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007fc:	e8 b2 0a 00 00       	call   8012b3 <sys_env_destroy>
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	56                   	push   %esi
  800807:	53                   	push   %ebx
  800808:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80080b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80080e:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800814:	e8 ec 0a 00 00       	call   801305 <sys_getenvid>
  800819:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800820:	8b 55 08             	mov    0x8(%ebp),%edx
  800823:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800827:	89 74 24 08          	mov    %esi,0x8(%esp)
  80082b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082f:	c7 04 24 d8 30 80 00 	movl   $0x8030d8,(%esp)
  800836:	e8 c1 00 00 00       	call   8008fc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80083b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80083f:	8b 45 10             	mov    0x10(%ebp),%eax
  800842:	89 04 24             	mov    %eax,(%esp)
  800845:	e8 51 00 00 00       	call   80089b <vcprintf>
	cprintf("\n");
  80084a:	c7 04 24 44 35 80 00 	movl   $0x803544,(%esp)
  800851:	e8 a6 00 00 00       	call   8008fc <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800856:	cc                   	int3   
  800857:	eb fd                	jmp    800856 <_panic+0x53>

00800859 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	53                   	push   %ebx
  80085d:	83 ec 14             	sub    $0x14,%esp
  800860:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800863:	8b 13                	mov    (%ebx),%edx
  800865:	8d 42 01             	lea    0x1(%edx),%eax
  800868:	89 03                	mov    %eax,(%ebx)
  80086a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800871:	3d ff 00 00 00       	cmp    $0xff,%eax
  800876:	75 19                	jne    800891 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800878:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80087f:	00 
  800880:	8d 43 08             	lea    0x8(%ebx),%eax
  800883:	89 04 24             	mov    %eax,(%esp)
  800886:	e8 eb 09 00 00       	call   801276 <sys_cputs>
		b->idx = 0;
  80088b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800891:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800895:	83 c4 14             	add    $0x14,%esp
  800898:	5b                   	pop    %ebx
  800899:	5d                   	pop    %ebp
  80089a:	c3                   	ret    

0080089b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8008a4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008ab:	00 00 00 
	b.cnt = 0;
  8008ae:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008b5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d0:	c7 04 24 59 08 80 00 	movl   $0x800859,(%esp)
  8008d7:	e8 b2 01 00 00       	call   800a8e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8008dc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8008ec:	89 04 24             	mov    %eax,(%esp)
  8008ef:	e8 82 09 00 00       	call   801276 <sys_cputs>

	return b.cnt;
}
  8008f4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800902:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800905:	89 44 24 04          	mov    %eax,0x4(%esp)
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 04 24             	mov    %eax,(%esp)
  80090f:	e8 87 ff ff ff       	call   80089b <vcprintf>
	va_end(ap);

	return cnt;
}
  800914:	c9                   	leave  
  800915:	c3                   	ret    
  800916:	66 90                	xchg   %ax,%ax
  800918:	66 90                	xchg   %ax,%ax
  80091a:	66 90                	xchg   %ax,%ax
  80091c:	66 90                	xchg   %ax,%ax
  80091e:	66 90                	xchg   %ax,%ax

00800920 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	57                   	push   %edi
  800924:	56                   	push   %esi
  800925:	53                   	push   %ebx
  800926:	83 ec 3c             	sub    $0x3c,%esp
  800929:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092c:	89 d7                	mov    %edx,%edi
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800934:	8b 45 0c             	mov    0xc(%ebp),%eax
  800937:	89 c3                	mov    %eax,%ebx
  800939:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80093c:	8b 45 10             	mov    0x10(%ebp),%eax
  80093f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800942:	b9 00 00 00 00       	mov    $0x0,%ecx
  800947:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80094d:	39 d9                	cmp    %ebx,%ecx
  80094f:	72 05                	jb     800956 <printnum+0x36>
  800951:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800954:	77 69                	ja     8009bf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800956:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800959:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80095d:	83 ee 01             	sub    $0x1,%esi
  800960:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800964:	89 44 24 08          	mov    %eax,0x8(%esp)
  800968:	8b 44 24 08          	mov    0x8(%esp),%eax
  80096c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800970:	89 c3                	mov    %eax,%ebx
  800972:	89 d6                	mov    %edx,%esi
  800974:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800977:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80097a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80097e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800982:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800985:	89 04 24             	mov    %eax,(%esp)
  800988:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80098b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80098f:	e8 dc 20 00 00       	call   802a70 <__udivdi3>
  800994:	89 d9                	mov    %ebx,%ecx
  800996:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80099a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80099e:	89 04 24             	mov    %eax,(%esp)
  8009a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009a5:	89 fa                	mov    %edi,%edx
  8009a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009aa:	e8 71 ff ff ff       	call   800920 <printnum>
  8009af:	eb 1b                	jmp    8009cc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8009b8:	89 04 24             	mov    %eax,(%esp)
  8009bb:	ff d3                	call   *%ebx
  8009bd:	eb 03                	jmp    8009c2 <printnum+0xa2>
  8009bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009c2:	83 ee 01             	sub    $0x1,%esi
  8009c5:	85 f6                	test   %esi,%esi
  8009c7:	7f e8                	jg     8009b1 <printnum+0x91>
  8009c9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009d0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8009d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8009da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009de:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e5:	89 04 24             	mov    %eax,(%esp)
  8009e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ef:	e8 ac 21 00 00       	call   802ba0 <__umoddi3>
  8009f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009f8:	0f be 80 fb 30 80 00 	movsbl 0x8030fb(%eax),%eax
  8009ff:	89 04 24             	mov    %eax,(%esp)
  800a02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a05:	ff d0                	call   *%eax
}
  800a07:	83 c4 3c             	add    $0x3c,%esp
  800a0a:	5b                   	pop    %ebx
  800a0b:	5e                   	pop    %esi
  800a0c:	5f                   	pop    %edi
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a12:	83 fa 01             	cmp    $0x1,%edx
  800a15:	7e 0e                	jle    800a25 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800a17:	8b 10                	mov    (%eax),%edx
  800a19:	8d 4a 08             	lea    0x8(%edx),%ecx
  800a1c:	89 08                	mov    %ecx,(%eax)
  800a1e:	8b 02                	mov    (%edx),%eax
  800a20:	8b 52 04             	mov    0x4(%edx),%edx
  800a23:	eb 22                	jmp    800a47 <getuint+0x38>
	else if (lflag)
  800a25:	85 d2                	test   %edx,%edx
  800a27:	74 10                	je     800a39 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800a29:	8b 10                	mov    (%eax),%edx
  800a2b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800a2e:	89 08                	mov    %ecx,(%eax)
  800a30:	8b 02                	mov    (%edx),%eax
  800a32:	ba 00 00 00 00       	mov    $0x0,%edx
  800a37:	eb 0e                	jmp    800a47 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800a39:	8b 10                	mov    (%eax),%edx
  800a3b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800a3e:	89 08                	mov    %ecx,(%eax)
  800a40:	8b 02                	mov    (%edx),%eax
  800a42:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800a4f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800a53:	8b 10                	mov    (%eax),%edx
  800a55:	3b 50 04             	cmp    0x4(%eax),%edx
  800a58:	73 0a                	jae    800a64 <sprintputch+0x1b>
		*b->buf++ = ch;
  800a5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a5d:	89 08                	mov    %ecx,(%eax)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	88 02                	mov    %al,(%edx)
}
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a6c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800a6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a73:	8b 45 10             	mov    0x10(%ebp),%eax
  800a76:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 04 24             	mov    %eax,(%esp)
  800a87:	e8 02 00 00 00       	call   800a8e <vprintfmt>
	va_end(ap);
}
  800a8c:	c9                   	leave  
  800a8d:	c3                   	ret    

00800a8e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	57                   	push   %edi
  800a92:	56                   	push   %esi
  800a93:	53                   	push   %ebx
  800a94:	83 ec 3c             	sub    $0x3c,%esp
  800a97:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a9d:	eb 14                	jmp    800ab3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800a9f:	85 c0                	test   %eax,%eax
  800aa1:	0f 84 b3 03 00 00    	je     800e5a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800aa7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aab:	89 04 24             	mov    %eax,(%esp)
  800aae:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab1:	89 f3                	mov    %esi,%ebx
  800ab3:	8d 73 01             	lea    0x1(%ebx),%esi
  800ab6:	0f b6 03             	movzbl (%ebx),%eax
  800ab9:	83 f8 25             	cmp    $0x25,%eax
  800abc:	75 e1                	jne    800a9f <vprintfmt+0x11>
  800abe:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800ac2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ac9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800ad0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  800adc:	eb 1d                	jmp    800afb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ade:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800ae0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800ae4:	eb 15                	jmp    800afb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ae6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ae8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800aec:	eb 0d                	jmp    800afb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800aee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800af1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800af4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800afb:	8d 5e 01             	lea    0x1(%esi),%ebx
  800afe:	0f b6 0e             	movzbl (%esi),%ecx
  800b01:	0f b6 c1             	movzbl %cl,%eax
  800b04:	83 e9 23             	sub    $0x23,%ecx
  800b07:	80 f9 55             	cmp    $0x55,%cl
  800b0a:	0f 87 2a 03 00 00    	ja     800e3a <vprintfmt+0x3ac>
  800b10:	0f b6 c9             	movzbl %cl,%ecx
  800b13:	ff 24 8d 40 32 80 00 	jmp    *0x803240(,%ecx,4)
  800b1a:	89 de                	mov    %ebx,%esi
  800b1c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800b21:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800b24:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800b28:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800b2b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800b2e:	83 fb 09             	cmp    $0x9,%ebx
  800b31:	77 36                	ja     800b69 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b33:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b36:	eb e9                	jmp    800b21 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	8d 48 04             	lea    0x4(%eax),%ecx
  800b3e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800b41:	8b 00                	mov    (%eax),%eax
  800b43:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b46:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800b48:	eb 22                	jmp    800b6c <vprintfmt+0xde>
  800b4a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b4d:	85 c9                	test   %ecx,%ecx
  800b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b54:	0f 49 c1             	cmovns %ecx,%eax
  800b57:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b5a:	89 de                	mov    %ebx,%esi
  800b5c:	eb 9d                	jmp    800afb <vprintfmt+0x6d>
  800b5e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800b60:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800b67:	eb 92                	jmp    800afb <vprintfmt+0x6d>
  800b69:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800b6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b70:	79 89                	jns    800afb <vprintfmt+0x6d>
  800b72:	e9 77 ff ff ff       	jmp    800aee <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b77:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b7a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800b7c:	e9 7a ff ff ff       	jmp    800afb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b81:	8b 45 14             	mov    0x14(%ebp),%eax
  800b84:	8d 50 04             	lea    0x4(%eax),%edx
  800b87:	89 55 14             	mov    %edx,0x14(%ebp)
  800b8a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	89 04 24             	mov    %eax,(%esp)
  800b93:	ff 55 08             	call   *0x8(%ebp)
			break;
  800b96:	e9 18 ff ff ff       	jmp    800ab3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9e:	8d 50 04             	lea    0x4(%eax),%edx
  800ba1:	89 55 14             	mov    %edx,0x14(%ebp)
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	99                   	cltd   
  800ba7:	31 d0                	xor    %edx,%eax
  800ba9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bab:	83 f8 0f             	cmp    $0xf,%eax
  800bae:	7f 0b                	jg     800bbb <vprintfmt+0x12d>
  800bb0:	8b 14 85 a0 33 80 00 	mov    0x8033a0(,%eax,4),%edx
  800bb7:	85 d2                	test   %edx,%edx
  800bb9:	75 20                	jne    800bdb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800bbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bbf:	c7 44 24 08 13 31 80 	movl   $0x803113,0x8(%esp)
  800bc6:	00 
  800bc7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	89 04 24             	mov    %eax,(%esp)
  800bd1:	e8 90 fe ff ff       	call   800a66 <printfmt>
  800bd6:	e9 d8 fe ff ff       	jmp    800ab3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800bdb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bdf:	c7 44 24 08 d9 34 80 	movl   $0x8034d9,0x8(%esp)
  800be6:	00 
  800be7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	89 04 24             	mov    %eax,(%esp)
  800bf1:	e8 70 fe ff ff       	call   800a66 <printfmt>
  800bf6:	e9 b8 fe ff ff       	jmp    800ab3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bfb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c01:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c04:	8b 45 14             	mov    0x14(%ebp),%eax
  800c07:	8d 50 04             	lea    0x4(%eax),%edx
  800c0a:	89 55 14             	mov    %edx,0x14(%ebp)
  800c0d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800c0f:	85 f6                	test   %esi,%esi
  800c11:	b8 0c 31 80 00       	mov    $0x80310c,%eax
  800c16:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800c19:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800c1d:	0f 84 97 00 00 00    	je     800cba <vprintfmt+0x22c>
  800c23:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800c27:	0f 8e 9b 00 00 00    	jle    800cc8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c2d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c31:	89 34 24             	mov    %esi,(%esp)
  800c34:	e8 cf 02 00 00       	call   800f08 <strnlen>
  800c39:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800c3c:	29 c2                	sub    %eax,%edx
  800c3e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800c41:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800c45:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c48:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800c4b:	8b 75 08             	mov    0x8(%ebp),%esi
  800c4e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c51:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c53:	eb 0f                	jmp    800c64 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800c55:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c5c:	89 04 24             	mov    %eax,(%esp)
  800c5f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c61:	83 eb 01             	sub    $0x1,%ebx
  800c64:	85 db                	test   %ebx,%ebx
  800c66:	7f ed                	jg     800c55 <vprintfmt+0x1c7>
  800c68:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800c6b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800c6e:	85 d2                	test   %edx,%edx
  800c70:	b8 00 00 00 00       	mov    $0x0,%eax
  800c75:	0f 49 c2             	cmovns %edx,%eax
  800c78:	29 c2                	sub    %eax,%edx
  800c7a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800c7d:	89 d7                	mov    %edx,%edi
  800c7f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800c82:	eb 50                	jmp    800cd4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800c84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c88:	74 1e                	je     800ca8 <vprintfmt+0x21a>
  800c8a:	0f be d2             	movsbl %dl,%edx
  800c8d:	83 ea 20             	sub    $0x20,%edx
  800c90:	83 fa 5e             	cmp    $0x5e,%edx
  800c93:	76 13                	jbe    800ca8 <vprintfmt+0x21a>
					putch('?', putdat);
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c9c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800ca3:	ff 55 08             	call   *0x8(%ebp)
  800ca6:	eb 0d                	jmp    800cb5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cab:	89 54 24 04          	mov    %edx,0x4(%esp)
  800caf:	89 04 24             	mov    %eax,(%esp)
  800cb2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cb5:	83 ef 01             	sub    $0x1,%edi
  800cb8:	eb 1a                	jmp    800cd4 <vprintfmt+0x246>
  800cba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800cbd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800cc0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cc3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800cc6:	eb 0c                	jmp    800cd4 <vprintfmt+0x246>
  800cc8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800ccb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800cce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cd1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800cd4:	83 c6 01             	add    $0x1,%esi
  800cd7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800cdb:	0f be c2             	movsbl %dl,%eax
  800cde:	85 c0                	test   %eax,%eax
  800ce0:	74 27                	je     800d09 <vprintfmt+0x27b>
  800ce2:	85 db                	test   %ebx,%ebx
  800ce4:	78 9e                	js     800c84 <vprintfmt+0x1f6>
  800ce6:	83 eb 01             	sub    $0x1,%ebx
  800ce9:	79 99                	jns    800c84 <vprintfmt+0x1f6>
  800ceb:	89 f8                	mov    %edi,%eax
  800ced:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800cf0:	8b 75 08             	mov    0x8(%ebp),%esi
  800cf3:	89 c3                	mov    %eax,%ebx
  800cf5:	eb 1a                	jmp    800d11 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800cf7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cfb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800d02:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d04:	83 eb 01             	sub    $0x1,%ebx
  800d07:	eb 08                	jmp    800d11 <vprintfmt+0x283>
  800d09:	89 fb                	mov    %edi,%ebx
  800d0b:	8b 75 08             	mov    0x8(%ebp),%esi
  800d0e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d11:	85 db                	test   %ebx,%ebx
  800d13:	7f e2                	jg     800cf7 <vprintfmt+0x269>
  800d15:	89 75 08             	mov    %esi,0x8(%ebp)
  800d18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1b:	e9 93 fd ff ff       	jmp    800ab3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800d20:	83 fa 01             	cmp    $0x1,%edx
  800d23:	7e 16                	jle    800d3b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800d25:	8b 45 14             	mov    0x14(%ebp),%eax
  800d28:	8d 50 08             	lea    0x8(%eax),%edx
  800d2b:	89 55 14             	mov    %edx,0x14(%ebp)
  800d2e:	8b 50 04             	mov    0x4(%eax),%edx
  800d31:	8b 00                	mov    (%eax),%eax
  800d33:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d36:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800d39:	eb 32                	jmp    800d6d <vprintfmt+0x2df>
	else if (lflag)
  800d3b:	85 d2                	test   %edx,%edx
  800d3d:	74 18                	je     800d57 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800d3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d42:	8d 50 04             	lea    0x4(%eax),%edx
  800d45:	89 55 14             	mov    %edx,0x14(%ebp)
  800d48:	8b 30                	mov    (%eax),%esi
  800d4a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800d4d:	89 f0                	mov    %esi,%eax
  800d4f:	c1 f8 1f             	sar    $0x1f,%eax
  800d52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d55:	eb 16                	jmp    800d6d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800d57:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5a:	8d 50 04             	lea    0x4(%eax),%edx
  800d5d:	89 55 14             	mov    %edx,0x14(%ebp)
  800d60:	8b 30                	mov    (%eax),%esi
  800d62:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800d65:	89 f0                	mov    %esi,%eax
  800d67:	c1 f8 1f             	sar    $0x1f,%eax
  800d6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800d73:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800d78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d7c:	0f 89 80 00 00 00    	jns    800e02 <vprintfmt+0x374>
				putch('-', putdat);
  800d82:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d86:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800d8d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800d90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d96:	f7 d8                	neg    %eax
  800d98:	83 d2 00             	adc    $0x0,%edx
  800d9b:	f7 da                	neg    %edx
			}
			base = 10;
  800d9d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800da2:	eb 5e                	jmp    800e02 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800da4:	8d 45 14             	lea    0x14(%ebp),%eax
  800da7:	e8 63 fc ff ff       	call   800a0f <getuint>
			base = 10;
  800dac:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800db1:	eb 4f                	jmp    800e02 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800db3:	8d 45 14             	lea    0x14(%ebp),%eax
  800db6:	e8 54 fc ff ff       	call   800a0f <getuint>
			base =8;
  800dbb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800dc0:	eb 40                	jmp    800e02 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800dc2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dc6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800dcd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800dd0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dd4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800ddb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800dde:	8b 45 14             	mov    0x14(%ebp),%eax
  800de1:	8d 50 04             	lea    0x4(%eax),%edx
  800de4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800de7:	8b 00                	mov    (%eax),%eax
  800de9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800dee:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800df3:	eb 0d                	jmp    800e02 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800df5:	8d 45 14             	lea    0x14(%ebp),%eax
  800df8:	e8 12 fc ff ff       	call   800a0f <getuint>
			base = 16;
  800dfd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e02:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800e06:	89 74 24 10          	mov    %esi,0x10(%esp)
  800e0a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800e0d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800e11:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e15:	89 04 24             	mov    %eax,(%esp)
  800e18:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e1c:	89 fa                	mov    %edi,%edx
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	e8 fa fa ff ff       	call   800920 <printnum>
			break;
  800e26:	e9 88 fc ff ff       	jmp    800ab3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e2b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e2f:	89 04 24             	mov    %eax,(%esp)
  800e32:	ff 55 08             	call   *0x8(%ebp)
			break;
  800e35:	e9 79 fc ff ff       	jmp    800ab3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e3a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e3e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800e45:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e48:	89 f3                	mov    %esi,%ebx
  800e4a:	eb 03                	jmp    800e4f <vprintfmt+0x3c1>
  800e4c:	83 eb 01             	sub    $0x1,%ebx
  800e4f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800e53:	75 f7                	jne    800e4c <vprintfmt+0x3be>
  800e55:	e9 59 fc ff ff       	jmp    800ab3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800e5a:	83 c4 3c             	add    $0x3c,%esp
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    

00800e62 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 28             	sub    $0x28,%esp
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e71:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e75:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	74 30                	je     800eb3 <vsnprintf+0x51>
  800e83:	85 d2                	test   %edx,%edx
  800e85:	7e 2c                	jle    800eb3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e87:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e91:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e98:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e9c:	c7 04 24 49 0a 80 00 	movl   $0x800a49,(%esp)
  800ea3:	e8 e6 fb ff ff       	call   800a8e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eb1:	eb 05                	jmp    800eb8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800eb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800eb8:	c9                   	leave  
  800eb9:	c3                   	ret    

00800eba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ec0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ec3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 04 24             	mov    %eax,(%esp)
  800edb:	e8 82 ff ff ff       	call   800e62 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    
  800ee2:	66 90                	xchg   %ax,%ax
  800ee4:	66 90                	xchg   %ax,%ax
  800ee6:	66 90                	xchg   %ax,%ax
  800ee8:	66 90                	xchg   %ax,%ax
  800eea:	66 90                	xchg   %ax,%ax
  800eec:	66 90                	xchg   %ax,%ax
  800eee:	66 90                	xchg   %ax,%ax

00800ef0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  800efb:	eb 03                	jmp    800f00 <strlen+0x10>
		n++;
  800efd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f00:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800f04:	75 f7                	jne    800efd <strlen+0xd>
		n++;
	return n;
}
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f11:	b8 00 00 00 00       	mov    $0x0,%eax
  800f16:	eb 03                	jmp    800f1b <strnlen+0x13>
		n++;
  800f18:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1b:	39 d0                	cmp    %edx,%eax
  800f1d:	74 06                	je     800f25 <strnlen+0x1d>
  800f1f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800f23:	75 f3                	jne    800f18 <strnlen+0x10>
		n++;
	return n;
}
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	53                   	push   %ebx
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f31:	89 c2                	mov    %eax,%edx
  800f33:	83 c2 01             	add    $0x1,%edx
  800f36:	83 c1 01             	add    $0x1,%ecx
  800f39:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800f3d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f40:	84 db                	test   %bl,%bl
  800f42:	75 ef                	jne    800f33 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800f44:	5b                   	pop    %ebx
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    

00800f47 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	53                   	push   %ebx
  800f4b:	83 ec 08             	sub    $0x8,%esp
  800f4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f51:	89 1c 24             	mov    %ebx,(%esp)
  800f54:	e8 97 ff ff ff       	call   800ef0 <strlen>
	strcpy(dst + len, src);
  800f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f60:	01 d8                	add    %ebx,%eax
  800f62:	89 04 24             	mov    %eax,(%esp)
  800f65:	e8 bd ff ff ff       	call   800f27 <strcpy>
	return dst;
}
  800f6a:	89 d8                	mov    %ebx,%eax
  800f6c:	83 c4 08             	add    $0x8,%esp
  800f6f:	5b                   	pop    %ebx
  800f70:	5d                   	pop    %ebp
  800f71:	c3                   	ret    

00800f72 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	56                   	push   %esi
  800f76:	53                   	push   %ebx
  800f77:	8b 75 08             	mov    0x8(%ebp),%esi
  800f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7d:	89 f3                	mov    %esi,%ebx
  800f7f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f82:	89 f2                	mov    %esi,%edx
  800f84:	eb 0f                	jmp    800f95 <strncpy+0x23>
		*dst++ = *src;
  800f86:	83 c2 01             	add    $0x1,%edx
  800f89:	0f b6 01             	movzbl (%ecx),%eax
  800f8c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f8f:	80 39 01             	cmpb   $0x1,(%ecx)
  800f92:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f95:	39 da                	cmp    %ebx,%edx
  800f97:	75 ed                	jne    800f86 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800f99:	89 f0                	mov    %esi,%eax
  800f9b:	5b                   	pop    %ebx
  800f9c:	5e                   	pop    %esi
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    

00800f9f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
  800fa4:	8b 75 08             	mov    0x8(%ebp),%esi
  800fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800faa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800fad:	89 f0                	mov    %esi,%eax
  800faf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800fb3:	85 c9                	test   %ecx,%ecx
  800fb5:	75 0b                	jne    800fc2 <strlcpy+0x23>
  800fb7:	eb 1d                	jmp    800fd6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800fb9:	83 c0 01             	add    $0x1,%eax
  800fbc:	83 c2 01             	add    $0x1,%edx
  800fbf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fc2:	39 d8                	cmp    %ebx,%eax
  800fc4:	74 0b                	je     800fd1 <strlcpy+0x32>
  800fc6:	0f b6 0a             	movzbl (%edx),%ecx
  800fc9:	84 c9                	test   %cl,%cl
  800fcb:	75 ec                	jne    800fb9 <strlcpy+0x1a>
  800fcd:	89 c2                	mov    %eax,%edx
  800fcf:	eb 02                	jmp    800fd3 <strlcpy+0x34>
  800fd1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800fd3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800fd6:	29 f0                	sub    %esi,%eax
}
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800fe5:	eb 06                	jmp    800fed <strcmp+0x11>
		p++, q++;
  800fe7:	83 c1 01             	add    $0x1,%ecx
  800fea:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fed:	0f b6 01             	movzbl (%ecx),%eax
  800ff0:	84 c0                	test   %al,%al
  800ff2:	74 04                	je     800ff8 <strcmp+0x1c>
  800ff4:	3a 02                	cmp    (%edx),%al
  800ff6:	74 ef                	je     800fe7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ff8:	0f b6 c0             	movzbl %al,%eax
  800ffb:	0f b6 12             	movzbl (%edx),%edx
  800ffe:	29 d0                	sub    %edx,%eax
}
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    

00801002 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	53                   	push   %ebx
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8b 55 0c             	mov    0xc(%ebp),%edx
  80100c:	89 c3                	mov    %eax,%ebx
  80100e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801011:	eb 06                	jmp    801019 <strncmp+0x17>
		n--, p++, q++;
  801013:	83 c0 01             	add    $0x1,%eax
  801016:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801019:	39 d8                	cmp    %ebx,%eax
  80101b:	74 15                	je     801032 <strncmp+0x30>
  80101d:	0f b6 08             	movzbl (%eax),%ecx
  801020:	84 c9                	test   %cl,%cl
  801022:	74 04                	je     801028 <strncmp+0x26>
  801024:	3a 0a                	cmp    (%edx),%cl
  801026:	74 eb                	je     801013 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801028:	0f b6 00             	movzbl (%eax),%eax
  80102b:	0f b6 12             	movzbl (%edx),%edx
  80102e:	29 d0                	sub    %edx,%eax
  801030:	eb 05                	jmp    801037 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801032:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801037:	5b                   	pop    %ebx
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801044:	eb 07                	jmp    80104d <strchr+0x13>
		if (*s == c)
  801046:	38 ca                	cmp    %cl,%dl
  801048:	74 0f                	je     801059 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80104a:	83 c0 01             	add    $0x1,%eax
  80104d:	0f b6 10             	movzbl (%eax),%edx
  801050:	84 d2                	test   %dl,%dl
  801052:	75 f2                	jne    801046 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801054:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    

0080105b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801065:	eb 07                	jmp    80106e <strfind+0x13>
		if (*s == c)
  801067:	38 ca                	cmp    %cl,%dl
  801069:	74 0a                	je     801075 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80106b:	83 c0 01             	add    $0x1,%eax
  80106e:	0f b6 10             	movzbl (%eax),%edx
  801071:	84 d2                	test   %dl,%dl
  801073:	75 f2                	jne    801067 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	57                   	push   %edi
  80107b:	56                   	push   %esi
  80107c:	53                   	push   %ebx
  80107d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801080:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801083:	85 c9                	test   %ecx,%ecx
  801085:	74 36                	je     8010bd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801087:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80108d:	75 28                	jne    8010b7 <memset+0x40>
  80108f:	f6 c1 03             	test   $0x3,%cl
  801092:	75 23                	jne    8010b7 <memset+0x40>
		c &= 0xFF;
  801094:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801098:	89 d3                	mov    %edx,%ebx
  80109a:	c1 e3 08             	shl    $0x8,%ebx
  80109d:	89 d6                	mov    %edx,%esi
  80109f:	c1 e6 18             	shl    $0x18,%esi
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	c1 e0 10             	shl    $0x10,%eax
  8010a7:	09 f0                	or     %esi,%eax
  8010a9:	09 c2                	or     %eax,%edx
  8010ab:	89 d0                	mov    %edx,%eax
  8010ad:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8010af:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8010b2:	fc                   	cld    
  8010b3:	f3 ab                	rep stos %eax,%es:(%edi)
  8010b5:	eb 06                	jmp    8010bd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	fc                   	cld    
  8010bb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8010bd:	89 f8                	mov    %edi,%eax
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	57                   	push   %edi
  8010c8:	56                   	push   %esi
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d2:	39 c6                	cmp    %eax,%esi
  8010d4:	73 35                	jae    80110b <memmove+0x47>
  8010d6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8010d9:	39 d0                	cmp    %edx,%eax
  8010db:	73 2e                	jae    80110b <memmove+0x47>
		s += n;
		d += n;
  8010dd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8010e0:	89 d6                	mov    %edx,%esi
  8010e2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010e4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8010ea:	75 13                	jne    8010ff <memmove+0x3b>
  8010ec:	f6 c1 03             	test   $0x3,%cl
  8010ef:	75 0e                	jne    8010ff <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8010f1:	83 ef 04             	sub    $0x4,%edi
  8010f4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8010f7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8010fa:	fd                   	std    
  8010fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010fd:	eb 09                	jmp    801108 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8010ff:	83 ef 01             	sub    $0x1,%edi
  801102:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801105:	fd                   	std    
  801106:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801108:	fc                   	cld    
  801109:	eb 1d                	jmp    801128 <memmove+0x64>
  80110b:	89 f2                	mov    %esi,%edx
  80110d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80110f:	f6 c2 03             	test   $0x3,%dl
  801112:	75 0f                	jne    801123 <memmove+0x5f>
  801114:	f6 c1 03             	test   $0x3,%cl
  801117:	75 0a                	jne    801123 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801119:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80111c:	89 c7                	mov    %eax,%edi
  80111e:	fc                   	cld    
  80111f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801121:	eb 05                	jmp    801128 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801123:	89 c7                	mov    %eax,%edi
  801125:	fc                   	cld    
  801126:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801128:	5e                   	pop    %esi
  801129:	5f                   	pop    %edi
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    

0080112c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	89 44 24 08          	mov    %eax,0x8(%esp)
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	89 04 24             	mov    %eax,(%esp)
  801146:	e8 79 ff ff ff       	call   8010c4 <memmove>
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	56                   	push   %esi
  801151:	53                   	push   %ebx
  801152:	8b 55 08             	mov    0x8(%ebp),%edx
  801155:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801158:	89 d6                	mov    %edx,%esi
  80115a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80115d:	eb 1a                	jmp    801179 <memcmp+0x2c>
		if (*s1 != *s2)
  80115f:	0f b6 02             	movzbl (%edx),%eax
  801162:	0f b6 19             	movzbl (%ecx),%ebx
  801165:	38 d8                	cmp    %bl,%al
  801167:	74 0a                	je     801173 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801169:	0f b6 c0             	movzbl %al,%eax
  80116c:	0f b6 db             	movzbl %bl,%ebx
  80116f:	29 d8                	sub    %ebx,%eax
  801171:	eb 0f                	jmp    801182 <memcmp+0x35>
		s1++, s2++;
  801173:	83 c2 01             	add    $0x1,%edx
  801176:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801179:	39 f2                	cmp    %esi,%edx
  80117b:	75 e2                	jne    80115f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80117d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801182:	5b                   	pop    %ebx
  801183:	5e                   	pop    %esi
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    

00801186 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80118f:	89 c2                	mov    %eax,%edx
  801191:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801194:	eb 07                	jmp    80119d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  801196:	38 08                	cmp    %cl,(%eax)
  801198:	74 07                	je     8011a1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80119a:	83 c0 01             	add    $0x1,%eax
  80119d:	39 d0                	cmp    %edx,%eax
  80119f:	72 f5                	jb     801196 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	57                   	push   %edi
  8011a7:	56                   	push   %esi
  8011a8:	53                   	push   %ebx
  8011a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ac:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011af:	eb 03                	jmp    8011b4 <strtol+0x11>
		s++;
  8011b1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011b4:	0f b6 0a             	movzbl (%edx),%ecx
  8011b7:	80 f9 09             	cmp    $0x9,%cl
  8011ba:	74 f5                	je     8011b1 <strtol+0xe>
  8011bc:	80 f9 20             	cmp    $0x20,%cl
  8011bf:	74 f0                	je     8011b1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011c1:	80 f9 2b             	cmp    $0x2b,%cl
  8011c4:	75 0a                	jne    8011d0 <strtol+0x2d>
		s++;
  8011c6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8011c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8011ce:	eb 11                	jmp    8011e1 <strtol+0x3e>
  8011d0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8011d5:	80 f9 2d             	cmp    $0x2d,%cl
  8011d8:	75 07                	jne    8011e1 <strtol+0x3e>
		s++, neg = 1;
  8011da:	8d 52 01             	lea    0x1(%edx),%edx
  8011dd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011e1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8011e6:	75 15                	jne    8011fd <strtol+0x5a>
  8011e8:	80 3a 30             	cmpb   $0x30,(%edx)
  8011eb:	75 10                	jne    8011fd <strtol+0x5a>
  8011ed:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8011f1:	75 0a                	jne    8011fd <strtol+0x5a>
		s += 2, base = 16;
  8011f3:	83 c2 02             	add    $0x2,%edx
  8011f6:	b8 10 00 00 00       	mov    $0x10,%eax
  8011fb:	eb 10                	jmp    80120d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	75 0c                	jne    80120d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801201:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801203:	80 3a 30             	cmpb   $0x30,(%edx)
  801206:	75 05                	jne    80120d <strtol+0x6a>
		s++, base = 8;
  801208:	83 c2 01             	add    $0x1,%edx
  80120b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80120d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801212:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801215:	0f b6 0a             	movzbl (%edx),%ecx
  801218:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80121b:	89 f0                	mov    %esi,%eax
  80121d:	3c 09                	cmp    $0x9,%al
  80121f:	77 08                	ja     801229 <strtol+0x86>
			dig = *s - '0';
  801221:	0f be c9             	movsbl %cl,%ecx
  801224:	83 e9 30             	sub    $0x30,%ecx
  801227:	eb 20                	jmp    801249 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801229:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80122c:	89 f0                	mov    %esi,%eax
  80122e:	3c 19                	cmp    $0x19,%al
  801230:	77 08                	ja     80123a <strtol+0x97>
			dig = *s - 'a' + 10;
  801232:	0f be c9             	movsbl %cl,%ecx
  801235:	83 e9 57             	sub    $0x57,%ecx
  801238:	eb 0f                	jmp    801249 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80123a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80123d:	89 f0                	mov    %esi,%eax
  80123f:	3c 19                	cmp    $0x19,%al
  801241:	77 16                	ja     801259 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801243:	0f be c9             	movsbl %cl,%ecx
  801246:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801249:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80124c:	7d 0f                	jge    80125d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80124e:	83 c2 01             	add    $0x1,%edx
  801251:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801255:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801257:	eb bc                	jmp    801215 <strtol+0x72>
  801259:	89 d8                	mov    %ebx,%eax
  80125b:	eb 02                	jmp    80125f <strtol+0xbc>
  80125d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80125f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801263:	74 05                	je     80126a <strtol+0xc7>
		*endptr = (char *) s;
  801265:	8b 75 0c             	mov    0xc(%ebp),%esi
  801268:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80126a:	f7 d8                	neg    %eax
  80126c:	85 ff                	test   %edi,%edi
  80126e:	0f 44 c3             	cmove  %ebx,%eax
}
  801271:	5b                   	pop    %ebx
  801272:	5e                   	pop    %esi
  801273:	5f                   	pop    %edi
  801274:	5d                   	pop    %ebp
  801275:	c3                   	ret    

00801276 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	57                   	push   %edi
  80127a:	56                   	push   %esi
  80127b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80127c:	b8 00 00 00 00       	mov    $0x0,%eax
  801281:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801284:	8b 55 08             	mov    0x8(%ebp),%edx
  801287:	89 c3                	mov    %eax,%ebx
  801289:	89 c7                	mov    %eax,%edi
  80128b:	89 c6                	mov    %eax,%esi
  80128d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80128f:	5b                   	pop    %ebx
  801290:	5e                   	pop    %esi
  801291:	5f                   	pop    %edi
  801292:	5d                   	pop    %ebp
  801293:	c3                   	ret    

00801294 <sys_cgetc>:

int
sys_cgetc(void)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	57                   	push   %edi
  801298:	56                   	push   %esi
  801299:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80129a:	ba 00 00 00 00       	mov    $0x0,%edx
  80129f:	b8 01 00 00 00       	mov    $0x1,%eax
  8012a4:	89 d1                	mov    %edx,%ecx
  8012a6:	89 d3                	mov    %edx,%ebx
  8012a8:	89 d7                	mov    %edx,%edi
  8012aa:	89 d6                	mov    %edx,%esi
  8012ac:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8012ae:	5b                   	pop    %ebx
  8012af:	5e                   	pop    %esi
  8012b0:	5f                   	pop    %edi
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	57                   	push   %edi
  8012b7:	56                   	push   %esi
  8012b8:	53                   	push   %ebx
  8012b9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012c1:	b8 03 00 00 00       	mov    $0x3,%eax
  8012c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c9:	89 cb                	mov    %ecx,%ebx
  8012cb:	89 cf                	mov    %ecx,%edi
  8012cd:	89 ce                	mov    %ecx,%esi
  8012cf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	7e 28                	jle    8012fd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012d9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8012e0:	00 
  8012e1:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  8012e8:	00 
  8012e9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012f0:	00 
  8012f1:	c7 04 24 1c 34 80 00 	movl   $0x80341c,(%esp)
  8012f8:	e8 06 f5 ff ff       	call   800803 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012fd:	83 c4 2c             	add    $0x2c,%esp
  801300:	5b                   	pop    %ebx
  801301:	5e                   	pop    %esi
  801302:	5f                   	pop    %edi
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    

00801305 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	57                   	push   %edi
  801309:	56                   	push   %esi
  80130a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130b:	ba 00 00 00 00       	mov    $0x0,%edx
  801310:	b8 02 00 00 00       	mov    $0x2,%eax
  801315:	89 d1                	mov    %edx,%ecx
  801317:	89 d3                	mov    %edx,%ebx
  801319:	89 d7                	mov    %edx,%edi
  80131b:	89 d6                	mov    %edx,%esi
  80131d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80131f:	5b                   	pop    %ebx
  801320:	5e                   	pop    %esi
  801321:	5f                   	pop    %edi
  801322:	5d                   	pop    %ebp
  801323:	c3                   	ret    

00801324 <sys_yield>:

void
sys_yield(void)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	57                   	push   %edi
  801328:	56                   	push   %esi
  801329:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132a:	ba 00 00 00 00       	mov    $0x0,%edx
  80132f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801334:	89 d1                	mov    %edx,%ecx
  801336:	89 d3                	mov    %edx,%ebx
  801338:	89 d7                	mov    %edx,%edi
  80133a:	89 d6                	mov    %edx,%esi
  80133c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80133e:	5b                   	pop    %ebx
  80133f:	5e                   	pop    %esi
  801340:	5f                   	pop    %edi
  801341:	5d                   	pop    %ebp
  801342:	c3                   	ret    

00801343 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	57                   	push   %edi
  801347:	56                   	push   %esi
  801348:	53                   	push   %ebx
  801349:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80134c:	be 00 00 00 00       	mov    $0x0,%esi
  801351:	b8 04 00 00 00       	mov    $0x4,%eax
  801356:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801359:	8b 55 08             	mov    0x8(%ebp),%edx
  80135c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80135f:	89 f7                	mov    %esi,%edi
  801361:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801363:	85 c0                	test   %eax,%eax
  801365:	7e 28                	jle    80138f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801367:	89 44 24 10          	mov    %eax,0x10(%esp)
  80136b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801372:	00 
  801373:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  80137a:	00 
  80137b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801382:	00 
  801383:	c7 04 24 1c 34 80 00 	movl   $0x80341c,(%esp)
  80138a:	e8 74 f4 ff ff       	call   800803 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80138f:	83 c4 2c             	add    $0x2c,%esp
  801392:	5b                   	pop    %ebx
  801393:	5e                   	pop    %esi
  801394:	5f                   	pop    %edi
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	57                   	push   %edi
  80139b:	56                   	push   %esi
  80139c:	53                   	push   %ebx
  80139d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8013a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013ae:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8013b4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	7e 28                	jle    8013e2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013be:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8013c5:	00 
  8013c6:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  8013cd:	00 
  8013ce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013d5:	00 
  8013d6:	c7 04 24 1c 34 80 00 	movl   $0x80341c,(%esp)
  8013dd:	e8 21 f4 ff ff       	call   800803 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8013e2:	83 c4 2c             	add    $0x2c,%esp
  8013e5:	5b                   	pop    %ebx
  8013e6:	5e                   	pop    %esi
  8013e7:	5f                   	pop    %edi
  8013e8:	5d                   	pop    %ebp
  8013e9:	c3                   	ret    

008013ea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	57                   	push   %edi
  8013ee:	56                   	push   %esi
  8013ef:	53                   	push   %ebx
  8013f0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f8:	b8 06 00 00 00       	mov    $0x6,%eax
  8013fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801400:	8b 55 08             	mov    0x8(%ebp),%edx
  801403:	89 df                	mov    %ebx,%edi
  801405:	89 de                	mov    %ebx,%esi
  801407:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801409:	85 c0                	test   %eax,%eax
  80140b:	7e 28                	jle    801435 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80140d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801411:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801418:	00 
  801419:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  801420:	00 
  801421:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801428:	00 
  801429:	c7 04 24 1c 34 80 00 	movl   $0x80341c,(%esp)
  801430:	e8 ce f3 ff ff       	call   800803 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801435:	83 c4 2c             	add    $0x2c,%esp
  801438:	5b                   	pop    %ebx
  801439:	5e                   	pop    %esi
  80143a:	5f                   	pop    %edi
  80143b:	5d                   	pop    %ebp
  80143c:	c3                   	ret    

0080143d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	57                   	push   %edi
  801441:	56                   	push   %esi
  801442:	53                   	push   %ebx
  801443:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801446:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144b:	b8 08 00 00 00       	mov    $0x8,%eax
  801450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801453:	8b 55 08             	mov    0x8(%ebp),%edx
  801456:	89 df                	mov    %ebx,%edi
  801458:	89 de                	mov    %ebx,%esi
  80145a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80145c:	85 c0                	test   %eax,%eax
  80145e:	7e 28                	jle    801488 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801460:	89 44 24 10          	mov    %eax,0x10(%esp)
  801464:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80146b:	00 
  80146c:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  801473:	00 
  801474:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80147b:	00 
  80147c:	c7 04 24 1c 34 80 00 	movl   $0x80341c,(%esp)
  801483:	e8 7b f3 ff ff       	call   800803 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801488:	83 c4 2c             	add    $0x2c,%esp
  80148b:	5b                   	pop    %ebx
  80148c:	5e                   	pop    %esi
  80148d:	5f                   	pop    %edi
  80148e:	5d                   	pop    %ebp
  80148f:	c3                   	ret    

00801490 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	57                   	push   %edi
  801494:	56                   	push   %esi
  801495:	53                   	push   %ebx
  801496:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801499:	bb 00 00 00 00       	mov    $0x0,%ebx
  80149e:	b8 09 00 00 00       	mov    $0x9,%eax
  8014a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	89 df                	mov    %ebx,%edi
  8014ab:	89 de                	mov    %ebx,%esi
  8014ad:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	7e 28                	jle    8014db <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014b7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8014be:	00 
  8014bf:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  8014c6:	00 
  8014c7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014ce:	00 
  8014cf:	c7 04 24 1c 34 80 00 	movl   $0x80341c,(%esp)
  8014d6:	e8 28 f3 ff ff       	call   800803 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8014db:	83 c4 2c             	add    $0x2c,%esp
  8014de:	5b                   	pop    %ebx
  8014df:	5e                   	pop    %esi
  8014e0:	5f                   	pop    %edi
  8014e1:	5d                   	pop    %ebp
  8014e2:	c3                   	ret    

008014e3 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	57                   	push   %edi
  8014e7:	56                   	push   %esi
  8014e8:	53                   	push   %ebx
  8014e9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014fc:	89 df                	mov    %ebx,%edi
  8014fe:	89 de                	mov    %ebx,%esi
  801500:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801502:	85 c0                	test   %eax,%eax
  801504:	7e 28                	jle    80152e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801506:	89 44 24 10          	mov    %eax,0x10(%esp)
  80150a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801511:	00 
  801512:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  801519:	00 
  80151a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801521:	00 
  801522:	c7 04 24 1c 34 80 00 	movl   $0x80341c,(%esp)
  801529:	e8 d5 f2 ff ff       	call   800803 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80152e:	83 c4 2c             	add    $0x2c,%esp
  801531:	5b                   	pop    %ebx
  801532:	5e                   	pop    %esi
  801533:	5f                   	pop    %edi
  801534:	5d                   	pop    %ebp
  801535:	c3                   	ret    

00801536 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	57                   	push   %edi
  80153a:	56                   	push   %esi
  80153b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80153c:	be 00 00 00 00       	mov    $0x0,%esi
  801541:	b8 0c 00 00 00       	mov    $0xc,%eax
  801546:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801549:	8b 55 08             	mov    0x8(%ebp),%edx
  80154c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80154f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801552:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801554:	5b                   	pop    %ebx
  801555:	5e                   	pop    %esi
  801556:	5f                   	pop    %edi
  801557:	5d                   	pop    %ebp
  801558:	c3                   	ret    

00801559 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	57                   	push   %edi
  80155d:	56                   	push   %esi
  80155e:	53                   	push   %ebx
  80155f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801562:	b9 00 00 00 00       	mov    $0x0,%ecx
  801567:	b8 0d 00 00 00       	mov    $0xd,%eax
  80156c:	8b 55 08             	mov    0x8(%ebp),%edx
  80156f:	89 cb                	mov    %ecx,%ebx
  801571:	89 cf                	mov    %ecx,%edi
  801573:	89 ce                	mov    %ecx,%esi
  801575:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801577:	85 c0                	test   %eax,%eax
  801579:	7e 28                	jle    8015a3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80157b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80157f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801586:	00 
  801587:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  80158e:	00 
  80158f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801596:	00 
  801597:	c7 04 24 1c 34 80 00 	movl   $0x80341c,(%esp)
  80159e:	e8 60 f2 ff ff       	call   800803 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8015a3:	83 c4 2c             	add    $0x2c,%esp
  8015a6:	5b                   	pop    %ebx
  8015a7:	5e                   	pop    %esi
  8015a8:	5f                   	pop    %edi
  8015a9:	5d                   	pop    %ebp
  8015aa:	c3                   	ret    

008015ab <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	57                   	push   %edi
  8015af:	56                   	push   %esi
  8015b0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8015bb:	89 d1                	mov    %edx,%ecx
  8015bd:	89 d3                	mov    %edx,%ebx
  8015bf:	89 d7                	mov    %edx,%edi
  8015c1:	89 d6                	mov    %edx,%esi
  8015c3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8015c5:	5b                   	pop    %ebx
  8015c6:	5e                   	pop    %esi
  8015c7:	5f                   	pop    %edi
  8015c8:	5d                   	pop    %ebp
  8015c9:	c3                   	ret    

008015ca <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	57                   	push   %edi
  8015ce:	56                   	push   %esi
  8015cf:	53                   	push   %ebx
  8015d0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8015dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e3:	89 df                	mov    %ebx,%edi
  8015e5:	89 de                	mov    %ebx,%esi
  8015e7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	7e 28                	jle    801615 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015f1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8015f8:	00 
  8015f9:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  801600:	00 
  801601:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801608:	00 
  801609:	c7 04 24 1c 34 80 00 	movl   $0x80341c,(%esp)
  801610:	e8 ee f1 ff ff       	call   800803 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801615:	83 c4 2c             	add    $0x2c,%esp
  801618:	5b                   	pop    %ebx
  801619:	5e                   	pop    %esi
  80161a:	5f                   	pop    %edi
  80161b:	5d                   	pop    %ebp
  80161c:	c3                   	ret    

0080161d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	57                   	push   %edi
  801621:	56                   	push   %esi
  801622:	53                   	push   %ebx
  801623:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801626:	bb 00 00 00 00       	mov    $0x0,%ebx
  80162b:	b8 10 00 00 00       	mov    $0x10,%eax
  801630:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801633:	8b 55 08             	mov    0x8(%ebp),%edx
  801636:	89 df                	mov    %ebx,%edi
  801638:	89 de                	mov    %ebx,%esi
  80163a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80163c:	85 c0                	test   %eax,%eax
  80163e:	7e 28                	jle    801668 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801640:	89 44 24 10          	mov    %eax,0x10(%esp)
  801644:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80164b:	00 
  80164c:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  801653:	00 
  801654:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80165b:	00 
  80165c:	c7 04 24 1c 34 80 00 	movl   $0x80341c,(%esp)
  801663:	e8 9b f1 ff ff       	call   800803 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801668:	83 c4 2c             	add    $0x2c,%esp
  80166b:	5b                   	pop    %ebx
  80166c:	5e                   	pop    %esi
  80166d:	5f                   	pop    %edi
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
  801675:	83 ec 10             	sub    $0x10,%esp
  801678:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80167b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167e:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  801681:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  801683:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801688:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  80168b:	89 04 24             	mov    %eax,(%esp)
  80168e:	e8 c6 fe ff ff       	call   801559 <sys_ipc_recv>
  801693:	85 c0                	test   %eax,%eax
  801695:	75 1e                	jne    8016b5 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  801697:	85 db                	test   %ebx,%ebx
  801699:	74 0a                	je     8016a5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80169b:	a1 08 50 80 00       	mov    0x805008,%eax
  8016a0:	8b 40 74             	mov    0x74(%eax),%eax
  8016a3:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8016a5:	85 f6                	test   %esi,%esi
  8016a7:	74 22                	je     8016cb <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8016a9:	a1 08 50 80 00       	mov    0x805008,%eax
  8016ae:	8b 40 78             	mov    0x78(%eax),%eax
  8016b1:	89 06                	mov    %eax,(%esi)
  8016b3:	eb 16                	jmp    8016cb <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  8016b5:	85 f6                	test   %esi,%esi
  8016b7:	74 06                	je     8016bf <ipc_recv+0x4f>
				*perm_store = 0;
  8016b9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8016bf:	85 db                	test   %ebx,%ebx
  8016c1:	74 10                	je     8016d3 <ipc_recv+0x63>
				*from_env_store=0;
  8016c3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016c9:	eb 08                	jmp    8016d3 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8016cb:	a1 08 50 80 00       	mov    0x805008,%eax
  8016d0:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	5b                   	pop    %ebx
  8016d7:	5e                   	pop    %esi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    

008016da <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	57                   	push   %edi
  8016de:	56                   	push   %esi
  8016df:	53                   	push   %ebx
  8016e0:	83 ec 1c             	sub    $0x1c,%esp
  8016e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016e9:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8016ec:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8016ee:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8016f3:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8016f6:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	89 04 24             	mov    %eax,(%esp)
  801708:	e8 29 fe ff ff       	call   801536 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  80170d:	eb 1c                	jmp    80172b <ipc_send+0x51>
	{
		sys_yield();
  80170f:	e8 10 fc ff ff       	call   801324 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  801714:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801718:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80171c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	89 04 24             	mov    %eax,(%esp)
  801726:	e8 0b fe ff ff       	call   801536 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  80172b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80172e:	74 df                	je     80170f <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  801730:	83 c4 1c             	add    $0x1c,%esp
  801733:	5b                   	pop    %ebx
  801734:	5e                   	pop    %esi
  801735:	5f                   	pop    %edi
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801743:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801746:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80174c:	8b 52 50             	mov    0x50(%edx),%edx
  80174f:	39 ca                	cmp    %ecx,%edx
  801751:	75 0d                	jne    801760 <ipc_find_env+0x28>
			return envs[i].env_id;
  801753:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801756:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80175b:	8b 40 40             	mov    0x40(%eax),%eax
  80175e:	eb 0e                	jmp    80176e <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801760:	83 c0 01             	add    $0x1,%eax
  801763:	3d 00 04 00 00       	cmp    $0x400,%eax
  801768:	75 d9                	jne    801743 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80176a:	66 b8 00 00          	mov    $0x0,%ax
}
  80176e:	5d                   	pop    %ebp
  80176f:	c3                   	ret    

00801770 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	05 00 00 00 30       	add    $0x30000000,%eax
  80177b:	c1 e8 0c             	shr    $0xc,%eax
}
  80177e:	5d                   	pop    %ebp
  80177f:	c3                   	ret    

00801780 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80178b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801790:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    

00801797 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80179d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017a2:	89 c2                	mov    %eax,%edx
  8017a4:	c1 ea 16             	shr    $0x16,%edx
  8017a7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017ae:	f6 c2 01             	test   $0x1,%dl
  8017b1:	74 11                	je     8017c4 <fd_alloc+0x2d>
  8017b3:	89 c2                	mov    %eax,%edx
  8017b5:	c1 ea 0c             	shr    $0xc,%edx
  8017b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017bf:	f6 c2 01             	test   $0x1,%dl
  8017c2:	75 09                	jne    8017cd <fd_alloc+0x36>
			*fd_store = fd;
  8017c4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cb:	eb 17                	jmp    8017e4 <fd_alloc+0x4d>
  8017cd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8017d2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017d7:	75 c9                	jne    8017a2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017d9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8017df:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    

008017e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017ec:	83 f8 1f             	cmp    $0x1f,%eax
  8017ef:	77 36                	ja     801827 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017f1:	c1 e0 0c             	shl    $0xc,%eax
  8017f4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017f9:	89 c2                	mov    %eax,%edx
  8017fb:	c1 ea 16             	shr    $0x16,%edx
  8017fe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801805:	f6 c2 01             	test   $0x1,%dl
  801808:	74 24                	je     80182e <fd_lookup+0x48>
  80180a:	89 c2                	mov    %eax,%edx
  80180c:	c1 ea 0c             	shr    $0xc,%edx
  80180f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801816:	f6 c2 01             	test   $0x1,%dl
  801819:	74 1a                	je     801835 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80181b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181e:	89 02                	mov    %eax,(%edx)
	return 0;
  801820:	b8 00 00 00 00       	mov    $0x0,%eax
  801825:	eb 13                	jmp    80183a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801827:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80182c:	eb 0c                	jmp    80183a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80182e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801833:	eb 05                	jmp    80183a <fd_lookup+0x54>
  801835:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    

0080183c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 18             	sub    $0x18,%esp
  801842:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801845:	ba 00 00 00 00       	mov    $0x0,%edx
  80184a:	eb 13                	jmp    80185f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80184c:	39 08                	cmp    %ecx,(%eax)
  80184e:	75 0c                	jne    80185c <dev_lookup+0x20>
			*dev = devtab[i];
  801850:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801853:	89 01                	mov    %eax,(%ecx)
			return 0;
  801855:	b8 00 00 00 00       	mov    $0x0,%eax
  80185a:	eb 38                	jmp    801894 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80185c:	83 c2 01             	add    $0x1,%edx
  80185f:	8b 04 95 ac 34 80 00 	mov    0x8034ac(,%edx,4),%eax
  801866:	85 c0                	test   %eax,%eax
  801868:	75 e2                	jne    80184c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80186a:	a1 08 50 80 00       	mov    0x805008,%eax
  80186f:	8b 40 48             	mov    0x48(%eax),%eax
  801872:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801876:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187a:	c7 04 24 2c 34 80 00 	movl   $0x80342c,(%esp)
  801881:	e8 76 f0 ff ff       	call   8008fc <cprintf>
	*dev = 0;
  801886:	8b 45 0c             	mov    0xc(%ebp),%eax
  801889:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80188f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	56                   	push   %esi
  80189a:	53                   	push   %ebx
  80189b:	83 ec 20             	sub    $0x20,%esp
  80189e:	8b 75 08             	mov    0x8(%ebp),%esi
  8018a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018ab:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018b1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018b4:	89 04 24             	mov    %eax,(%esp)
  8018b7:	e8 2a ff ff ff       	call   8017e6 <fd_lookup>
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	78 05                	js     8018c5 <fd_close+0x2f>
	    || fd != fd2)
  8018c0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018c3:	74 0c                	je     8018d1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8018c5:	84 db                	test   %bl,%bl
  8018c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cc:	0f 44 c2             	cmove  %edx,%eax
  8018cf:	eb 3f                	jmp    801910 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d8:	8b 06                	mov    (%esi),%eax
  8018da:	89 04 24             	mov    %eax,(%esp)
  8018dd:	e8 5a ff ff ff       	call   80183c <dev_lookup>
  8018e2:	89 c3                	mov    %eax,%ebx
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	78 16                	js     8018fe <fd_close+0x68>
		if (dev->dev_close)
  8018e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018eb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8018ee:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	74 07                	je     8018fe <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8018f7:	89 34 24             	mov    %esi,(%esp)
  8018fa:	ff d0                	call   *%eax
  8018fc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8018fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801902:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801909:	e8 dc fa ff ff       	call   8013ea <sys_page_unmap>
	return r;
  80190e:	89 d8                	mov    %ebx,%eax
}
  801910:	83 c4 20             	add    $0x20,%esp
  801913:	5b                   	pop    %ebx
  801914:	5e                   	pop    %esi
  801915:	5d                   	pop    %ebp
  801916:	c3                   	ret    

00801917 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80191d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801920:	89 44 24 04          	mov    %eax,0x4(%esp)
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	89 04 24             	mov    %eax,(%esp)
  80192a:	e8 b7 fe ff ff       	call   8017e6 <fd_lookup>
  80192f:	89 c2                	mov    %eax,%edx
  801931:	85 d2                	test   %edx,%edx
  801933:	78 13                	js     801948 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801935:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80193c:	00 
  80193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801940:	89 04 24             	mov    %eax,(%esp)
  801943:	e8 4e ff ff ff       	call   801896 <fd_close>
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <close_all>:

void
close_all(void)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	53                   	push   %ebx
  80194e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801951:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801956:	89 1c 24             	mov    %ebx,(%esp)
  801959:	e8 b9 ff ff ff       	call   801917 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80195e:	83 c3 01             	add    $0x1,%ebx
  801961:	83 fb 20             	cmp    $0x20,%ebx
  801964:	75 f0                	jne    801956 <close_all+0xc>
		close(i);
}
  801966:	83 c4 14             	add    $0x14,%esp
  801969:	5b                   	pop    %ebx
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    

0080196c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	57                   	push   %edi
  801970:	56                   	push   %esi
  801971:	53                   	push   %ebx
  801972:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801975:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801978:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	89 04 24             	mov    %eax,(%esp)
  801982:	e8 5f fe ff ff       	call   8017e6 <fd_lookup>
  801987:	89 c2                	mov    %eax,%edx
  801989:	85 d2                	test   %edx,%edx
  80198b:	0f 88 e1 00 00 00    	js     801a72 <dup+0x106>
		return r;
	close(newfdnum);
  801991:	8b 45 0c             	mov    0xc(%ebp),%eax
  801994:	89 04 24             	mov    %eax,(%esp)
  801997:	e8 7b ff ff ff       	call   801917 <close>

	newfd = INDEX2FD(newfdnum);
  80199c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80199f:	c1 e3 0c             	shl    $0xc,%ebx
  8019a2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8019a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019ab:	89 04 24             	mov    %eax,(%esp)
  8019ae:	e8 cd fd ff ff       	call   801780 <fd2data>
  8019b3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8019b5:	89 1c 24             	mov    %ebx,(%esp)
  8019b8:	e8 c3 fd ff ff       	call   801780 <fd2data>
  8019bd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019bf:	89 f0                	mov    %esi,%eax
  8019c1:	c1 e8 16             	shr    $0x16,%eax
  8019c4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019cb:	a8 01                	test   $0x1,%al
  8019cd:	74 43                	je     801a12 <dup+0xa6>
  8019cf:	89 f0                	mov    %esi,%eax
  8019d1:	c1 e8 0c             	shr    $0xc,%eax
  8019d4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019db:	f6 c2 01             	test   $0x1,%dl
  8019de:	74 32                	je     801a12 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8019ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019fb:	00 
  8019fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a07:	e8 8b f9 ff ff       	call   801397 <sys_page_map>
  801a0c:	89 c6                	mov    %eax,%esi
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 3e                	js     801a50 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a15:	89 c2                	mov    %eax,%edx
  801a17:	c1 ea 0c             	shr    $0xc,%edx
  801a1a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a21:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a27:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a36:	00 
  801a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a42:	e8 50 f9 ff ff       	call   801397 <sys_page_map>
  801a47:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801a49:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a4c:	85 f6                	test   %esi,%esi
  801a4e:	79 22                	jns    801a72 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a50:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a5b:	e8 8a f9 ff ff       	call   8013ea <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a60:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a6b:	e8 7a f9 ff ff       	call   8013ea <sys_page_unmap>
	return r;
  801a70:	89 f0                	mov    %esi,%eax
}
  801a72:	83 c4 3c             	add    $0x3c,%esp
  801a75:	5b                   	pop    %ebx
  801a76:	5e                   	pop    %esi
  801a77:	5f                   	pop    %edi
  801a78:	5d                   	pop    %ebp
  801a79:	c3                   	ret    

00801a7a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	53                   	push   %ebx
  801a7e:	83 ec 24             	sub    $0x24,%esp
  801a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a84:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8b:	89 1c 24             	mov    %ebx,(%esp)
  801a8e:	e8 53 fd ff ff       	call   8017e6 <fd_lookup>
  801a93:	89 c2                	mov    %eax,%edx
  801a95:	85 d2                	test   %edx,%edx
  801a97:	78 6d                	js     801b06 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa3:	8b 00                	mov    (%eax),%eax
  801aa5:	89 04 24             	mov    %eax,(%esp)
  801aa8:	e8 8f fd ff ff       	call   80183c <dev_lookup>
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 55                	js     801b06 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab4:	8b 50 08             	mov    0x8(%eax),%edx
  801ab7:	83 e2 03             	and    $0x3,%edx
  801aba:	83 fa 01             	cmp    $0x1,%edx
  801abd:	75 23                	jne    801ae2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801abf:	a1 08 50 80 00       	mov    0x805008,%eax
  801ac4:	8b 40 48             	mov    0x48(%eax),%eax
  801ac7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acf:	c7 04 24 70 34 80 00 	movl   $0x803470,(%esp)
  801ad6:	e8 21 ee ff ff       	call   8008fc <cprintf>
		return -E_INVAL;
  801adb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ae0:	eb 24                	jmp    801b06 <read+0x8c>
	}
	if (!dev->dev_read)
  801ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae5:	8b 52 08             	mov    0x8(%edx),%edx
  801ae8:	85 d2                	test   %edx,%edx
  801aea:	74 15                	je     801b01 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801aec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801af3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801af6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801afa:	89 04 24             	mov    %eax,(%esp)
  801afd:	ff d2                	call   *%edx
  801aff:	eb 05                	jmp    801b06 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801b01:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801b06:	83 c4 24             	add    $0x24,%esp
  801b09:	5b                   	pop    %ebx
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    

00801b0c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	57                   	push   %edi
  801b10:	56                   	push   %esi
  801b11:	53                   	push   %ebx
  801b12:	83 ec 1c             	sub    $0x1c,%esp
  801b15:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b18:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b20:	eb 23                	jmp    801b45 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b22:	89 f0                	mov    %esi,%eax
  801b24:	29 d8                	sub    %ebx,%eax
  801b26:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b2a:	89 d8                	mov    %ebx,%eax
  801b2c:	03 45 0c             	add    0xc(%ebp),%eax
  801b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b33:	89 3c 24             	mov    %edi,(%esp)
  801b36:	e8 3f ff ff ff       	call   801a7a <read>
		if (m < 0)
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	78 10                	js     801b4f <readn+0x43>
			return m;
		if (m == 0)
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	74 0a                	je     801b4d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b43:	01 c3                	add    %eax,%ebx
  801b45:	39 f3                	cmp    %esi,%ebx
  801b47:	72 d9                	jb     801b22 <readn+0x16>
  801b49:	89 d8                	mov    %ebx,%eax
  801b4b:	eb 02                	jmp    801b4f <readn+0x43>
  801b4d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b4f:	83 c4 1c             	add    $0x1c,%esp
  801b52:	5b                   	pop    %ebx
  801b53:	5e                   	pop    %esi
  801b54:	5f                   	pop    %edi
  801b55:	5d                   	pop    %ebp
  801b56:	c3                   	ret    

00801b57 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	53                   	push   %ebx
  801b5b:	83 ec 24             	sub    $0x24,%esp
  801b5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b61:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b68:	89 1c 24             	mov    %ebx,(%esp)
  801b6b:	e8 76 fc ff ff       	call   8017e6 <fd_lookup>
  801b70:	89 c2                	mov    %eax,%edx
  801b72:	85 d2                	test   %edx,%edx
  801b74:	78 68                	js     801bde <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b80:	8b 00                	mov    (%eax),%eax
  801b82:	89 04 24             	mov    %eax,(%esp)
  801b85:	e8 b2 fc ff ff       	call   80183c <dev_lookup>
  801b8a:	85 c0                	test   %eax,%eax
  801b8c:	78 50                	js     801bde <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b91:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b95:	75 23                	jne    801bba <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b97:	a1 08 50 80 00       	mov    0x805008,%eax
  801b9c:	8b 40 48             	mov    0x48(%eax),%eax
  801b9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba7:	c7 04 24 8c 34 80 00 	movl   $0x80348c,(%esp)
  801bae:	e8 49 ed ff ff       	call   8008fc <cprintf>
		return -E_INVAL;
  801bb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bb8:	eb 24                	jmp    801bde <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bbd:	8b 52 0c             	mov    0xc(%edx),%edx
  801bc0:	85 d2                	test   %edx,%edx
  801bc2:	74 15                	je     801bd9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bd2:	89 04 24             	mov    %eax,(%esp)
  801bd5:	ff d2                	call   *%edx
  801bd7:	eb 05                	jmp    801bde <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801bd9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801bde:	83 c4 24             	add    $0x24,%esp
  801be1:	5b                   	pop    %ebx
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    

00801be4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bea:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801bed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	89 04 24             	mov    %eax,(%esp)
  801bf7:	e8 ea fb ff ff       	call   8017e6 <fd_lookup>
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	78 0e                	js     801c0e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c06:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	53                   	push   %ebx
  801c14:	83 ec 24             	sub    $0x24,%esp
  801c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c21:	89 1c 24             	mov    %ebx,(%esp)
  801c24:	e8 bd fb ff ff       	call   8017e6 <fd_lookup>
  801c29:	89 c2                	mov    %eax,%edx
  801c2b:	85 d2                	test   %edx,%edx
  801c2d:	78 61                	js     801c90 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c39:	8b 00                	mov    (%eax),%eax
  801c3b:	89 04 24             	mov    %eax,(%esp)
  801c3e:	e8 f9 fb ff ff       	call   80183c <dev_lookup>
  801c43:	85 c0                	test   %eax,%eax
  801c45:	78 49                	js     801c90 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c4e:	75 23                	jne    801c73 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801c50:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c55:	8b 40 48             	mov    0x48(%eax),%eax
  801c58:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c60:	c7 04 24 4c 34 80 00 	movl   $0x80344c,(%esp)
  801c67:	e8 90 ec ff ff       	call   8008fc <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801c6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c71:	eb 1d                	jmp    801c90 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c76:	8b 52 18             	mov    0x18(%edx),%edx
  801c79:	85 d2                	test   %edx,%edx
  801c7b:	74 0e                	je     801c8b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c80:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c84:	89 04 24             	mov    %eax,(%esp)
  801c87:	ff d2                	call   *%edx
  801c89:	eb 05                	jmp    801c90 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801c8b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801c90:	83 c4 24             	add    $0x24,%esp
  801c93:	5b                   	pop    %ebx
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    

00801c96 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	53                   	push   %ebx
  801c9a:	83 ec 24             	sub    $0x24,%esp
  801c9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ca0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	89 04 24             	mov    %eax,(%esp)
  801cad:	e8 34 fb ff ff       	call   8017e6 <fd_lookup>
  801cb2:	89 c2                	mov    %eax,%edx
  801cb4:	85 d2                	test   %edx,%edx
  801cb6:	78 52                	js     801d0a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc2:	8b 00                	mov    (%eax),%eax
  801cc4:	89 04 24             	mov    %eax,(%esp)
  801cc7:	e8 70 fb ff ff       	call   80183c <dev_lookup>
  801ccc:	85 c0                	test   %eax,%eax
  801cce:	78 3a                	js     801d0a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cd7:	74 2c                	je     801d05 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cd9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cdc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ce3:	00 00 00 
	stat->st_isdir = 0;
  801ce6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ced:	00 00 00 
	stat->st_dev = dev;
  801cf0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cf6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cfa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cfd:	89 14 24             	mov    %edx,(%esp)
  801d00:	ff 50 14             	call   *0x14(%eax)
  801d03:	eb 05                	jmp    801d0a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801d05:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801d0a:	83 c4 24             	add    $0x24,%esp
  801d0d:	5b                   	pop    %ebx
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    

00801d10 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	56                   	push   %esi
  801d14:	53                   	push   %ebx
  801d15:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d1f:	00 
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	89 04 24             	mov    %eax,(%esp)
  801d26:	e8 28 02 00 00       	call   801f53 <open>
  801d2b:	89 c3                	mov    %eax,%ebx
  801d2d:	85 db                	test   %ebx,%ebx
  801d2f:	78 1b                	js     801d4c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d38:	89 1c 24             	mov    %ebx,(%esp)
  801d3b:	e8 56 ff ff ff       	call   801c96 <fstat>
  801d40:	89 c6                	mov    %eax,%esi
	close(fd);
  801d42:	89 1c 24             	mov    %ebx,(%esp)
  801d45:	e8 cd fb ff ff       	call   801917 <close>
	return r;
  801d4a:	89 f0                	mov    %esi,%eax
}
  801d4c:	83 c4 10             	add    $0x10,%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5d                   	pop    %ebp
  801d52:	c3                   	ret    

00801d53 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	56                   	push   %esi
  801d57:	53                   	push   %ebx
  801d58:	83 ec 10             	sub    $0x10,%esp
  801d5b:	89 c6                	mov    %eax,%esi
  801d5d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d5f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d66:	75 11                	jne    801d79 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d6f:	e8 c4 f9 ff ff       	call   801738 <ipc_find_env>
  801d74:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d79:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d80:	00 
  801d81:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d88:	00 
  801d89:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d8d:	a1 00 50 80 00       	mov    0x805000,%eax
  801d92:	89 04 24             	mov    %eax,(%esp)
  801d95:	e8 40 f9 ff ff       	call   8016da <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801da1:	00 
  801da2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801da6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dad:	e8 be f8 ff ff       	call   801670 <ipc_recv>
}
  801db2:	83 c4 10             	add    $0x10,%esp
  801db5:	5b                   	pop    %ebx
  801db6:	5e                   	pop    %esi
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    

00801db9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801dd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd7:	b8 02 00 00 00       	mov    $0x2,%eax
  801ddc:	e8 72 ff ff ff       	call   801d53 <fsipc>
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	8b 40 0c             	mov    0xc(%eax),%eax
  801def:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801df4:	ba 00 00 00 00       	mov    $0x0,%edx
  801df9:	b8 06 00 00 00       	mov    $0x6,%eax
  801dfe:	e8 50 ff ff ff       	call   801d53 <fsipc>
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	53                   	push   %ebx
  801e09:	83 ec 14             	sub    $0x14,%esp
  801e0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	8b 40 0c             	mov    0xc(%eax),%eax
  801e15:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1f:	b8 05 00 00 00       	mov    $0x5,%eax
  801e24:	e8 2a ff ff ff       	call   801d53 <fsipc>
  801e29:	89 c2                	mov    %eax,%edx
  801e2b:	85 d2                	test   %edx,%edx
  801e2d:	78 2b                	js     801e5a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e2f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e36:	00 
  801e37:	89 1c 24             	mov    %ebx,(%esp)
  801e3a:	e8 e8 f0 ff ff       	call   800f27 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e3f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e44:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e4a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e4f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5a:	83 c4 14             	add    $0x14,%esp
  801e5d:	5b                   	pop    %ebx
  801e5e:	5d                   	pop    %ebp
  801e5f:	c3                   	ret    

00801e60 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 18             	sub    $0x18,%esp
  801e66:	8b 45 10             	mov    0x10(%ebp),%eax
  801e69:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801e6e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801e73:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801e76:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e7e:	8b 52 0c             	mov    0xc(%edx),%edx
  801e81:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801e87:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e92:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801e99:	e8 26 f2 ff ff       	call   8010c4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801e9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea3:	b8 04 00 00 00       	mov    $0x4,%eax
  801ea8:	e8 a6 fe ff ff       	call   801d53 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	56                   	push   %esi
  801eb3:	53                   	push   %ebx
  801eb4:	83 ec 10             	sub    $0x10,%esp
  801eb7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ec5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ecb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed0:	b8 03 00 00 00       	mov    $0x3,%eax
  801ed5:	e8 79 fe ff ff       	call   801d53 <fsipc>
  801eda:	89 c3                	mov    %eax,%ebx
  801edc:	85 c0                	test   %eax,%eax
  801ede:	78 6a                	js     801f4a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ee0:	39 c6                	cmp    %eax,%esi
  801ee2:	73 24                	jae    801f08 <devfile_read+0x59>
  801ee4:	c7 44 24 0c c0 34 80 	movl   $0x8034c0,0xc(%esp)
  801eeb:	00 
  801eec:	c7 44 24 08 c7 34 80 	movl   $0x8034c7,0x8(%esp)
  801ef3:	00 
  801ef4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801efb:	00 
  801efc:	c7 04 24 dc 34 80 00 	movl   $0x8034dc,(%esp)
  801f03:	e8 fb e8 ff ff       	call   800803 <_panic>
	assert(r <= PGSIZE);
  801f08:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f0d:	7e 24                	jle    801f33 <devfile_read+0x84>
  801f0f:	c7 44 24 0c e7 34 80 	movl   $0x8034e7,0xc(%esp)
  801f16:	00 
  801f17:	c7 44 24 08 c7 34 80 	movl   $0x8034c7,0x8(%esp)
  801f1e:	00 
  801f1f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801f26:	00 
  801f27:	c7 04 24 dc 34 80 00 	movl   $0x8034dc,(%esp)
  801f2e:	e8 d0 e8 ff ff       	call   800803 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f33:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f37:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f3e:	00 
  801f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f42:	89 04 24             	mov    %eax,(%esp)
  801f45:	e8 7a f1 ff ff       	call   8010c4 <memmove>
	return r;
}
  801f4a:	89 d8                	mov    %ebx,%eax
  801f4c:	83 c4 10             	add    $0x10,%esp
  801f4f:	5b                   	pop    %ebx
  801f50:	5e                   	pop    %esi
  801f51:	5d                   	pop    %ebp
  801f52:	c3                   	ret    

00801f53 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	53                   	push   %ebx
  801f57:	83 ec 24             	sub    $0x24,%esp
  801f5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801f5d:	89 1c 24             	mov    %ebx,(%esp)
  801f60:	e8 8b ef ff ff       	call   800ef0 <strlen>
  801f65:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f6a:	7f 60                	jg     801fcc <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801f6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6f:	89 04 24             	mov    %eax,(%esp)
  801f72:	e8 20 f8 ff ff       	call   801797 <fd_alloc>
  801f77:	89 c2                	mov    %eax,%edx
  801f79:	85 d2                	test   %edx,%edx
  801f7b:	78 54                	js     801fd1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801f7d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f81:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801f88:	e8 9a ef ff ff       	call   800f27 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f90:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f98:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9d:	e8 b1 fd ff ff       	call   801d53 <fsipc>
  801fa2:	89 c3                	mov    %eax,%ebx
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	79 17                	jns    801fbf <open+0x6c>
		fd_close(fd, 0);
  801fa8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801faf:	00 
  801fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb3:	89 04 24             	mov    %eax,(%esp)
  801fb6:	e8 db f8 ff ff       	call   801896 <fd_close>
		return r;
  801fbb:	89 d8                	mov    %ebx,%eax
  801fbd:	eb 12                	jmp    801fd1 <open+0x7e>
	}

	return fd2num(fd);
  801fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc2:	89 04 24             	mov    %eax,(%esp)
  801fc5:	e8 a6 f7 ff ff       	call   801770 <fd2num>
  801fca:	eb 05                	jmp    801fd1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801fcc:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801fd1:	83 c4 24             	add    $0x24,%esp
  801fd4:	5b                   	pop    %ebx
  801fd5:	5d                   	pop    %ebp
  801fd6:	c3                   	ret    

00801fd7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fdd:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe2:	b8 08 00 00 00       	mov    $0x8,%eax
  801fe7:	e8 67 fd ff ff       	call   801d53 <fsipc>
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    
  801fee:	66 90                	xchg   %ax,%ax

00801ff0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ff6:	c7 44 24 04 f3 34 80 	movl   $0x8034f3,0x4(%esp)
  801ffd:	00 
  801ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802001:	89 04 24             	mov    %eax,(%esp)
  802004:	e8 1e ef ff ff       	call   800f27 <strcpy>
	return 0;
}
  802009:	b8 00 00 00 00       	mov    $0x0,%eax
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	53                   	push   %ebx
  802014:	83 ec 14             	sub    $0x14,%esp
  802017:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80201a:	89 1c 24             	mov    %ebx,(%esp)
  80201d:	e8 04 0a 00 00       	call   802a26 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802022:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802027:	83 f8 01             	cmp    $0x1,%eax
  80202a:	75 0d                	jne    802039 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80202c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80202f:	89 04 24             	mov    %eax,(%esp)
  802032:	e8 29 03 00 00       	call   802360 <nsipc_close>
  802037:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802039:	89 d0                	mov    %edx,%eax
  80203b:	83 c4 14             	add    $0x14,%esp
  80203e:	5b                   	pop    %ebx
  80203f:	5d                   	pop    %ebp
  802040:	c3                   	ret    

00802041 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802047:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80204e:	00 
  80204f:	8b 45 10             	mov    0x10(%ebp),%eax
  802052:	89 44 24 08          	mov    %eax,0x8(%esp)
  802056:	8b 45 0c             	mov    0xc(%ebp),%eax
  802059:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	8b 40 0c             	mov    0xc(%eax),%eax
  802063:	89 04 24             	mov    %eax,(%esp)
  802066:	e8 f0 03 00 00       	call   80245b <nsipc_send>
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802073:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80207a:	00 
  80207b:	8b 45 10             	mov    0x10(%ebp),%eax
  80207e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802082:	8b 45 0c             	mov    0xc(%ebp),%eax
  802085:	89 44 24 04          	mov    %eax,0x4(%esp)
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	8b 40 0c             	mov    0xc(%eax),%eax
  80208f:	89 04 24             	mov    %eax,(%esp)
  802092:	e8 44 03 00 00       	call   8023db <nsipc_recv>
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80209f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020a6:	89 04 24             	mov    %eax,(%esp)
  8020a9:	e8 38 f7 ff ff       	call   8017e6 <fd_lookup>
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	78 17                	js     8020c9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b5:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  8020bb:	39 08                	cmp    %ecx,(%eax)
  8020bd:	75 05                	jne    8020c4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8020bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c2:	eb 05                	jmp    8020c9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8020c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	56                   	push   %esi
  8020cf:	53                   	push   %ebx
  8020d0:	83 ec 20             	sub    $0x20,%esp
  8020d3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8020d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d8:	89 04 24             	mov    %eax,(%esp)
  8020db:	e8 b7 f6 ff ff       	call   801797 <fd_alloc>
  8020e0:	89 c3                	mov    %eax,%ebx
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	78 21                	js     802107 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020e6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020ed:	00 
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020fc:	e8 42 f2 ff ff       	call   801343 <sys_page_alloc>
  802101:	89 c3                	mov    %eax,%ebx
  802103:	85 c0                	test   %eax,%eax
  802105:	79 0c                	jns    802113 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802107:	89 34 24             	mov    %esi,(%esp)
  80210a:	e8 51 02 00 00       	call   802360 <nsipc_close>
		return r;
  80210f:	89 d8                	mov    %ebx,%eax
  802111:	eb 20                	jmp    802133 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802113:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80211e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802121:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802128:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80212b:	89 14 24             	mov    %edx,(%esp)
  80212e:	e8 3d f6 ff ff       	call   801770 <fd2num>
}
  802133:	83 c4 20             	add    $0x20,%esp
  802136:	5b                   	pop    %ebx
  802137:	5e                   	pop    %esi
  802138:	5d                   	pop    %ebp
  802139:	c3                   	ret    

0080213a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	e8 51 ff ff ff       	call   802099 <fd2sockid>
		return r;
  802148:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80214a:	85 c0                	test   %eax,%eax
  80214c:	78 23                	js     802171 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80214e:	8b 55 10             	mov    0x10(%ebp),%edx
  802151:	89 54 24 08          	mov    %edx,0x8(%esp)
  802155:	8b 55 0c             	mov    0xc(%ebp),%edx
  802158:	89 54 24 04          	mov    %edx,0x4(%esp)
  80215c:	89 04 24             	mov    %eax,(%esp)
  80215f:	e8 45 01 00 00       	call   8022a9 <nsipc_accept>
		return r;
  802164:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802166:	85 c0                	test   %eax,%eax
  802168:	78 07                	js     802171 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80216a:	e8 5c ff ff ff       	call   8020cb <alloc_sockfd>
  80216f:	89 c1                	mov    %eax,%ecx
}
  802171:	89 c8                	mov    %ecx,%eax
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	e8 16 ff ff ff       	call   802099 <fd2sockid>
  802183:	89 c2                	mov    %eax,%edx
  802185:	85 d2                	test   %edx,%edx
  802187:	78 16                	js     80219f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802189:	8b 45 10             	mov    0x10(%ebp),%eax
  80218c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802190:	8b 45 0c             	mov    0xc(%ebp),%eax
  802193:	89 44 24 04          	mov    %eax,0x4(%esp)
  802197:	89 14 24             	mov    %edx,(%esp)
  80219a:	e8 60 01 00 00       	call   8022ff <nsipc_bind>
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <shutdown>:

int
shutdown(int s, int how)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	e8 ea fe ff ff       	call   802099 <fd2sockid>
  8021af:	89 c2                	mov    %eax,%edx
  8021b1:	85 d2                	test   %edx,%edx
  8021b3:	78 0f                	js     8021c4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8021b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021bc:	89 14 24             	mov    %edx,(%esp)
  8021bf:	e8 7a 01 00 00       	call   80233e <nsipc_shutdown>
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	e8 c5 fe ff ff       	call   802099 <fd2sockid>
  8021d4:	89 c2                	mov    %eax,%edx
  8021d6:	85 d2                	test   %edx,%edx
  8021d8:	78 16                	js     8021f0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8021da:	8b 45 10             	mov    0x10(%ebp),%eax
  8021dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e8:	89 14 24             	mov    %edx,(%esp)
  8021eb:	e8 8a 01 00 00       	call   80237a <nsipc_connect>
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <listen>:

int
listen(int s, int backlog)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
  8021f5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	e8 99 fe ff ff       	call   802099 <fd2sockid>
  802200:	89 c2                	mov    %eax,%edx
  802202:	85 d2                	test   %edx,%edx
  802204:	78 0f                	js     802215 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802206:	8b 45 0c             	mov    0xc(%ebp),%eax
  802209:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220d:	89 14 24             	mov    %edx,(%esp)
  802210:	e8 a4 01 00 00       	call   8023b9 <nsipc_listen>
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80221d:	8b 45 10             	mov    0x10(%ebp),%eax
  802220:	89 44 24 08          	mov    %eax,0x8(%esp)
  802224:	8b 45 0c             	mov    0xc(%ebp),%eax
  802227:	89 44 24 04          	mov    %eax,0x4(%esp)
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	89 04 24             	mov    %eax,(%esp)
  802231:	e8 98 02 00 00       	call   8024ce <nsipc_socket>
  802236:	89 c2                	mov    %eax,%edx
  802238:	85 d2                	test   %edx,%edx
  80223a:	78 05                	js     802241 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80223c:	e8 8a fe ff ff       	call   8020cb <alloc_sockfd>
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	53                   	push   %ebx
  802247:	83 ec 14             	sub    $0x14,%esp
  80224a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80224c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802253:	75 11                	jne    802266 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802255:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80225c:	e8 d7 f4 ff ff       	call   801738 <ipc_find_env>
  802261:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802266:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80226d:	00 
  80226e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802275:	00 
  802276:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80227a:	a1 04 50 80 00       	mov    0x805004,%eax
  80227f:	89 04 24             	mov    %eax,(%esp)
  802282:	e8 53 f4 ff ff       	call   8016da <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802287:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80228e:	00 
  80228f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802296:	00 
  802297:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80229e:	e8 cd f3 ff ff       	call   801670 <ipc_recv>
}
  8022a3:	83 c4 14             	add    $0x14,%esp
  8022a6:	5b                   	pop    %ebx
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    

008022a9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	56                   	push   %esi
  8022ad:	53                   	push   %ebx
  8022ae:	83 ec 10             	sub    $0x10,%esp
  8022b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022bc:	8b 06                	mov    (%esi),%eax
  8022be:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c8:	e8 76 ff ff ff       	call   802243 <nsipc>
  8022cd:	89 c3                	mov    %eax,%ebx
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	78 23                	js     8022f6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022d3:	a1 10 70 80 00       	mov    0x807010,%eax
  8022d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022dc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022e3:	00 
  8022e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e7:	89 04 24             	mov    %eax,(%esp)
  8022ea:	e8 d5 ed ff ff       	call   8010c4 <memmove>
		*addrlen = ret->ret_addrlen;
  8022ef:	a1 10 70 80 00       	mov    0x807010,%eax
  8022f4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8022f6:	89 d8                	mov    %ebx,%eax
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	5b                   	pop    %ebx
  8022fc:	5e                   	pop    %esi
  8022fd:	5d                   	pop    %ebp
  8022fe:	c3                   	ret    

008022ff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	53                   	push   %ebx
  802303:	83 ec 14             	sub    $0x14,%esp
  802306:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802311:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802315:	8b 45 0c             	mov    0xc(%ebp),%eax
  802318:	89 44 24 04          	mov    %eax,0x4(%esp)
  80231c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802323:	e8 9c ed ff ff       	call   8010c4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802328:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80232e:	b8 02 00 00 00       	mov    $0x2,%eax
  802333:	e8 0b ff ff ff       	call   802243 <nsipc>
}
  802338:	83 c4 14             	add    $0x14,%esp
  80233b:	5b                   	pop    %ebx
  80233c:	5d                   	pop    %ebp
  80233d:	c3                   	ret    

0080233e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80234c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802354:	b8 03 00 00 00       	mov    $0x3,%eax
  802359:	e8 e5 fe ff ff       	call   802243 <nsipc>
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <nsipc_close>:

int
nsipc_close(int s)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80236e:	b8 04 00 00 00       	mov    $0x4,%eax
  802373:	e8 cb fe ff ff       	call   802243 <nsipc>
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	53                   	push   %ebx
  80237e:	83 ec 14             	sub    $0x14,%esp
  802381:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80238c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802390:	8b 45 0c             	mov    0xc(%ebp),%eax
  802393:	89 44 24 04          	mov    %eax,0x4(%esp)
  802397:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80239e:	e8 21 ed ff ff       	call   8010c4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023a3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023a9:	b8 05 00 00 00       	mov    $0x5,%eax
  8023ae:	e8 90 fe ff ff       	call   802243 <nsipc>
}
  8023b3:	83 c4 14             	add    $0x14,%esp
  8023b6:	5b                   	pop    %ebx
  8023b7:	5d                   	pop    %ebp
  8023b8:	c3                   	ret    

008023b9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ca:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023cf:	b8 06 00 00 00       	mov    $0x6,%eax
  8023d4:	e8 6a fe ff ff       	call   802243 <nsipc>
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	56                   	push   %esi
  8023df:	53                   	push   %ebx
  8023e0:	83 ec 10             	sub    $0x10,%esp
  8023e3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023ee:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023fc:	b8 07 00 00 00       	mov    $0x7,%eax
  802401:	e8 3d fe ff ff       	call   802243 <nsipc>
  802406:	89 c3                	mov    %eax,%ebx
  802408:	85 c0                	test   %eax,%eax
  80240a:	78 46                	js     802452 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80240c:	39 f0                	cmp    %esi,%eax
  80240e:	7f 07                	jg     802417 <nsipc_recv+0x3c>
  802410:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802415:	7e 24                	jle    80243b <nsipc_recv+0x60>
  802417:	c7 44 24 0c ff 34 80 	movl   $0x8034ff,0xc(%esp)
  80241e:	00 
  80241f:	c7 44 24 08 c7 34 80 	movl   $0x8034c7,0x8(%esp)
  802426:	00 
  802427:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80242e:	00 
  80242f:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  802436:	e8 c8 e3 ff ff       	call   800803 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80243b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80243f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802446:	00 
  802447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244a:	89 04 24             	mov    %eax,(%esp)
  80244d:	e8 72 ec ff ff       	call   8010c4 <memmove>
	}

	return r;
}
  802452:	89 d8                	mov    %ebx,%eax
  802454:	83 c4 10             	add    $0x10,%esp
  802457:	5b                   	pop    %ebx
  802458:	5e                   	pop    %esi
  802459:	5d                   	pop    %ebp
  80245a:	c3                   	ret    

0080245b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	53                   	push   %ebx
  80245f:	83 ec 14             	sub    $0x14,%esp
  802462:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80246d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802473:	7e 24                	jle    802499 <nsipc_send+0x3e>
  802475:	c7 44 24 0c 20 35 80 	movl   $0x803520,0xc(%esp)
  80247c:	00 
  80247d:	c7 44 24 08 c7 34 80 	movl   $0x8034c7,0x8(%esp)
  802484:	00 
  802485:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80248c:	00 
  80248d:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  802494:	e8 6a e3 ff ff       	call   800803 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802499:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80249d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8024ab:	e8 14 ec ff ff       	call   8010c4 <memmove>
	nsipcbuf.send.req_size = size;
  8024b0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8024b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8024b9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8024be:	b8 08 00 00 00       	mov    $0x8,%eax
  8024c3:	e8 7b fd ff ff       	call   802243 <nsipc>
}
  8024c8:	83 c4 14             	add    $0x14,%esp
  8024cb:	5b                   	pop    %ebx
  8024cc:	5d                   	pop    %ebp
  8024cd:	c3                   	ret    

008024ce <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024df:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024ec:	b8 09 00 00 00       	mov    $0x9,%eax
  8024f1:	e8 4d fd ff ff       	call   802243 <nsipc>
}
  8024f6:	c9                   	leave  
  8024f7:	c3                   	ret    

008024f8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	56                   	push   %esi
  8024fc:	53                   	push   %ebx
  8024fd:	83 ec 10             	sub    $0x10,%esp
  802500:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	89 04 24             	mov    %eax,(%esp)
  802509:	e8 72 f2 ff ff       	call   801780 <fd2data>
  80250e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802510:	c7 44 24 04 2c 35 80 	movl   $0x80352c,0x4(%esp)
  802517:	00 
  802518:	89 1c 24             	mov    %ebx,(%esp)
  80251b:	e8 07 ea ff ff       	call   800f27 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802520:	8b 46 04             	mov    0x4(%esi),%eax
  802523:	2b 06                	sub    (%esi),%eax
  802525:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80252b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802532:	00 00 00 
	stat->st_dev = &devpipe;
  802535:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80253c:	40 80 00 
	return 0;
}
  80253f:	b8 00 00 00 00       	mov    $0x0,%eax
  802544:	83 c4 10             	add    $0x10,%esp
  802547:	5b                   	pop    %ebx
  802548:	5e                   	pop    %esi
  802549:	5d                   	pop    %ebp
  80254a:	c3                   	ret    

0080254b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
  80254e:	53                   	push   %ebx
  80254f:	83 ec 14             	sub    $0x14,%esp
  802552:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802555:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802559:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802560:	e8 85 ee ff ff       	call   8013ea <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802565:	89 1c 24             	mov    %ebx,(%esp)
  802568:	e8 13 f2 ff ff       	call   801780 <fd2data>
  80256d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802571:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802578:	e8 6d ee ff ff       	call   8013ea <sys_page_unmap>
}
  80257d:	83 c4 14             	add    $0x14,%esp
  802580:	5b                   	pop    %ebx
  802581:	5d                   	pop    %ebp
  802582:	c3                   	ret    

00802583 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
  802586:	57                   	push   %edi
  802587:	56                   	push   %esi
  802588:	53                   	push   %ebx
  802589:	83 ec 2c             	sub    $0x2c,%esp
  80258c:	89 c6                	mov    %eax,%esi
  80258e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802591:	a1 08 50 80 00       	mov    0x805008,%eax
  802596:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802599:	89 34 24             	mov    %esi,(%esp)
  80259c:	e8 85 04 00 00       	call   802a26 <pageref>
  8025a1:	89 c7                	mov    %eax,%edi
  8025a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a6:	89 04 24             	mov    %eax,(%esp)
  8025a9:	e8 78 04 00 00       	call   802a26 <pageref>
  8025ae:	39 c7                	cmp    %eax,%edi
  8025b0:	0f 94 c2             	sete   %dl
  8025b3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8025b6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8025bc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8025bf:	39 fb                	cmp    %edi,%ebx
  8025c1:	74 21                	je     8025e4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8025c3:	84 d2                	test   %dl,%dl
  8025c5:	74 ca                	je     802591 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8025c7:	8b 51 58             	mov    0x58(%ecx),%edx
  8025ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025ce:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025d6:	c7 04 24 33 35 80 00 	movl   $0x803533,(%esp)
  8025dd:	e8 1a e3 ff ff       	call   8008fc <cprintf>
  8025e2:	eb ad                	jmp    802591 <_pipeisclosed+0xe>
	}
}
  8025e4:	83 c4 2c             	add    $0x2c,%esp
  8025e7:	5b                   	pop    %ebx
  8025e8:	5e                   	pop    %esi
  8025e9:	5f                   	pop    %edi
  8025ea:	5d                   	pop    %ebp
  8025eb:	c3                   	ret    

008025ec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	57                   	push   %edi
  8025f0:	56                   	push   %esi
  8025f1:	53                   	push   %ebx
  8025f2:	83 ec 1c             	sub    $0x1c,%esp
  8025f5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8025f8:	89 34 24             	mov    %esi,(%esp)
  8025fb:	e8 80 f1 ff ff       	call   801780 <fd2data>
  802600:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802602:	bf 00 00 00 00       	mov    $0x0,%edi
  802607:	eb 45                	jmp    80264e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802609:	89 da                	mov    %ebx,%edx
  80260b:	89 f0                	mov    %esi,%eax
  80260d:	e8 71 ff ff ff       	call   802583 <_pipeisclosed>
  802612:	85 c0                	test   %eax,%eax
  802614:	75 41                	jne    802657 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802616:	e8 09 ed ff ff       	call   801324 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80261b:	8b 43 04             	mov    0x4(%ebx),%eax
  80261e:	8b 0b                	mov    (%ebx),%ecx
  802620:	8d 51 20             	lea    0x20(%ecx),%edx
  802623:	39 d0                	cmp    %edx,%eax
  802625:	73 e2                	jae    802609 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802627:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80262a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80262e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802631:	99                   	cltd   
  802632:	c1 ea 1b             	shr    $0x1b,%edx
  802635:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802638:	83 e1 1f             	and    $0x1f,%ecx
  80263b:	29 d1                	sub    %edx,%ecx
  80263d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802641:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802645:	83 c0 01             	add    $0x1,%eax
  802648:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80264b:	83 c7 01             	add    $0x1,%edi
  80264e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802651:	75 c8                	jne    80261b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802653:	89 f8                	mov    %edi,%eax
  802655:	eb 05                	jmp    80265c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80265c:	83 c4 1c             	add    $0x1c,%esp
  80265f:	5b                   	pop    %ebx
  802660:	5e                   	pop    %esi
  802661:	5f                   	pop    %edi
  802662:	5d                   	pop    %ebp
  802663:	c3                   	ret    

00802664 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
  802667:	57                   	push   %edi
  802668:	56                   	push   %esi
  802669:	53                   	push   %ebx
  80266a:	83 ec 1c             	sub    $0x1c,%esp
  80266d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802670:	89 3c 24             	mov    %edi,(%esp)
  802673:	e8 08 f1 ff ff       	call   801780 <fd2data>
  802678:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80267a:	be 00 00 00 00       	mov    $0x0,%esi
  80267f:	eb 3d                	jmp    8026be <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802681:	85 f6                	test   %esi,%esi
  802683:	74 04                	je     802689 <devpipe_read+0x25>
				return i;
  802685:	89 f0                	mov    %esi,%eax
  802687:	eb 43                	jmp    8026cc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802689:	89 da                	mov    %ebx,%edx
  80268b:	89 f8                	mov    %edi,%eax
  80268d:	e8 f1 fe ff ff       	call   802583 <_pipeisclosed>
  802692:	85 c0                	test   %eax,%eax
  802694:	75 31                	jne    8026c7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802696:	e8 89 ec ff ff       	call   801324 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80269b:	8b 03                	mov    (%ebx),%eax
  80269d:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026a0:	74 df                	je     802681 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026a2:	99                   	cltd   
  8026a3:	c1 ea 1b             	shr    $0x1b,%edx
  8026a6:	01 d0                	add    %edx,%eax
  8026a8:	83 e0 1f             	and    $0x1f,%eax
  8026ab:	29 d0                	sub    %edx,%eax
  8026ad:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026b5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8026b8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026bb:	83 c6 01             	add    $0x1,%esi
  8026be:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026c1:	75 d8                	jne    80269b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8026c3:	89 f0                	mov    %esi,%eax
  8026c5:	eb 05                	jmp    8026cc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8026cc:	83 c4 1c             	add    $0x1c,%esp
  8026cf:	5b                   	pop    %ebx
  8026d0:	5e                   	pop    %esi
  8026d1:	5f                   	pop    %edi
  8026d2:	5d                   	pop    %ebp
  8026d3:	c3                   	ret    

008026d4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	56                   	push   %esi
  8026d8:	53                   	push   %ebx
  8026d9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026df:	89 04 24             	mov    %eax,(%esp)
  8026e2:	e8 b0 f0 ff ff       	call   801797 <fd_alloc>
  8026e7:	89 c2                	mov    %eax,%edx
  8026e9:	85 d2                	test   %edx,%edx
  8026eb:	0f 88 4d 01 00 00    	js     80283e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026f1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026f8:	00 
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802700:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802707:	e8 37 ec ff ff       	call   801343 <sys_page_alloc>
  80270c:	89 c2                	mov    %eax,%edx
  80270e:	85 d2                	test   %edx,%edx
  802710:	0f 88 28 01 00 00    	js     80283e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802716:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802719:	89 04 24             	mov    %eax,(%esp)
  80271c:	e8 76 f0 ff ff       	call   801797 <fd_alloc>
  802721:	89 c3                	mov    %eax,%ebx
  802723:	85 c0                	test   %eax,%eax
  802725:	0f 88 fe 00 00 00    	js     802829 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80272b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802732:	00 
  802733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802736:	89 44 24 04          	mov    %eax,0x4(%esp)
  80273a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802741:	e8 fd eb ff ff       	call   801343 <sys_page_alloc>
  802746:	89 c3                	mov    %eax,%ebx
  802748:	85 c0                	test   %eax,%eax
  80274a:	0f 88 d9 00 00 00    	js     802829 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	89 04 24             	mov    %eax,(%esp)
  802756:	e8 25 f0 ff ff       	call   801780 <fd2data>
  80275b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80275d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802764:	00 
  802765:	89 44 24 04          	mov    %eax,0x4(%esp)
  802769:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802770:	e8 ce eb ff ff       	call   801343 <sys_page_alloc>
  802775:	89 c3                	mov    %eax,%ebx
  802777:	85 c0                	test   %eax,%eax
  802779:	0f 88 97 00 00 00    	js     802816 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80277f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802782:	89 04 24             	mov    %eax,(%esp)
  802785:	e8 f6 ef ff ff       	call   801780 <fd2data>
  80278a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802791:	00 
  802792:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802796:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80279d:	00 
  80279e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027a9:	e8 e9 eb ff ff       	call   801397 <sys_page_map>
  8027ae:	89 c3                	mov    %eax,%ebx
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	78 52                	js     802806 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8027b4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8027c9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8027cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8027d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	89 04 24             	mov    %eax,(%esp)
  8027e4:	e8 87 ef ff ff       	call   801770 <fd2num>
  8027e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027ec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8027ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f1:	89 04 24             	mov    %eax,(%esp)
  8027f4:	e8 77 ef ff ff       	call   801770 <fd2num>
  8027f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027fc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8027ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802804:	eb 38                	jmp    80283e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802806:	89 74 24 04          	mov    %esi,0x4(%esp)
  80280a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802811:	e8 d4 eb ff ff       	call   8013ea <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802819:	89 44 24 04          	mov    %eax,0x4(%esp)
  80281d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802824:	e8 c1 eb ff ff       	call   8013ea <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802830:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802837:	e8 ae eb ff ff       	call   8013ea <sys_page_unmap>
  80283c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80283e:	83 c4 30             	add    $0x30,%esp
  802841:	5b                   	pop    %ebx
  802842:	5e                   	pop    %esi
  802843:	5d                   	pop    %ebp
  802844:	c3                   	ret    

00802845 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802845:	55                   	push   %ebp
  802846:	89 e5                	mov    %esp,%ebp
  802848:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80284b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80284e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	89 04 24             	mov    %eax,(%esp)
  802858:	e8 89 ef ff ff       	call   8017e6 <fd_lookup>
  80285d:	89 c2                	mov    %eax,%edx
  80285f:	85 d2                	test   %edx,%edx
  802861:	78 15                	js     802878 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	89 04 24             	mov    %eax,(%esp)
  802869:	e8 12 ef ff ff       	call   801780 <fd2data>
	return _pipeisclosed(fd, p);
  80286e:	89 c2                	mov    %eax,%edx
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	e8 0b fd ff ff       	call   802583 <_pipeisclosed>
}
  802878:	c9                   	leave  
  802879:	c3                   	ret    
  80287a:	66 90                	xchg   %ax,%ax
  80287c:	66 90                	xchg   %ax,%ax
  80287e:	66 90                	xchg   %ax,%ax

00802880 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802883:	b8 00 00 00 00       	mov    $0x0,%eax
  802888:	5d                   	pop    %ebp
  802889:	c3                   	ret    

0080288a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
  80288d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802890:	c7 44 24 04 4b 35 80 	movl   $0x80354b,0x4(%esp)
  802897:	00 
  802898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80289b:	89 04 24             	mov    %eax,(%esp)
  80289e:	e8 84 e6 ff ff       	call   800f27 <strcpy>
	return 0;
}
  8028a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    

008028aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8028aa:	55                   	push   %ebp
  8028ab:	89 e5                	mov    %esp,%ebp
  8028ad:	57                   	push   %edi
  8028ae:	56                   	push   %esi
  8028af:	53                   	push   %ebx
  8028b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028bb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028c1:	eb 31                	jmp    8028f4 <devcons_write+0x4a>
		m = n - tot;
  8028c3:	8b 75 10             	mov    0x10(%ebp),%esi
  8028c6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8028c8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8028cb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8028d0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028d3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8028d7:	03 45 0c             	add    0xc(%ebp),%eax
  8028da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028de:	89 3c 24             	mov    %edi,(%esp)
  8028e1:	e8 de e7 ff ff       	call   8010c4 <memmove>
		sys_cputs(buf, m);
  8028e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028ea:	89 3c 24             	mov    %edi,(%esp)
  8028ed:	e8 84 e9 ff ff       	call   801276 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028f2:	01 f3                	add    %esi,%ebx
  8028f4:	89 d8                	mov    %ebx,%eax
  8028f6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8028f9:	72 c8                	jb     8028c3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8028fb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802901:	5b                   	pop    %ebx
  802902:	5e                   	pop    %esi
  802903:	5f                   	pop    %edi
  802904:	5d                   	pop    %ebp
  802905:	c3                   	ret    

00802906 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
  802909:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80290c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802911:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802915:	75 07                	jne    80291e <devcons_read+0x18>
  802917:	eb 2a                	jmp    802943 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802919:	e8 06 ea ff ff       	call   801324 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80291e:	66 90                	xchg   %ax,%ax
  802920:	e8 6f e9 ff ff       	call   801294 <sys_cgetc>
  802925:	85 c0                	test   %eax,%eax
  802927:	74 f0                	je     802919 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802929:	85 c0                	test   %eax,%eax
  80292b:	78 16                	js     802943 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80292d:	83 f8 04             	cmp    $0x4,%eax
  802930:	74 0c                	je     80293e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802932:	8b 55 0c             	mov    0xc(%ebp),%edx
  802935:	88 02                	mov    %al,(%edx)
	return 1;
  802937:	b8 01 00 00 00       	mov    $0x1,%eax
  80293c:	eb 05                	jmp    802943 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80293e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802943:	c9                   	leave  
  802944:	c3                   	ret    

00802945 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802945:	55                   	push   %ebp
  802946:	89 e5                	mov    %esp,%ebp
  802948:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802951:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802958:	00 
  802959:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80295c:	89 04 24             	mov    %eax,(%esp)
  80295f:	e8 12 e9 ff ff       	call   801276 <sys_cputs>
}
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <getchar>:

int
getchar(void)
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
  802969:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80296c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802973:	00 
  802974:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802977:	89 44 24 04          	mov    %eax,0x4(%esp)
  80297b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802982:	e8 f3 f0 ff ff       	call   801a7a <read>
	if (r < 0)
  802987:	85 c0                	test   %eax,%eax
  802989:	78 0f                	js     80299a <getchar+0x34>
		return r;
	if (r < 1)
  80298b:	85 c0                	test   %eax,%eax
  80298d:	7e 06                	jle    802995 <getchar+0x2f>
		return -E_EOF;
	return c;
  80298f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802993:	eb 05                	jmp    80299a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802995:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80299a:	c9                   	leave  
  80299b:	c3                   	ret    

0080299c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
  80299f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	89 04 24             	mov    %eax,(%esp)
  8029af:	e8 32 ee ff ff       	call   8017e6 <fd_lookup>
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	78 11                	js     8029c9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8029c1:	39 10                	cmp    %edx,(%eax)
  8029c3:	0f 94 c0             	sete   %al
  8029c6:	0f b6 c0             	movzbl %al,%eax
}
  8029c9:	c9                   	leave  
  8029ca:	c3                   	ret    

008029cb <opencons>:

int
opencons(void)
{
  8029cb:	55                   	push   %ebp
  8029cc:	89 e5                	mov    %esp,%ebp
  8029ce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029d4:	89 04 24             	mov    %eax,(%esp)
  8029d7:	e8 bb ed ff ff       	call   801797 <fd_alloc>
		return r;
  8029dc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	78 40                	js     802a22 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029e9:	00 
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029f8:	e8 46 e9 ff ff       	call   801343 <sys_page_alloc>
		return r;
  8029fd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	78 1f                	js     802a22 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a03:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a18:	89 04 24             	mov    %eax,(%esp)
  802a1b:	e8 50 ed ff ff       	call   801770 <fd2num>
  802a20:	89 c2                	mov    %eax,%edx
}
  802a22:	89 d0                	mov    %edx,%eax
  802a24:	c9                   	leave  
  802a25:	c3                   	ret    

00802a26 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a26:	55                   	push   %ebp
  802a27:	89 e5                	mov    %esp,%ebp
  802a29:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a2c:	89 d0                	mov    %edx,%eax
  802a2e:	c1 e8 16             	shr    $0x16,%eax
  802a31:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a38:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a3d:	f6 c1 01             	test   $0x1,%cl
  802a40:	74 1d                	je     802a5f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802a42:	c1 ea 0c             	shr    $0xc,%edx
  802a45:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a4c:	f6 c2 01             	test   $0x1,%dl
  802a4f:	74 0e                	je     802a5f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a51:	c1 ea 0c             	shr    $0xc,%edx
  802a54:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a5b:	ef 
  802a5c:	0f b7 c0             	movzwl %ax,%eax
}
  802a5f:	5d                   	pop    %ebp
  802a60:	c3                   	ret    
  802a61:	66 90                	xchg   %ax,%ax
  802a63:	66 90                	xchg   %ax,%ax
  802a65:	66 90                	xchg   %ax,%ax
  802a67:	66 90                	xchg   %ax,%ax
  802a69:	66 90                	xchg   %ax,%ax
  802a6b:	66 90                	xchg   %ax,%ax
  802a6d:	66 90                	xchg   %ax,%ax
  802a6f:	90                   	nop

00802a70 <__udivdi3>:
  802a70:	55                   	push   %ebp
  802a71:	57                   	push   %edi
  802a72:	56                   	push   %esi
  802a73:	83 ec 0c             	sub    $0xc,%esp
  802a76:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a7a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a7e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a82:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a86:	85 c0                	test   %eax,%eax
  802a88:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a8c:	89 ea                	mov    %ebp,%edx
  802a8e:	89 0c 24             	mov    %ecx,(%esp)
  802a91:	75 2d                	jne    802ac0 <__udivdi3+0x50>
  802a93:	39 e9                	cmp    %ebp,%ecx
  802a95:	77 61                	ja     802af8 <__udivdi3+0x88>
  802a97:	85 c9                	test   %ecx,%ecx
  802a99:	89 ce                	mov    %ecx,%esi
  802a9b:	75 0b                	jne    802aa8 <__udivdi3+0x38>
  802a9d:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa2:	31 d2                	xor    %edx,%edx
  802aa4:	f7 f1                	div    %ecx
  802aa6:	89 c6                	mov    %eax,%esi
  802aa8:	31 d2                	xor    %edx,%edx
  802aaa:	89 e8                	mov    %ebp,%eax
  802aac:	f7 f6                	div    %esi
  802aae:	89 c5                	mov    %eax,%ebp
  802ab0:	89 f8                	mov    %edi,%eax
  802ab2:	f7 f6                	div    %esi
  802ab4:	89 ea                	mov    %ebp,%edx
  802ab6:	83 c4 0c             	add    $0xc,%esp
  802ab9:	5e                   	pop    %esi
  802aba:	5f                   	pop    %edi
  802abb:	5d                   	pop    %ebp
  802abc:	c3                   	ret    
  802abd:	8d 76 00             	lea    0x0(%esi),%esi
  802ac0:	39 e8                	cmp    %ebp,%eax
  802ac2:	77 24                	ja     802ae8 <__udivdi3+0x78>
  802ac4:	0f bd e8             	bsr    %eax,%ebp
  802ac7:	83 f5 1f             	xor    $0x1f,%ebp
  802aca:	75 3c                	jne    802b08 <__udivdi3+0x98>
  802acc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802ad0:	39 34 24             	cmp    %esi,(%esp)
  802ad3:	0f 86 9f 00 00 00    	jbe    802b78 <__udivdi3+0x108>
  802ad9:	39 d0                	cmp    %edx,%eax
  802adb:	0f 82 97 00 00 00    	jb     802b78 <__udivdi3+0x108>
  802ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ae8:	31 d2                	xor    %edx,%edx
  802aea:	31 c0                	xor    %eax,%eax
  802aec:	83 c4 0c             	add    $0xc,%esp
  802aef:	5e                   	pop    %esi
  802af0:	5f                   	pop    %edi
  802af1:	5d                   	pop    %ebp
  802af2:	c3                   	ret    
  802af3:	90                   	nop
  802af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802af8:	89 f8                	mov    %edi,%eax
  802afa:	f7 f1                	div    %ecx
  802afc:	31 d2                	xor    %edx,%edx
  802afe:	83 c4 0c             	add    $0xc,%esp
  802b01:	5e                   	pop    %esi
  802b02:	5f                   	pop    %edi
  802b03:	5d                   	pop    %ebp
  802b04:	c3                   	ret    
  802b05:	8d 76 00             	lea    0x0(%esi),%esi
  802b08:	89 e9                	mov    %ebp,%ecx
  802b0a:	8b 3c 24             	mov    (%esp),%edi
  802b0d:	d3 e0                	shl    %cl,%eax
  802b0f:	89 c6                	mov    %eax,%esi
  802b11:	b8 20 00 00 00       	mov    $0x20,%eax
  802b16:	29 e8                	sub    %ebp,%eax
  802b18:	89 c1                	mov    %eax,%ecx
  802b1a:	d3 ef                	shr    %cl,%edi
  802b1c:	89 e9                	mov    %ebp,%ecx
  802b1e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b22:	8b 3c 24             	mov    (%esp),%edi
  802b25:	09 74 24 08          	or     %esi,0x8(%esp)
  802b29:	89 d6                	mov    %edx,%esi
  802b2b:	d3 e7                	shl    %cl,%edi
  802b2d:	89 c1                	mov    %eax,%ecx
  802b2f:	89 3c 24             	mov    %edi,(%esp)
  802b32:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b36:	d3 ee                	shr    %cl,%esi
  802b38:	89 e9                	mov    %ebp,%ecx
  802b3a:	d3 e2                	shl    %cl,%edx
  802b3c:	89 c1                	mov    %eax,%ecx
  802b3e:	d3 ef                	shr    %cl,%edi
  802b40:	09 d7                	or     %edx,%edi
  802b42:	89 f2                	mov    %esi,%edx
  802b44:	89 f8                	mov    %edi,%eax
  802b46:	f7 74 24 08          	divl   0x8(%esp)
  802b4a:	89 d6                	mov    %edx,%esi
  802b4c:	89 c7                	mov    %eax,%edi
  802b4e:	f7 24 24             	mull   (%esp)
  802b51:	39 d6                	cmp    %edx,%esi
  802b53:	89 14 24             	mov    %edx,(%esp)
  802b56:	72 30                	jb     802b88 <__udivdi3+0x118>
  802b58:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b5c:	89 e9                	mov    %ebp,%ecx
  802b5e:	d3 e2                	shl    %cl,%edx
  802b60:	39 c2                	cmp    %eax,%edx
  802b62:	73 05                	jae    802b69 <__udivdi3+0xf9>
  802b64:	3b 34 24             	cmp    (%esp),%esi
  802b67:	74 1f                	je     802b88 <__udivdi3+0x118>
  802b69:	89 f8                	mov    %edi,%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	e9 7a ff ff ff       	jmp    802aec <__udivdi3+0x7c>
  802b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b78:	31 d2                	xor    %edx,%edx
  802b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b7f:	e9 68 ff ff ff       	jmp    802aec <__udivdi3+0x7c>
  802b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b88:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b8b:	31 d2                	xor    %edx,%edx
  802b8d:	83 c4 0c             	add    $0xc,%esp
  802b90:	5e                   	pop    %esi
  802b91:	5f                   	pop    %edi
  802b92:	5d                   	pop    %ebp
  802b93:	c3                   	ret    
  802b94:	66 90                	xchg   %ax,%ax
  802b96:	66 90                	xchg   %ax,%ax
  802b98:	66 90                	xchg   %ax,%ax
  802b9a:	66 90                	xchg   %ax,%ax
  802b9c:	66 90                	xchg   %ax,%ax
  802b9e:	66 90                	xchg   %ax,%ax

00802ba0 <__umoddi3>:
  802ba0:	55                   	push   %ebp
  802ba1:	57                   	push   %edi
  802ba2:	56                   	push   %esi
  802ba3:	83 ec 14             	sub    $0x14,%esp
  802ba6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802baa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802bb2:	89 c7                	mov    %eax,%edi
  802bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bb8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802bbc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802bc0:	89 34 24             	mov    %esi,(%esp)
  802bc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	89 c2                	mov    %eax,%edx
  802bcb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bcf:	75 17                	jne    802be8 <__umoddi3+0x48>
  802bd1:	39 fe                	cmp    %edi,%esi
  802bd3:	76 4b                	jbe    802c20 <__umoddi3+0x80>
  802bd5:	89 c8                	mov    %ecx,%eax
  802bd7:	89 fa                	mov    %edi,%edx
  802bd9:	f7 f6                	div    %esi
  802bdb:	89 d0                	mov    %edx,%eax
  802bdd:	31 d2                	xor    %edx,%edx
  802bdf:	83 c4 14             	add    $0x14,%esp
  802be2:	5e                   	pop    %esi
  802be3:	5f                   	pop    %edi
  802be4:	5d                   	pop    %ebp
  802be5:	c3                   	ret    
  802be6:	66 90                	xchg   %ax,%ax
  802be8:	39 f8                	cmp    %edi,%eax
  802bea:	77 54                	ja     802c40 <__umoddi3+0xa0>
  802bec:	0f bd e8             	bsr    %eax,%ebp
  802bef:	83 f5 1f             	xor    $0x1f,%ebp
  802bf2:	75 5c                	jne    802c50 <__umoddi3+0xb0>
  802bf4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802bf8:	39 3c 24             	cmp    %edi,(%esp)
  802bfb:	0f 87 e7 00 00 00    	ja     802ce8 <__umoddi3+0x148>
  802c01:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c05:	29 f1                	sub    %esi,%ecx
  802c07:	19 c7                	sbb    %eax,%edi
  802c09:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c11:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c15:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802c19:	83 c4 14             	add    $0x14,%esp
  802c1c:	5e                   	pop    %esi
  802c1d:	5f                   	pop    %edi
  802c1e:	5d                   	pop    %ebp
  802c1f:	c3                   	ret    
  802c20:	85 f6                	test   %esi,%esi
  802c22:	89 f5                	mov    %esi,%ebp
  802c24:	75 0b                	jne    802c31 <__umoddi3+0x91>
  802c26:	b8 01 00 00 00       	mov    $0x1,%eax
  802c2b:	31 d2                	xor    %edx,%edx
  802c2d:	f7 f6                	div    %esi
  802c2f:	89 c5                	mov    %eax,%ebp
  802c31:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c35:	31 d2                	xor    %edx,%edx
  802c37:	f7 f5                	div    %ebp
  802c39:	89 c8                	mov    %ecx,%eax
  802c3b:	f7 f5                	div    %ebp
  802c3d:	eb 9c                	jmp    802bdb <__umoddi3+0x3b>
  802c3f:	90                   	nop
  802c40:	89 c8                	mov    %ecx,%eax
  802c42:	89 fa                	mov    %edi,%edx
  802c44:	83 c4 14             	add    $0x14,%esp
  802c47:	5e                   	pop    %esi
  802c48:	5f                   	pop    %edi
  802c49:	5d                   	pop    %ebp
  802c4a:	c3                   	ret    
  802c4b:	90                   	nop
  802c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c50:	8b 04 24             	mov    (%esp),%eax
  802c53:	be 20 00 00 00       	mov    $0x20,%esi
  802c58:	89 e9                	mov    %ebp,%ecx
  802c5a:	29 ee                	sub    %ebp,%esi
  802c5c:	d3 e2                	shl    %cl,%edx
  802c5e:	89 f1                	mov    %esi,%ecx
  802c60:	d3 e8                	shr    %cl,%eax
  802c62:	89 e9                	mov    %ebp,%ecx
  802c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c68:	8b 04 24             	mov    (%esp),%eax
  802c6b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c6f:	89 fa                	mov    %edi,%edx
  802c71:	d3 e0                	shl    %cl,%eax
  802c73:	89 f1                	mov    %esi,%ecx
  802c75:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c79:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c7d:	d3 ea                	shr    %cl,%edx
  802c7f:	89 e9                	mov    %ebp,%ecx
  802c81:	d3 e7                	shl    %cl,%edi
  802c83:	89 f1                	mov    %esi,%ecx
  802c85:	d3 e8                	shr    %cl,%eax
  802c87:	89 e9                	mov    %ebp,%ecx
  802c89:	09 f8                	or     %edi,%eax
  802c8b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c8f:	f7 74 24 04          	divl   0x4(%esp)
  802c93:	d3 e7                	shl    %cl,%edi
  802c95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c99:	89 d7                	mov    %edx,%edi
  802c9b:	f7 64 24 08          	mull   0x8(%esp)
  802c9f:	39 d7                	cmp    %edx,%edi
  802ca1:	89 c1                	mov    %eax,%ecx
  802ca3:	89 14 24             	mov    %edx,(%esp)
  802ca6:	72 2c                	jb     802cd4 <__umoddi3+0x134>
  802ca8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802cac:	72 22                	jb     802cd0 <__umoddi3+0x130>
  802cae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802cb2:	29 c8                	sub    %ecx,%eax
  802cb4:	19 d7                	sbb    %edx,%edi
  802cb6:	89 e9                	mov    %ebp,%ecx
  802cb8:	89 fa                	mov    %edi,%edx
  802cba:	d3 e8                	shr    %cl,%eax
  802cbc:	89 f1                	mov    %esi,%ecx
  802cbe:	d3 e2                	shl    %cl,%edx
  802cc0:	89 e9                	mov    %ebp,%ecx
  802cc2:	d3 ef                	shr    %cl,%edi
  802cc4:	09 d0                	or     %edx,%eax
  802cc6:	89 fa                	mov    %edi,%edx
  802cc8:	83 c4 14             	add    $0x14,%esp
  802ccb:	5e                   	pop    %esi
  802ccc:	5f                   	pop    %edi
  802ccd:	5d                   	pop    %ebp
  802cce:	c3                   	ret    
  802ccf:	90                   	nop
  802cd0:	39 d7                	cmp    %edx,%edi
  802cd2:	75 da                	jne    802cae <__umoddi3+0x10e>
  802cd4:	8b 14 24             	mov    (%esp),%edx
  802cd7:	89 c1                	mov    %eax,%ecx
  802cd9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802cdd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802ce1:	eb cb                	jmp    802cae <__umoddi3+0x10e>
  802ce3:	90                   	nop
  802ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ce8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802cec:	0f 82 0f ff ff ff    	jb     802c01 <__umoddi3+0x61>
  802cf2:	e9 1a ff ff ff       	jmp    802c11 <__umoddi3+0x71>
