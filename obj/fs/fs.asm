
obj/fs/fs:     file format elf32-i386


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
  80002c:	e8 86 1b 00 00       	call   801bb7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
		return -1;
	return 0;
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 14             	sub    $0x14,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800075:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	b2 f7                	mov    $0xf7,%dl
  800082:	eb 0b                	jmp    80008f <ide_probe_disk1+0x30>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  800084:	83 c1 01             	add    $0x1,%ecx

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  800087:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  80008d:	74 05                	je     800094 <ide_probe_disk1+0x35>
  80008f:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800090:	a8 a1                	test   $0xa1,%al
  800092:	75 f0                	jne    800084 <ide_probe_disk1+0x25>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800094:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800099:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009e:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  80009f:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a5:	0f 9e c3             	setle  %bl
  8000a8:	0f b6 c3             	movzbl %bl,%eax
  8000ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000af:	c7 04 24 c0 41 80 00 	movl   $0x8041c0,(%esp)
  8000b6:	e8 60 1c 00 00       	call   801d1b <cprintf>
	return (x < 1000);
}
  8000bb:	89 d8                	mov    %ebx,%eax
  8000bd:	83 c4 14             	add    $0x14,%esp
  8000c0:	5b                   	pop    %ebx
  8000c1:	5d                   	pop    %ebp
  8000c2:	c3                   	ret    

008000c3 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	83 ec 18             	sub    $0x18,%esp
  8000c9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000cc:	83 f8 01             	cmp    $0x1,%eax
  8000cf:	76 1c                	jbe    8000ed <ide_set_disk+0x2a>
		panic("bad disk number");
  8000d1:	c7 44 24 08 d7 41 80 	movl   $0x8041d7,0x8(%esp)
  8000d8:	00 
  8000d9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8000e0:	00 
  8000e1:	c7 04 24 e7 41 80 00 	movl   $0x8041e7,(%esp)
  8000e8:	e8 35 1b 00 00       	call   801c22 <_panic>
	diskno = d;
  8000ed:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	57                   	push   %edi
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	83 ec 1c             	sub    $0x1c,%esp
  8000fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800100:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800103:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800106:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  80010c:	76 24                	jbe    800132 <ide_read+0x3e>
  80010e:	c7 44 24 0c f0 41 80 	movl   $0x8041f0,0xc(%esp)
  800115:	00 
  800116:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  80011d:	00 
  80011e:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 e7 41 80 00 	movl   $0x8041e7,(%esp)
  80012d:	e8 f0 1a 00 00       	call   801c22 <_panic>

	ide_wait_ready(0);
  800132:	b8 00 00 00 00       	mov    $0x0,%eax
  800137:	e8 f7 fe ff ff       	call   800033 <ide_wait_ready>
  80013c:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800141:	89 f0                	mov    %esi,%eax
  800143:	ee                   	out    %al,(%dx)
  800144:	b2 f3                	mov    $0xf3,%dl
  800146:	89 f8                	mov    %edi,%eax
  800148:	ee                   	out    %al,(%dx)
  800149:	89 f8                	mov    %edi,%eax
  80014b:	0f b6 c4             	movzbl %ah,%eax
  80014e:	b2 f4                	mov    $0xf4,%dl
  800150:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
  800151:	89 f8                	mov    %edi,%eax
  800153:	c1 e8 10             	shr    $0x10,%eax
  800156:	b2 f5                	mov    $0xf5,%dl
  800158:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800159:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800160:	83 e0 01             	and    $0x1,%eax
  800163:	c1 e0 04             	shl    $0x4,%eax
  800166:	83 c8 e0             	or     $0xffffffe0,%eax
  800169:	c1 ef 18             	shr    $0x18,%edi
  80016c:	83 e7 0f             	and    $0xf,%edi
  80016f:	09 f8                	or     %edi,%eax
  800171:	b2 f6                	mov    $0xf6,%dl
  800173:	ee                   	out    %al,(%dx)
  800174:	b2 f7                	mov    $0xf7,%dl
  800176:	b8 20 00 00 00       	mov    $0x20,%eax
  80017b:	ee                   	out    %al,(%dx)
  80017c:	c1 e6 09             	shl    $0x9,%esi
  80017f:	01 de                	add    %ebx,%esi
  800181:	eb 23                	jmp    8001a6 <ide_read+0xb2>
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
		if ((r = ide_wait_ready(1)) < 0)
  800183:	b8 01 00 00 00       	mov    $0x1,%eax
  800188:	e8 a6 fe ff ff       	call   800033 <ide_wait_ready>
  80018d:	85 c0                	test   %eax,%eax
  80018f:	78 1e                	js     8001af <ide_read+0xbb>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  800191:	89 df                	mov    %ebx,%edi
  800193:	b9 80 00 00 00       	mov    $0x80,%ecx
  800198:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80019d:	fc                   	cld    
  80019e:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001a0:	81 c3 00 02 00 00    	add    $0x200,%ebx
  8001a6:	39 f3                	cmp    %esi,%ebx
  8001a8:	75 d9                	jne    800183 <ide_read+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001af:	83 c4 1c             	add    $0x1c,%esp
  8001b2:	5b                   	pop    %ebx
  8001b3:	5e                   	pop    %esi
  8001b4:	5f                   	pop    %edi
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	57                   	push   %edi
  8001bb:	56                   	push   %esi
  8001bc:	53                   	push   %ebx
  8001bd:	83 ec 1c             	sub    $0x1c,%esp
  8001c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c9:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001cf:	76 24                	jbe    8001f5 <ide_write+0x3e>
  8001d1:	c7 44 24 0c f0 41 80 	movl   $0x8041f0,0xc(%esp)
  8001d8:	00 
  8001d9:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  8001e0:	00 
  8001e1:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8001e8:	00 
  8001e9:	c7 04 24 e7 41 80 00 	movl   $0x8041e7,(%esp)
  8001f0:	e8 2d 1a 00 00       	call   801c22 <_panic>

	ide_wait_ready(0);
  8001f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fa:	e8 34 fe ff ff       	call   800033 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001ff:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800204:	89 f8                	mov    %edi,%eax
  800206:	ee                   	out    %al,(%dx)
  800207:	b2 f3                	mov    $0xf3,%dl
  800209:	89 f0                	mov    %esi,%eax
  80020b:	ee                   	out    %al,(%dx)
  80020c:	89 f0                	mov    %esi,%eax
  80020e:	0f b6 c4             	movzbl %ah,%eax
  800211:	b2 f4                	mov    $0xf4,%dl
  800213:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
  800214:	89 f0                	mov    %esi,%eax
  800216:	c1 e8 10             	shr    $0x10,%eax
  800219:	b2 f5                	mov    $0xf5,%dl
  80021b:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80021c:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800223:	83 e0 01             	and    $0x1,%eax
  800226:	c1 e0 04             	shl    $0x4,%eax
  800229:	83 c8 e0             	or     $0xffffffe0,%eax
  80022c:	c1 ee 18             	shr    $0x18,%esi
  80022f:	83 e6 0f             	and    $0xf,%esi
  800232:	09 f0                	or     %esi,%eax
  800234:	b2 f6                	mov    $0xf6,%dl
  800236:	ee                   	out    %al,(%dx)
  800237:	b2 f7                	mov    $0xf7,%dl
  800239:	b8 30 00 00 00       	mov    $0x30,%eax
  80023e:	ee                   	out    %al,(%dx)
  80023f:	c1 e7 09             	shl    $0x9,%edi
  800242:	01 df                	add    %ebx,%edi
  800244:	eb 23                	jmp    800269 <ide_write+0xb2>
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
		if ((r = ide_wait_ready(1)) < 0)
  800246:	b8 01 00 00 00       	mov    $0x1,%eax
  80024b:	e8 e3 fd ff ff       	call   800033 <ide_wait_ready>
  800250:	85 c0                	test   %eax,%eax
  800252:	78 1e                	js     800272 <ide_write+0xbb>
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  800254:	89 de                	mov    %ebx,%esi
  800256:	b9 80 00 00 00       	mov    $0x80,%ecx
  80025b:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800260:	fc                   	cld    
  800261:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800263:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800269:	39 fb                	cmp    %edi,%ebx
  80026b:	75 d9                	jne    800246 <ide_write+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	83 c4 1c             	add    $0x1c,%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	57                   	push   %edi
  80027e:	56                   	push   %esi
  80027f:	53                   	push   %ebx
  800280:	83 ec 2c             	sub    $0x2c,%esp
  800283:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800286:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800288:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80028e:	89 c6                	mov    %eax,%esi
  800290:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800293:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800298:	76 2e                	jbe    8002c8 <bc_pgfault+0x4e>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80029a:	8b 42 04             	mov    0x4(%edx),%eax
  80029d:	89 44 24 14          	mov    %eax,0x14(%esp)
  8002a1:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8002a5:	8b 42 28             	mov    0x28(%edx),%eax
  8002a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ac:	c7 44 24 08 14 42 80 	movl   $0x804214,0x8(%esp)
  8002b3:	00 
  8002b4:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  8002bb:	00 
  8002bc:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  8002c3:	e8 5a 19 00 00       	call   801c22 <_panic>
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8002c8:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8002cd:	85 c0                	test   %eax,%eax
  8002cf:	74 25                	je     8002f6 <bc_pgfault+0x7c>
  8002d1:	3b 70 04             	cmp    0x4(%eax),%esi
  8002d4:	72 20                	jb     8002f6 <bc_pgfault+0x7c>
		panic("reading non-existent block %08x\n", blockno);
  8002d6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002da:	c7 44 24 08 44 42 80 	movl   $0x804244,0x8(%esp)
  8002e1:	00 
  8002e2:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8002e9:	00 
  8002ea:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  8002f1:	e8 2c 19 00 00       	call   801c22 <_panic>
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:

	uint32_t round_addr = ROUNDDOWN((uint32_t)addr,PGSIZE);
  8002f6:	89 df                	mov    %ebx,%edi
  8002f8:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	if(sys_page_alloc(thisenv->env_id,(void*)round_addr,PTE_W|PTE_P|PTE_U)<0)
  8002fe:	a1 10 a0 80 00       	mov    0x80a010,%eax
  800303:	8b 40 48             	mov    0x48(%eax),%eax
  800306:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80030d:	00 
  80030e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800312:	89 04 24             	mov    %eax,(%esp)
  800315:	e8 49 24 00 00       	call   802763 <sys_page_alloc>
  80031a:	85 c0                	test   %eax,%eax
  80031c:	79 1c                	jns    80033a <bc_pgfault+0xc0>
		panic("sys_page_alloc failed in fs/bc.c");
  80031e:	c7 44 24 08 68 42 80 	movl   $0x804268,0x8(%esp)
  800325:	00 
  800326:	c7 44 24 04 36 00 00 	movl   $0x36,0x4(%esp)
  80032d:	00 
  80032e:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  800335:	e8 e8 18 00 00       	call   801c22 <_panic>
	if(ide_read(blockno*BLKSECTS,(void*)round_addr,BLKSECTS)!=0)
  80033a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  800341:	00 
  800342:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800346:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  80034d:	89 04 24             	mov    %eax,(%esp)
  800350:	e8 9f fd ff ff       	call   8000f4 <ide_read>
  800355:	85 c0                	test   %eax,%eax
  800357:	74 1c                	je     800375 <bc_pgfault+0xfb>
		panic("ide_read failed in fs/bc.c");
  800359:	c7 44 24 08 f4 42 80 	movl   $0x8042f4,0x8(%esp)
  800360:	00 
  800361:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  800368:	00 
  800369:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  800370:	e8 ad 18 00 00       	call   801c22 <_panic>
	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	//cprintf("%08x \n",addr);

	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800375:	89 d8                	mov    %ebx,%eax
  800377:	c1 e8 0c             	shr    $0xc,%eax
  80037a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800381:	25 07 0e 00 00       	and    $0xe07,%eax
  800386:	89 44 24 10          	mov    %eax,0x10(%esp)
  80038a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80038e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800395:	00 
  800396:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80039a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003a1:	e8 11 24 00 00       	call   8027b7 <sys_page_map>
  8003a6:	85 c0                	test   %eax,%eax
  8003a8:	79 20                	jns    8003ca <bc_pgfault+0x150>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8003aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003ae:	c7 44 24 08 8c 42 80 	movl   $0x80428c,0x8(%esp)
  8003b5:	00 
  8003b6:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  8003bd:	00 
  8003be:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  8003c5:	e8 58 18 00 00       	call   801c22 <_panic>

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  8003ca:	83 3d 08 a0 80 00 00 	cmpl   $0x0,0x80a008
  8003d1:	74 2c                	je     8003ff <bc_pgfault+0x185>
  8003d3:	89 34 24             	mov    %esi,(%esp)
  8003d6:	e8 bb 03 00 00       	call   800796 <block_is_free>
  8003db:	84 c0                	test   %al,%al
  8003dd:	74 20                	je     8003ff <bc_pgfault+0x185>
		panic("reading free block %08x\n", blockno);
  8003df:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003e3:	c7 44 24 08 0f 43 80 	movl   $0x80430f,0x8(%esp)
  8003ea:	00 
  8003eb:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8003f2:	00 
  8003f3:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  8003fa:	e8 23 18 00 00       	call   801c22 <_panic>
}
  8003ff:	83 c4 2c             	add    $0x2c,%esp
  800402:	5b                   	pop    %ebx
  800403:	5e                   	pop    %esi
  800404:	5f                   	pop    %edi
  800405:	5d                   	pop    %ebp
  800406:	c3                   	ret    

00800407 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	83 ec 18             	sub    $0x18,%esp
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  800410:	85 c0                	test   %eax,%eax
  800412:	74 0f                	je     800423 <diskaddr+0x1c>
  800414:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  80041a:	85 d2                	test   %edx,%edx
  80041c:	74 25                	je     800443 <diskaddr+0x3c>
  80041e:	3b 42 04             	cmp    0x4(%edx),%eax
  800421:	72 20                	jb     800443 <diskaddr+0x3c>
		panic("bad block number %08x in diskaddr", blockno);
  800423:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800427:	c7 44 24 08 ac 42 80 	movl   $0x8042ac,0x8(%esp)
  80042e:	00 
  80042f:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800436:	00 
  800437:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  80043e:	e8 df 17 00 00       	call   801c22 <_panic>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800443:	05 00 00 01 00       	add    $0x10000,%eax
  800448:	c1 e0 0c             	shl    $0xc,%eax
}
  80044b:	c9                   	leave  
  80044c:	c3                   	ret    

0080044d <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  800453:	89 d0                	mov    %edx,%eax
  800455:	c1 e8 16             	shr    $0x16,%eax
  800458:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  80045f:	b8 00 00 00 00       	mov    $0x0,%eax
  800464:	f6 c1 01             	test   $0x1,%cl
  800467:	74 0d                	je     800476 <va_is_mapped+0x29>
  800469:	c1 ea 0c             	shr    $0xc,%edx
  80046c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800473:	83 e0 01             	and    $0x1,%eax
  800476:	83 e0 01             	and    $0x1,%eax
}
  800479:	5d                   	pop    %ebp
  80047a:	c3                   	ret    

0080047b <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  80047b:	55                   	push   %ebp
  80047c:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	c1 e8 0c             	shr    $0xc,%eax
  800484:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80048b:	c1 e8 06             	shr    $0x6,%eax
  80048e:	83 e0 01             	and    $0x1,%eax
}
  800491:	5d                   	pop    %ebp
  800492:	c3                   	ret    

00800493 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
  800496:	56                   	push   %esi
  800497:	53                   	push   %ebx
  800498:	83 ec 20             	sub    $0x20,%esp
  80049b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80049e:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  8004a4:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  8004a9:	76 20                	jbe    8004cb <flush_block+0x38>
		panic("flush_block of bad va %08x", addr);
  8004ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004af:	c7 44 24 08 28 43 80 	movl   $0x804328,0x8(%esp)
  8004b6:	00 
  8004b7:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  8004be:	00 
  8004bf:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  8004c6:	e8 57 17 00 00       	call   801c22 <_panic>

	// LAB 5: Your code here.
	uint32_t round_addr = ROUNDDOWN((uint32_t)addr,PGSIZE);
  8004cb:	89 de                	mov    %ebx,%esi
  8004cd:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if((va_is_mapped((void*)round_addr))&&(va_is_dirty((void*)round_addr))){
  8004d3:	89 34 24             	mov    %esi,(%esp)
  8004d6:	e8 72 ff ff ff       	call   80044d <va_is_mapped>
  8004db:	84 c0                	test   %al,%al
  8004dd:	74 61                	je     800540 <flush_block+0xad>
  8004df:	89 34 24             	mov    %esi,(%esp)
  8004e2:	e8 94 ff ff ff       	call   80047b <va_is_dirty>
  8004e7:	84 c0                	test   %al,%al
  8004e9:	74 55                	je     800540 <flush_block+0xad>
		ide_write(blockno*BLKSECTS,(void*)round_addr,BLKSECTS);
  8004eb:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  8004f2:	00 
  8004f3:	89 74 24 04          	mov    %esi,0x4(%esp)
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8004f7:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  8004fd:	c1 eb 0c             	shr    $0xc,%ebx
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	uint32_t round_addr = ROUNDDOWN((uint32_t)addr,PGSIZE);
	if((va_is_mapped((void*)round_addr))&&(va_is_dirty((void*)round_addr))){
		ide_write(blockno*BLKSECTS,(void*)round_addr,BLKSECTS);
  800500:	c1 e3 03             	shl    $0x3,%ebx
  800503:	89 1c 24             	mov    %ebx,(%esp)
  800506:	e8 ac fc ff ff       	call   8001b7 <ide_write>
		sys_page_map(thisenv->env_id,(void*)round_addr,thisenv->env_id,(void*)round_addr,uvpt[PGNUM((void*)round_addr)]&PTE_SYSCALL);
  80050b:	89 f0                	mov    %esi,%eax
  80050d:	c1 e8 0c             	shr    $0xc,%eax
  800510:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  800517:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80051c:	8b 50 48             	mov    0x48(%eax),%edx
  80051f:	8b 40 48             	mov    0x48(%eax),%eax
  800522:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800528:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80052c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800530:	89 54 24 08          	mov    %edx,0x8(%esp)
  800534:	89 74 24 04          	mov    %esi,0x4(%esp)
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	e8 77 22 00 00       	call   8027b7 <sys_page_map>
	}
	//panic("flush_block not implemented");

}
  800540:	83 c4 20             	add    $0x20,%esp
  800543:	5b                   	pop    %ebx
  800544:	5e                   	pop    %esi
  800545:	5d                   	pop    %ebp
  800546:	c3                   	ret    

00800547 <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	81 ec 28 02 00 00    	sub    $0x228,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800550:	c7 04 24 7a 02 80 00 	movl   $0x80027a,(%esp)
  800557:	e8 34 25 00 00       	call   802a90 <set_pgfault_handler>
check_bc(void)
{
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  80055c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800563:	e8 9f fe ff ff       	call   800407 <diskaddr>
  800568:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  80056f:	00 
  800570:	89 44 24 04          	mov    %eax,0x4(%esp)
  800574:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80057a:	89 04 24             	mov    %eax,(%esp)
  80057d:	e8 62 1f 00 00       	call   8024e4 <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  800582:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800589:	e8 79 fe ff ff       	call   800407 <diskaddr>
  80058e:	c7 44 24 04 43 43 80 	movl   $0x804343,0x4(%esp)
  800595:	00 
  800596:	89 04 24             	mov    %eax,(%esp)
  800599:	e8 a9 1d 00 00       	call   802347 <strcpy>
	flush_block(diskaddr(1));
  80059e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005a5:	e8 5d fe ff ff       	call   800407 <diskaddr>
  8005aa:	89 04 24             	mov    %eax,(%esp)
  8005ad:	e8 e1 fe ff ff       	call   800493 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  8005b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005b9:	e8 49 fe ff ff       	call   800407 <diskaddr>
  8005be:	89 04 24             	mov    %eax,(%esp)
  8005c1:	e8 87 fe ff ff       	call   80044d <va_is_mapped>
  8005c6:	84 c0                	test   %al,%al
  8005c8:	75 24                	jne    8005ee <bc_init+0xa7>
  8005ca:	c7 44 24 0c 65 43 80 	movl   $0x804365,0xc(%esp)
  8005d1:	00 
  8005d2:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  8005d9:	00 
  8005da:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8005e1:	00 
  8005e2:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  8005e9:	e8 34 16 00 00       	call   801c22 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  8005ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005f5:	e8 0d fe ff ff       	call   800407 <diskaddr>
  8005fa:	89 04 24             	mov    %eax,(%esp)
  8005fd:	e8 79 fe ff ff       	call   80047b <va_is_dirty>
  800602:	84 c0                	test   %al,%al
  800604:	74 24                	je     80062a <bc_init+0xe3>
  800606:	c7 44 24 0c 4a 43 80 	movl   $0x80434a,0xc(%esp)
  80060d:	00 
  80060e:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  800615:	00 
  800616:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  80061d:	00 
  80061e:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  800625:	e8 f8 15 00 00       	call   801c22 <_panic>

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  80062a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800631:	e8 d1 fd ff ff       	call   800407 <diskaddr>
  800636:	89 44 24 04          	mov    %eax,0x4(%esp)
  80063a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800641:	e8 c4 21 00 00       	call   80280a <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800646:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80064d:	e8 b5 fd ff ff       	call   800407 <diskaddr>
  800652:	89 04 24             	mov    %eax,(%esp)
  800655:	e8 f3 fd ff ff       	call   80044d <va_is_mapped>
  80065a:	84 c0                	test   %al,%al
  80065c:	74 24                	je     800682 <bc_init+0x13b>
  80065e:	c7 44 24 0c 64 43 80 	movl   $0x804364,0xc(%esp)
  800665:	00 
  800666:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  80066d:	00 
  80066e:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
  800675:	00 
  800676:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  80067d:	e8 a0 15 00 00       	call   801c22 <_panic>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800682:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800689:	e8 79 fd ff ff       	call   800407 <diskaddr>
  80068e:	c7 44 24 04 43 43 80 	movl   $0x804343,0x4(%esp)
  800695:	00 
  800696:	89 04 24             	mov    %eax,(%esp)
  800699:	e8 5e 1d 00 00       	call   8023fc <strcmp>
  80069e:	85 c0                	test   %eax,%eax
  8006a0:	74 24                	je     8006c6 <bc_init+0x17f>
  8006a2:	c7 44 24 0c d0 42 80 	movl   $0x8042d0,0xc(%esp)
  8006a9:	00 
  8006aa:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  8006b1:	00 
  8006b2:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  8006b9:	00 
  8006ba:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  8006c1:	e8 5c 15 00 00       	call   801c22 <_panic>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  8006c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006cd:	e8 35 fd ff ff       	call   800407 <diskaddr>
  8006d2:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  8006d9:	00 
  8006da:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  8006e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006e4:	89 04 24             	mov    %eax,(%esp)
  8006e7:	e8 f8 1d 00 00       	call   8024e4 <memmove>
	flush_block(diskaddr(1));
  8006ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006f3:	e8 0f fd ff ff       	call   800407 <diskaddr>
  8006f8:	89 04 24             	mov    %eax,(%esp)
  8006fb:	e8 93 fd ff ff       	call   800493 <flush_block>

	cprintf("block cache is good\n");
  800700:	c7 04 24 7f 43 80 00 	movl   $0x80437f,(%esp)
  800707:	e8 0f 16 00 00       	call   801d1b <cprintf>
	struct Super super;
	set_pgfault_handler(bc_pgfault);
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  80070c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800713:	e8 ef fc ff ff       	call   800407 <diskaddr>
  800718:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  80071f:	00 
  800720:	89 44 24 04          	mov    %eax,0x4(%esp)
  800724:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072a:	89 04 24             	mov    %eax,(%esp)
  80072d:	e8 b2 1d 00 00       	call   8024e4 <memmove>
}
  800732:	c9                   	leave  
  800733:	c3                   	ret    

00800734 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
  800737:	83 ec 18             	sub    $0x18,%esp
	if (super->s_magic != FS_MAGIC)
  80073a:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80073f:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  800745:	74 1c                	je     800763 <check_super+0x2f>
		panic("bad file system magic number");
  800747:	c7 44 24 08 94 43 80 	movl   $0x804394,0x8(%esp)
  80074e:	00 
  80074f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800756:	00 
  800757:	c7 04 24 b1 43 80 00 	movl   $0x8043b1,(%esp)
  80075e:	e8 bf 14 00 00       	call   801c22 <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800763:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  80076a:	76 1c                	jbe    800788 <check_super+0x54>
		panic("file system is too large");
  80076c:	c7 44 24 08 b9 43 80 	movl   $0x8043b9,0x8(%esp)
  800773:	00 
  800774:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  80077b:	00 
  80077c:	c7 04 24 b1 43 80 00 	movl   $0x8043b1,(%esp)
  800783:	e8 9a 14 00 00       	call   801c22 <_panic>

	cprintf("superblock is good\n");
  800788:	c7 04 24 d2 43 80 00 	movl   $0x8043d2,(%esp)
  80078f:	e8 87 15 00 00       	call   801d1b <cprintf>
}
  800794:	c9                   	leave  
  800795:	c3                   	ret    

00800796 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  80079c:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8007a2:	85 d2                	test   %edx,%edx
  8007a4:	74 22                	je     8007c8 <block_is_free+0x32>
		return 0;
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
  8007ab:	39 4a 04             	cmp    %ecx,0x4(%edx)
  8007ae:	76 1d                	jbe    8007cd <block_is_free+0x37>
		return 0;
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  8007b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8007b5:	d3 e0                	shl    %cl,%eax
  8007b7:	c1 e9 05             	shr    $0x5,%ecx
  8007ba:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  8007c0:	85 04 8a             	test   %eax,(%edx,%ecx,4)
		return 1;
  8007c3:	0f 95 c0             	setne  %al
  8007c6:	eb 05                	jmp    8007cd <block_is_free+0x37>
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
		return 0;
  8007c8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
		return 1;
	return 0;
}
  8007cd:	5d                   	pop    %ebp
  8007ce:	c3                   	ret    

008007cf <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	53                   	push   %ebx
  8007d3:	83 ec 14             	sub    $0x14,%esp
  8007d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  8007d9:	85 c9                	test   %ecx,%ecx
  8007db:	75 1c                	jne    8007f9 <free_block+0x2a>
		panic("attempt to free zero block");
  8007dd:	c7 44 24 08 e6 43 80 	movl   $0x8043e6,0x8(%esp)
  8007e4:	00 
  8007e5:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8007ec:	00 
  8007ed:	c7 04 24 b1 43 80 00 	movl   $0x8043b1,(%esp)
  8007f4:	e8 29 14 00 00       	call   801c22 <_panic>
	bitmap[blockno/32] |= 1<<(blockno%32);
  8007f9:	89 ca                	mov    %ecx,%edx
  8007fb:	c1 ea 05             	shr    $0x5,%edx
  8007fe:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800803:	bb 01 00 00 00       	mov    $0x1,%ebx
  800808:	d3 e3                	shl    %cl,%ebx
  80080a:	09 1c 90             	or     %ebx,(%eax,%edx,4)
}
  80080d:	83 c4 14             	add    $0x14,%esp
  800810:	5b                   	pop    %ebx
  800811:	5d                   	pop    %ebp
  800812:	c3                   	ret    

00800813 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	56                   	push   %esi
  800817:	53                   	push   %ebx
  800818:	83 ec 10             	sub    $0x10,%esp
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t i;
	for(i=0;i<super->s_nblocks;i++)
  80081b:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800820:	8b 70 04             	mov    0x4(%eax),%esi
  800823:	bb 00 00 00 00       	mov    $0x0,%ebx
  800828:	eb 3e                	jmp    800868 <alloc_block+0x55>
	{
		if(block_is_free(i))
  80082a:	89 1c 24             	mov    %ebx,(%esp)
  80082d:	e8 64 ff ff ff       	call   800796 <block_is_free>
  800832:	84 c0                	test   %al,%al
  800834:	74 2f                	je     800865 <alloc_block+0x52>
		{
			bitmap[i/32] &= ~(1<<(i%32));
  800836:	89 d8                	mov    %ebx,%eax
  800838:	c1 e8 05             	shr    $0x5,%eax
  80083b:	c1 e0 02             	shl    $0x2,%eax
  80083e:	89 c2                	mov    %eax,%edx
  800840:	03 15 08 a0 80 00    	add    0x80a008,%edx
  800846:	be 01 00 00 00       	mov    $0x1,%esi
  80084b:	89 d9                	mov    %ebx,%ecx
  80084d:	d3 e6                	shl    %cl,%esi
  80084f:	f7 d6                	not    %esi
  800851:	21 32                	and    %esi,(%edx)
			flush_block((void*)&bitmap[i/32]);
  800853:	03 05 08 a0 80 00    	add    0x80a008,%eax
  800859:	89 04 24             	mov    %eax,(%esp)
  80085c:	e8 32 fc ff ff       	call   800493 <flush_block>
			return i;
  800861:	89 d8                	mov    %ebx,%eax
  800863:	eb 0c                	jmp    800871 <alloc_block+0x5e>
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t i;
	for(i=0;i<super->s_nblocks;i++)
  800865:	83 c3 01             	add    $0x1,%ebx
  800868:	39 f3                	cmp    %esi,%ebx
  80086a:	75 be                	jne    80082a <alloc_block+0x17>
			bitmap[i/32] &= ~(1<<(i%32));
			flush_block((void*)&bitmap[i/32]);
			return i;
		}
	}
	return -E_NO_DISK;
  80086c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
	//panic("alloc_block not implemented");
	//return -E_NO_DISK;

}
  800871:	83 c4 10             	add    $0x10,%esp
  800874:	5b                   	pop    %ebx
  800875:	5e                   	pop    %esi
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	57                   	push   %edi
  80087c:	56                   	push   %esi
  80087d:	53                   	push   %ebx
  80087e:	83 ec 1c             	sub    $0x1c,%esp
  800881:	89 c6                	mov    %eax,%esi
  800883:	89 d3                	mov    %edx,%ebx
  800885:	8b 45 08             	mov    0x8(%ebp),%eax

		uint32_t bno;
		if(filebno >= (NDIRECT+NINDIRECT))
  800888:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  80088e:	0f 87 80 00 00 00    	ja     800914 <file_block_walk+0x9c>
  800894:	89 cf                	mov    %ecx,%edi
			return -E_INVAL;
		if(filebno<NDIRECT)
  800896:	83 fa 09             	cmp    $0x9,%edx
  800899:	77 10                	ja     8008ab <file_block_walk+0x33>
			*ppdiskbno = &f->f_direct[filebno];
  80089b:	8d 84 96 88 00 00 00 	lea    0x88(%esi,%edx,4),%eax
  8008a2:	89 01                	mov    %eax,(%ecx)
			}	
       // LAB 5: Your code here.
       //panic("file_block_walk not implemented");
}
//cprintf("Returning 0\n");	
return 0;
  8008a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a9:	eb 75                	jmp    800920 <file_block_walk+0xa8>
			return -E_INVAL;
		if(filebno<NDIRECT)
			*ppdiskbno = &f->f_direct[filebno];
		else if(filebno<(NDIRECT+NINDIRECT))
		{
			if(f->f_indirect)
  8008ab:	8b 96 b0 00 00 00    	mov    0xb0(%esi),%edx
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	74 15                	je     8008ca <file_block_walk+0x52>
			{
				uint32_t *indirect_address_block = diskaddr(f->f_indirect);
  8008b5:	89 14 24             	mov    %edx,(%esp)
  8008b8:	e8 4a fb ff ff       	call   800407 <diskaddr>
				*ppdiskbno = &indirect_address_block[filebno-NDIRECT];
  8008bd:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  8008c1:	89 07                	mov    %eax,(%edi)
			}	
       // LAB 5: Your code here.
       //panic("file_block_walk not implemented");
}
//cprintf("Returning 0\n");	
return 0;
  8008c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c8:	eb 56                	jmp    800920 <file_block_walk+0xa8>
				uint32_t *indirect_address_block = diskaddr(f->f_indirect);
				*ppdiskbno = &indirect_address_block[filebno-NDIRECT];
			}
			else if(!f->f_indirect)
			{
				if(alloc)
  8008ca:	84 c0                	test   %al,%al
  8008cc:	74 4d                	je     80091b <file_block_walk+0xa3>
				{
					bno = alloc_block();
  8008ce:	e8 40 ff ff ff       	call   800813 <alloc_block>
					if(bno<0)
						return -E_NO_DISK;
					memset(diskaddr(bno),0,BLKSIZE);
  8008d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d6:	89 04 24             	mov    %eax,(%esp)
  8008d9:	e8 29 fb ff ff       	call   800407 <diskaddr>
  8008de:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8008e5:	00 
  8008e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8008ed:	00 
  8008ee:	89 04 24             	mov    %eax,(%esp)
  8008f1:	e8 a1 1b 00 00       	call   802497 <memset>
					f->f_indirect = bno;
  8008f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008f9:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
					uint32_t *indirect_address_block = diskaddr(f->f_indirect);
  8008ff:	89 04 24             	mov    %eax,(%esp)
  800902:	e8 00 fb ff ff       	call   800407 <diskaddr>
					*ppdiskbno = &indirect_address_block[filebno-NDIRECT];
  800907:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  80090b:	89 07                	mov    %eax,(%edi)
			}	
       // LAB 5: Your code here.
       //panic("file_block_walk not implemented");
}
//cprintf("Returning 0\n");	
return 0;
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	eb 0c                	jmp    800920 <file_block_walk+0xa8>
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{

		uint32_t bno;
		if(filebno >= (NDIRECT+NINDIRECT))
			return -E_INVAL;
  800914:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800919:	eb 05                	jmp    800920 <file_block_walk+0xa8>
					f->f_indirect = bno;
					uint32_t *indirect_address_block = diskaddr(f->f_indirect);
					*ppdiskbno = &indirect_address_block[filebno-NDIRECT];
				}
				else
					return -E_NOT_FOUND;
  80091b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
       // LAB 5: Your code here.
       //panic("file_block_walk not implemented");
}
//cprintf("Returning 0\n");	
return 0;
}
  800920:	83 c4 1c             	add    $0x1c,%esp
  800923:	5b                   	pop    %ebx
  800924:	5e                   	pop    %esi
  800925:	5f                   	pop    %edi
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800930:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800935:	8b 70 04             	mov    0x4(%eax),%esi
  800938:	bb 00 00 00 00       	mov    $0x0,%ebx
  80093d:	eb 36                	jmp    800975 <check_bitmap+0x4d>
  80093f:	8d 43 02             	lea    0x2(%ebx),%eax
		assert(!block_is_free(2+i));
  800942:	89 04 24             	mov    %eax,(%esp)
  800945:	e8 4c fe ff ff       	call   800796 <block_is_free>
  80094a:	84 c0                	test   %al,%al
  80094c:	74 24                	je     800972 <check_bitmap+0x4a>
  80094e:	c7 44 24 0c 01 44 80 	movl   $0x804401,0xc(%esp)
  800955:	00 
  800956:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  80095d:	00 
  80095e:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800965:	00 
  800966:	c7 04 24 b1 43 80 00 	movl   $0x8043b1,(%esp)
  80096d:	e8 b0 12 00 00       	call   801c22 <_panic>
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800972:	83 c3 01             	add    $0x1,%ebx
  800975:	89 d8                	mov    %ebx,%eax
  800977:	c1 e0 0f             	shl    $0xf,%eax
  80097a:	39 c6                	cmp    %eax,%esi
  80097c:	77 c1                	ja     80093f <check_bitmap+0x17>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  80097e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800985:	e8 0c fe ff ff       	call   800796 <block_is_free>
  80098a:	84 c0                	test   %al,%al
  80098c:	74 24                	je     8009b2 <check_bitmap+0x8a>
  80098e:	c7 44 24 0c 15 44 80 	movl   $0x804415,0xc(%esp)
  800995:	00 
  800996:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  80099d:	00 
  80099e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8009a5:	00 
  8009a6:	c7 04 24 b1 43 80 00 	movl   $0x8043b1,(%esp)
  8009ad:	e8 70 12 00 00       	call   801c22 <_panic>
	assert(!block_is_free(1));
  8009b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8009b9:	e8 d8 fd ff ff       	call   800796 <block_is_free>
  8009be:	84 c0                	test   %al,%al
  8009c0:	74 24                	je     8009e6 <check_bitmap+0xbe>
  8009c2:	c7 44 24 0c 27 44 80 	movl   $0x804427,0xc(%esp)
  8009c9:	00 
  8009ca:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  8009d1:	00 
  8009d2:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
  8009d9:	00 
  8009da:	c7 04 24 b1 43 80 00 	movl   $0x8043b1,(%esp)
  8009e1:	e8 3c 12 00 00       	call   801c22 <_panic>

	cprintf("bitmap is good\n");
  8009e6:	c7 04 24 39 44 80 00 	movl   $0x804439,(%esp)
  8009ed:	e8 29 13 00 00       	call   801d1b <cprintf>
}
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	5b                   	pop    %ebx
  8009f6:	5e                   	pop    %esi
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    

008009f9 <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);

       // Find a JOS disk.  Use the second IDE disk (number 1) if availabl
       if (ide_probe_disk1())
  8009ff:	e8 5b f6 ff ff       	call   80005f <ide_probe_disk1>
  800a04:	84 c0                	test   %al,%al
  800a06:	74 0e                	je     800a16 <fs_init+0x1d>
               ide_set_disk(1);
  800a08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a0f:	e8 af f6 ff ff       	call   8000c3 <ide_set_disk>
  800a14:	eb 0c                	jmp    800a22 <fs_init+0x29>
       else
               ide_set_disk(0);
  800a16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a1d:	e8 a1 f6 ff ff       	call   8000c3 <ide_set_disk>
	bc_init();
  800a22:	e8 20 fb ff ff       	call   800547 <bc_init>

	// Set "super" to point to the super block.
	super = diskaddr(1);
  800a27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a2e:	e8 d4 f9 ff ff       	call   800407 <diskaddr>
  800a33:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	check_super();
  800a38:	e8 f7 fc ff ff       	call   800734 <check_super>

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  800a3d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800a44:	e8 be f9 ff ff       	call   800407 <diskaddr>
  800a49:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_bitmap();
  800a4e:	e8 d5 fe ff ff       	call   800928 <check_bitmap>
	
}
  800a53:	c9                   	leave  
  800a54:	c3                   	ret    

00800a55 <file_get_block>:
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)

{	
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	53                   	push   %ebx
  800a59:	83 ec 24             	sub    $0x24,%esp
		int r;
	uint32_t *pblockno;

	if ((r = file_block_walk(f, filebno, &pblockno, 1)) != 0) {
  800a5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a63:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	e8 07 fe ff ff       	call   800878 <file_block_walk>
  800a71:	89 c3                	mov    %eax,%ebx
  800a73:	85 c0                	test   %eax,%eax
  800a75:	74 14                	je     800a8b <file_get_block+0x36>
		cprintf("in file_get_block; error from file_block_walk %e\n", r);
  800a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a7b:	c7 04 24 84 44 80 00 	movl   $0x804484,(%esp)
  800a82:	e8 94 12 00 00       	call   801d1b <cprintf>
		return r;
  800a87:	89 d8                	mov    %ebx,%eax
  800a89:	eb 26                	jmp    800ab1 <file_get_block+0x5c>
	}

	// No block mapped at this block number, allocate and assign one
	if (!*pblockno) {
  800a8b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a8e:	83 3b 00             	cmpl   $0x0,(%ebx)
  800a91:	75 07                	jne    800a9a <file_get_block+0x45>
		*pblockno = alloc_block();
  800a93:	e8 7b fd ff ff       	call   800813 <alloc_block>
  800a98:	89 03                	mov    %eax,(%ebx)
		if (*pblockno < 0)
			return -E_NO_DISK;
	}

	*blk = (char *) diskaddr(*pblockno);
  800a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	89 04 24             	mov    %eax,(%esp)
  800aa2:	e8 60 f9 ff ff       	call   800407 <diskaddr>
  800aa7:	8b 55 10             	mov    0x10(%ebp),%edx
  800aaa:	89 02                	mov    %eax,(%edx)
return 0;
  800aac:	b8 00 00 00 00       	mov    $0x0,%eax

}
  800ab1:	83 c4 24             	add    $0x24,%esp
  800ab4:	5b                   	pop    %ebx
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	57                   	push   %edi
  800abb:	56                   	push   %esi
  800abc:	53                   	push   %ebx
  800abd:	81 ec cc 00 00 00    	sub    $0xcc,%esp
  800ac3:	89 95 44 ff ff ff    	mov    %edx,-0xbc(%ebp)
  800ac9:	89 8d 40 ff ff ff    	mov    %ecx,-0xc0(%ebp)
  800acf:	eb 03                	jmp    800ad4 <walk_path+0x1d>
// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
		p++;
  800ad1:	83 c0 01             	add    $0x1,%eax

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  800ad4:	80 38 2f             	cmpb   $0x2f,(%eax)
  800ad7:	74 f8                	je     800ad1 <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800ad9:	8b 0d 0c a0 80 00    	mov    0x80a00c,%ecx
  800adf:	83 c1 08             	add    $0x8,%ecx
  800ae2:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
	dir = 0;
	name[0] = 0;
  800ae8:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800aef:	8b 8d 44 ff ff ff    	mov    -0xbc(%ebp),%ecx
  800af5:	85 c9                	test   %ecx,%ecx
  800af7:	74 06                	je     800aff <walk_path+0x48>
		*pdir = 0;
  800af9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800aff:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800b05:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
	dir = 0;
  800b0b:	ba 00 00 00 00       	mov    $0x0,%edx
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  800b10:	e9 71 01 00 00       	jmp    800c86 <walk_path+0x1cf>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800b15:	83 c7 01             	add    $0x1,%edi
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800b18:	0f b6 17             	movzbl (%edi),%edx
  800b1b:	84 d2                	test   %dl,%dl
  800b1d:	74 05                	je     800b24 <walk_path+0x6d>
  800b1f:	80 fa 2f             	cmp    $0x2f,%dl
  800b22:	75 f1                	jne    800b15 <walk_path+0x5e>
			path++;
		if (path - p >= MAXNAMELEN)
  800b24:	89 fb                	mov    %edi,%ebx
  800b26:	29 c3                	sub    %eax,%ebx
  800b28:	83 fb 7f             	cmp    $0x7f,%ebx
  800b2b:	0f 8f 82 01 00 00    	jg     800cb3 <walk_path+0x1fc>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800b31:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800b35:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b39:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800b3f:	89 04 24             	mov    %eax,(%esp)
  800b42:	e8 9d 19 00 00       	call   8024e4 <memmove>
		name[path - p] = '\0';
  800b47:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800b4e:	00 
  800b4f:	eb 03                	jmp    800b54 <walk_path+0x9d>
// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
		p++;
  800b51:	83 c7 01             	add    $0x1,%edi

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  800b54:	80 3f 2f             	cmpb   $0x2f,(%edi)
  800b57:	74 f8                	je     800b51 <walk_path+0x9a>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800b59:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b5f:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800b66:	0f 85 4e 01 00 00    	jne    800cba <walk_path+0x203>
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  800b6c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800b72:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800b77:	74 24                	je     800b9d <walk_path+0xe6>
  800b79:	c7 44 24 0c 49 44 80 	movl   $0x804449,0xc(%esp)
  800b80:	00 
  800b81:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  800b88:	00 
  800b89:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  800b90:	00 
  800b91:	c7 04 24 b1 43 80 00 	movl   $0x8043b1,(%esp)
  800b98:	e8 85 10 00 00       	call   801c22 <_panic>
	nblock = dir->f_size / BLKSIZE;
  800b9d:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800ba3:	85 c0                	test   %eax,%eax
  800ba5:	0f 48 c2             	cmovs  %edx,%eax
  800ba8:	c1 f8 0c             	sar    $0xc,%eax
  800bab:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
	for (i = 0; i < nblock; i++) {
  800bb1:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
  800bb8:	00 00 00 
  800bbb:	89 bd 48 ff ff ff    	mov    %edi,-0xb8(%ebp)
  800bc1:	eb 61                	jmp    800c24 <walk_path+0x16d>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800bc3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800bc9:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bcd:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bd7:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800bdd:	89 04 24             	mov    %eax,(%esp)
  800be0:	e8 70 fe ff ff       	call   800a55 <file_get_block>
  800be5:	85 c0                	test   %eax,%eax
  800be7:	0f 88 ea 00 00 00    	js     800cd7 <walk_path+0x220>
  800bed:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
			return r;
		f = (struct File*) blk;
  800bf3:	be 10 00 00 00       	mov    $0x10,%esi
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800bf8:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c02:	89 1c 24             	mov    %ebx,(%esp)
  800c05:	e8 f2 17 00 00       	call   8023fc <strcmp>
  800c0a:	85 c0                	test   %eax,%eax
  800c0c:	0f 84 af 00 00 00    	je     800cc1 <walk_path+0x20a>
  800c12:	81 c3 00 01 00 00    	add    $0x100,%ebx
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  800c18:	83 ee 01             	sub    $0x1,%esi
  800c1b:	75 db                	jne    800bf8 <walk_path+0x141>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  800c1d:	83 85 54 ff ff ff 01 	addl   $0x1,-0xac(%ebp)
  800c24:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800c2a:	39 85 4c ff ff ff    	cmp    %eax,-0xb4(%ebp)
  800c30:	75 91                	jne    800bc3 <walk_path+0x10c>
  800c32:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800c38:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800c3d:	80 3f 00             	cmpb   $0x0,(%edi)
  800c40:	0f 85 a0 00 00 00    	jne    800ce6 <walk_path+0x22f>
				if (pdir)
  800c46:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c4c:	85 c0                	test   %eax,%eax
  800c4e:	74 08                	je     800c58 <walk_path+0x1a1>
					*pdir = dir;
  800c50:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800c56:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800c58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c5c:	74 15                	je     800c73 <walk_path+0x1bc>
					strcpy(lastelem, name);
  800c5e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	89 04 24             	mov    %eax,(%esp)
  800c6e:	e8 d4 16 00 00       	call   802347 <strcpy>
				*pf = 0;
  800c73:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800c79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			}
			return r;
  800c7f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800c84:	eb 60                	jmp    800ce6 <walk_path+0x22f>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  800c86:	80 38 00             	cmpb   $0x0,(%eax)
  800c89:	74 07                	je     800c92 <walk_path+0x1db>
  800c8b:	89 c7                	mov    %eax,%edi
  800c8d:	e9 86 fe ff ff       	jmp    800b18 <walk_path+0x61>
			}
			return r;
		}
	}

	if (pdir)
  800c92:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c98:	85 c0                	test   %eax,%eax
  800c9a:	74 02                	je     800c9e <walk_path+0x1e7>
		*pdir = dir;
  800c9c:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800c9e:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800ca4:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800caa:	89 08                	mov    %ecx,(%eax)
	return 0;
  800cac:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb1:	eb 33                	jmp    800ce6 <walk_path+0x22f>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
		if (path - p >= MAXNAMELEN)
			return -E_BAD_PATH;
  800cb3:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800cb8:	eb 2c                	jmp    800ce6 <walk_path+0x22f>
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;
  800cba:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800cbf:	eb 25                	jmp    800ce6 <walk_path+0x22f>
  800cc1:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
  800cc7:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800ccd:	89 9d 50 ff ff ff    	mov    %ebx,-0xb0(%ebp)
  800cd3:	89 f8                	mov    %edi,%eax
  800cd5:	eb af                	jmp    800c86 <walk_path+0x1cf>
  800cd7:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800cdd:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800ce0:	0f 84 52 ff ff ff    	je     800c38 <walk_path+0x181>

	if (pdir)
		*pdir = dir;
	*pf = f;
	return 0;
}
  800ce6:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	83 ec 18             	sub    $0x18,%esp
	return walk_path(path, 0, pf, 0);
  800cf7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d01:	ba 00 00 00 00       	mov    $0x0,%edx
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	e8 a9 fd ff ff       	call   800ab7 <walk_path>
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	57                   	push   %edi
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
  800d16:	83 ec 3c             	sub    $0x3c,%esp
  800d19:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d1c:	8b 55 14             	mov    0x14(%ebp),%edx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
		return 0;
  800d28:	b8 00 00 00 00       	mov    $0x0,%eax
{
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800d2d:	39 d1                	cmp    %edx,%ecx
  800d2f:	0f 8e 83 00 00 00    	jle    800db8 <file_read+0xa8>
		return 0;

	count = MIN(count, f->f_size - offset);
  800d35:	29 d1                	sub    %edx,%ecx
  800d37:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d3a:	0f 47 4d 10          	cmova  0x10(%ebp),%ecx
  800d3e:	89 4d d0             	mov    %ecx,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800d41:	89 d3                	mov    %edx,%ebx
  800d43:	01 ca                	add    %ecx,%edx
  800d45:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800d48:	eb 64                	jmp    800dae <file_read+0x9e>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800d4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800d4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d51:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800d57:	85 db                	test   %ebx,%ebx
  800d59:	0f 49 c3             	cmovns %ebx,%eax
  800d5c:	c1 f8 0c             	sar    $0xc,%eax
  800d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	89 04 24             	mov    %eax,(%esp)
  800d69:	e8 e7 fc ff ff       	call   800a55 <file_get_block>
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	78 46                	js     800db8 <file_read+0xa8>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800d72:	89 da                	mov    %ebx,%edx
  800d74:	c1 fa 1f             	sar    $0x1f,%edx
  800d77:	c1 ea 14             	shr    $0x14,%edx
  800d7a:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800d7d:	25 ff 0f 00 00       	and    $0xfff,%eax
  800d82:	29 d0                	sub    %edx,%eax
  800d84:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800d89:	29 c1                	sub    %eax,%ecx
  800d8b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800d8e:	29 f2                	sub    %esi,%edx
  800d90:	39 d1                	cmp    %edx,%ecx
  800d92:	89 d6                	mov    %edx,%esi
  800d94:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800d97:	89 74 24 08          	mov    %esi,0x8(%esp)
  800d9b:	03 45 e4             	add    -0x1c(%ebp),%eax
  800d9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800da2:	89 3c 24             	mov    %edi,(%esp)
  800da5:	e8 3a 17 00 00       	call   8024e4 <memmove>
		pos += bn;
  800daa:	01 f3                	add    %esi,%ebx
		buf += bn;
  800dac:	01 f7                	add    %esi,%edi
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  800dae:	89 de                	mov    %ebx,%esi
  800db0:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
  800db3:	72 95                	jb     800d4a <file_read+0x3a>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  800db5:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800db8:	83 c4 3c             	add    $0x3c,%esp
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5f                   	pop    %edi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    

00800dc0 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	57                   	push   %edi
  800dc4:	56                   	push   %esi
  800dc5:	53                   	push   %ebx
  800dc6:	83 ec 2c             	sub    $0x2c,%esp
  800dc9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (f->f_size > newsize)
  800dcc:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800dd2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dd5:	0f 8e 9a 00 00 00    	jle    800e75 <file_set_size+0xb5>
file_truncate_blocks(struct File *f, off_t newsize)
{
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800ddb:	8d b8 fe 1f 00 00    	lea    0x1ffe(%eax),%edi
  800de1:	05 ff 0f 00 00       	add    $0xfff,%eax
  800de6:	0f 49 f8             	cmovns %eax,%edi
  800de9:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800def:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800df5:	05 ff 0f 00 00       	add    $0xfff,%eax
  800dfa:	0f 48 c2             	cmovs  %edx,%eax
  800dfd:	c1 f8 0c             	sar    $0xc,%eax
  800e00:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800e03:	89 c3                	mov    %eax,%ebx
  800e05:	eb 34                	jmp    800e3b <file_set_size+0x7b>
file_free_block(struct File *f, uint32_t filebno)
{
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800e07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e0e:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800e11:	89 da                	mov    %ebx,%edx
  800e13:	89 f0                	mov    %esi,%eax
  800e15:	e8 5e fa ff ff       	call   800878 <file_block_walk>
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	78 45                	js     800e63 <file_set_size+0xa3>
		return r;
	if (*ptr) {
  800e1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e21:	8b 00                	mov    (%eax),%eax
  800e23:	85 c0                	test   %eax,%eax
  800e25:	74 11                	je     800e38 <file_set_size+0x78>
		free_block(*ptr);
  800e27:	89 04 24             	mov    %eax,(%esp)
  800e2a:	e8 a0 f9 ff ff       	call   8007cf <free_block>
		*ptr = 0;
  800e2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800e38:	83 c3 01             	add    $0x1,%ebx
  800e3b:	39 df                	cmp    %ebx,%edi
  800e3d:	77 c8                	ja     800e07 <file_set_size+0x47>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800e3f:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  800e43:	77 30                	ja     800e75 <file_set_size+0xb5>
  800e45:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800e4b:	85 c0                	test   %eax,%eax
  800e4d:	74 26                	je     800e75 <file_set_size+0xb5>
		free_block(f->f_indirect);
  800e4f:	89 04 24             	mov    %eax,(%esp)
  800e52:	e8 78 f9 ff ff       	call   8007cf <free_block>
		f->f_indirect = 0;
  800e57:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800e5e:	00 00 00 
  800e61:	eb 12                	jmp    800e75 <file_set_size+0xb5>

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);
  800e63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e67:	c7 04 24 66 44 80 00 	movl   $0x804466,(%esp)
  800e6e:	e8 a8 0e 00 00       	call   801d1b <cprintf>
  800e73:	eb c3                	jmp    800e38 <file_set_size+0x78>
int
file_set_size(struct File *f, off_t newsize)
{
	if (f->f_size > newsize)
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	flush_block(f);
  800e7e:	89 34 24             	mov    %esi,(%esp)
  800e81:	e8 0d f6 ff ff       	call   800493 <flush_block>
	return 0;
}
  800e86:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8b:	83 c4 2c             	add    $0x2c,%esp
  800e8e:	5b                   	pop    %ebx
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	57                   	push   %edi
  800e97:	56                   	push   %esi
  800e98:	53                   	push   %ebx
  800e99:	83 ec 2c             	sub    $0x2c,%esp
  800e9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e9f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  800ea2:	89 d8                	mov    %ebx,%eax
  800ea4:	03 45 10             	add    0x10(%ebp),%eax
  800ea7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800eaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ead:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  800eb3:	76 7c                	jbe    800f31 <file_write+0x9e>
		if ((r = file_set_size(f, offset + count)) < 0)
  800eb5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800eb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	89 04 24             	mov    %eax,(%esp)
  800ec2:	e8 f9 fe ff ff       	call   800dc0 <file_set_size>
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	79 66                	jns    800f31 <file_write+0x9e>
  800ecb:	eb 6e                	jmp    800f3b <file_write+0xa8>
			return r;

	for (pos = offset; pos < offset + count; ) {
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800ecd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ed0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ed4:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800eda:	85 db                	test   %ebx,%ebx
  800edc:	0f 49 c3             	cmovns %ebx,%eax
  800edf:	c1 f8 0c             	sar    $0xc,%eax
  800ee2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	89 04 24             	mov    %eax,(%esp)
  800eec:	e8 64 fb ff ff       	call   800a55 <file_get_block>
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	78 46                	js     800f3b <file_write+0xa8>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800ef5:	89 da                	mov    %ebx,%edx
  800ef7:	c1 fa 1f             	sar    $0x1f,%edx
  800efa:	c1 ea 14             	shr    $0x14,%edx
  800efd:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800f00:	25 ff 0f 00 00       	and    $0xfff,%eax
  800f05:	29 d0                	sub    %edx,%eax
  800f07:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800f0c:	29 c1                	sub    %eax,%ecx
  800f0e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f11:	29 f2                	sub    %esi,%edx
  800f13:	39 d1                	cmp    %edx,%ecx
  800f15:	89 d6                	mov    %edx,%esi
  800f17:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  800f1a:	89 74 24 08          	mov    %esi,0x8(%esp)
  800f1e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f22:	03 45 e4             	add    -0x1c(%ebp),%eax
  800f25:	89 04 24             	mov    %eax,(%esp)
  800f28:	e8 b7 15 00 00       	call   8024e4 <memmove>
		pos += bn;
  800f2d:	01 f3                	add    %esi,%ebx
		buf += bn;
  800f2f:	01 f7                	add    %esi,%edi
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  800f31:	89 de                	mov    %ebx,%esi
  800f33:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800f36:	77 95                	ja     800ecd <file_write+0x3a>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800f3b:	83 c4 2c             	add    $0x2c,%esp
  800f3e:	5b                   	pop    %ebx
  800f3f:	5e                   	pop    %esi
  800f40:	5f                   	pop    %edi
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
  800f48:	83 ec 20             	sub    $0x20,%esp
  800f4b:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800f4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f53:	eb 37                	jmp    800f8c <file_flush+0x49>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800f55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f5c:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800f5f:	89 da                	mov    %ebx,%edx
  800f61:	89 f0                	mov    %esi,%eax
  800f63:	e8 10 f9 ff ff       	call   800878 <file_block_walk>
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	78 1d                	js     800f89 <file_flush+0x46>
		    pdiskbno == NULL || *pdiskbno == 0)
  800f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800f6f:	85 c0                	test   %eax,%eax
  800f71:	74 16                	je     800f89 <file_flush+0x46>
		    pdiskbno == NULL || *pdiskbno == 0)
  800f73:	8b 00                	mov    (%eax),%eax
  800f75:	85 c0                	test   %eax,%eax
  800f77:	74 10                	je     800f89 <file_flush+0x46>
			continue;
		flush_block(diskaddr(*pdiskbno));
  800f79:	89 04 24             	mov    %eax,(%esp)
  800f7c:	e8 86 f4 ff ff       	call   800407 <diskaddr>
  800f81:	89 04 24             	mov    %eax,(%esp)
  800f84:	e8 0a f5 ff ff       	call   800493 <flush_block>
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800f89:	83 c3 01             	add    $0x1,%ebx
  800f8c:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  800f92:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  800f98:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  800f9e:	85 c9                	test   %ecx,%ecx
  800fa0:	0f 49 c1             	cmovns %ecx,%eax
  800fa3:	c1 f8 0c             	sar    $0xc,%eax
  800fa6:	39 c3                	cmp    %eax,%ebx
  800fa8:	7c ab                	jl     800f55 <file_flush+0x12>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  800faa:	89 34 24             	mov    %esi,(%esp)
  800fad:	e8 e1 f4 ff ff       	call   800493 <flush_block>
	if (f->f_indirect)
  800fb2:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	74 10                	je     800fcc <file_flush+0x89>
		flush_block(diskaddr(f->f_indirect));
  800fbc:	89 04 24             	mov    %eax,(%esp)
  800fbf:	e8 43 f4 ff ff       	call   800407 <diskaddr>
  800fc4:	89 04 24             	mov    %eax,(%esp)
  800fc7:	e8 c7 f4 ff ff       	call   800493 <flush_block>
}
  800fcc:	83 c4 20             	add    $0x20,%esp
  800fcf:	5b                   	pop    %ebx
  800fd0:	5e                   	pop    %esi
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    

00800fd3 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	57                   	push   %edi
  800fd7:	56                   	push   %esi
  800fd8:	53                   	push   %ebx
  800fd9:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  800fdf:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800fe5:	89 04 24             	mov    %eax,(%esp)
  800fe8:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  800fee:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	e8 bb fa ff ff       	call   800ab7 <walk_path>
  800ffc:	89 c2                	mov    %eax,%edx
  800ffe:	85 c0                	test   %eax,%eax
  801000:	0f 84 e0 00 00 00    	je     8010e6 <file_create+0x113>
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
  801006:	83 fa f5             	cmp    $0xfffffff5,%edx
  801009:	0f 85 1b 01 00 00    	jne    80112a <file_create+0x157>
  80100f:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  801015:	85 f6                	test   %esi,%esi
  801017:	0f 84 d0 00 00 00    	je     8010ed <file_create+0x11a>
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  80101d:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  801023:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801028:	74 24                	je     80104e <file_create+0x7b>
  80102a:	c7 44 24 0c 49 44 80 	movl   $0x804449,0xc(%esp)
  801031:	00 
  801032:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  801039:	00 
  80103a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801041:	00 
  801042:	c7 04 24 b1 43 80 00 	movl   $0x8043b1,(%esp)
  801049:	e8 d4 0b 00 00       	call   801c22 <_panic>
	nblock = dir->f_size / BLKSIZE;
  80104e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  801054:	85 c0                	test   %eax,%eax
  801056:	0f 48 c2             	cmovs  %edx,%eax
  801059:	c1 f8 0c             	sar    $0xc,%eax
  80105c:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
  801062:	bb 00 00 00 00       	mov    $0x0,%ebx
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801067:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  80106d:	eb 3d                	jmp    8010ac <file_create+0xd9>
  80106f:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801073:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801077:	89 34 24             	mov    %esi,(%esp)
  80107a:	e8 d6 f9 ff ff       	call   800a55 <file_get_block>
  80107f:	85 c0                	test   %eax,%eax
  801081:	0f 88 a3 00 00 00    	js     80112a <file_create+0x157>
  801087:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
			return r;
		f = (struct File*) blk;
  80108d:	ba 10 00 00 00       	mov    $0x10,%edx
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0') {
  801092:	80 38 00             	cmpb   $0x0,(%eax)
  801095:	75 08                	jne    80109f <file_create+0xcc>
				*file = &f[j];
  801097:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  80109d:	eb 55                	jmp    8010f4 <file_create+0x121>
  80109f:	05 00 01 00 00       	add    $0x100,%eax
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8010a4:	83 ea 01             	sub    $0x1,%edx
  8010a7:	75 e9                	jne    801092 <file_create+0xbf>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8010a9:	83 c3 01             	add    $0x1,%ebx
  8010ac:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  8010b2:	75 bb                	jne    80106f <file_create+0x9c>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  8010b4:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  8010bb:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  8010be:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  8010c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010cc:	89 34 24             	mov    %esi,(%esp)
  8010cf:	e8 81 f9 ff ff       	call   800a55 <file_get_block>
  8010d4:	85 c0                	test   %eax,%eax
  8010d6:	78 52                	js     80112a <file_create+0x157>
		return r;
	f = (struct File*) blk;
	*file = &f[0];
  8010d8:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8010de:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8010e4:	eb 0e                	jmp    8010f4 <file_create+0x121>
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
		return -E_FILE_EXISTS;
  8010e6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8010eb:	eb 3d                	jmp    80112a <file_create+0x157>
	if (r != -E_NOT_FOUND || dir == 0)
		return r;
  8010ed:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8010f2:	eb 36                	jmp    80112a <file_create+0x157>
	if ((r = dir_alloc_file(dir, &f)) < 0)
		return r;

	strcpy(f->f_name, name);
  8010f4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8010fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010fe:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801104:	89 04 24             	mov    %eax,(%esp)
  801107:	e8 3b 12 00 00       	call   802347 <strcpy>
	*pf = f;
  80110c:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  801117:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80111d:	89 04 24             	mov    %eax,(%esp)
  801120:	e8 1e fe ff ff       	call   800f43 <file_flush>
	return 0;
  801125:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112a:	81 c4 bc 00 00 00    	add    $0xbc,%esp
  801130:	5b                   	pop    %ebx
  801131:	5e                   	pop    %esi
  801132:	5f                   	pop    %edi
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	53                   	push   %ebx
  801139:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  80113c:	bb 01 00 00 00       	mov    $0x1,%ebx
  801141:	eb 13                	jmp    801156 <fs_sync+0x21>
		flush_block(diskaddr(i));
  801143:	89 1c 24             	mov    %ebx,(%esp)
  801146:	e8 bc f2 ff ff       	call   800407 <diskaddr>
  80114b:	89 04 24             	mov    %eax,(%esp)
  80114e:	e8 40 f3 ff ff       	call   800493 <flush_block>
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801153:	83 c3 01             	add    $0x1,%ebx
  801156:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80115b:	3b 58 04             	cmp    0x4(%eax),%ebx
  80115e:	72 e3                	jb     801143 <fs_sync+0xe>
		flush_block(diskaddr(i));
}
  801160:	83 c4 14             	add    $0x14,%esp
  801163:	5b                   	pop    %ebx
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    
  801166:	66 90                	xchg   %ax,%ax
  801168:	66 90                	xchg   %ax,%ax
  80116a:	66 90                	xchg   %ax,%ax
  80116c:	66 90                	xchg   %ax,%ax
  80116e:	66 90                	xchg   %ax,%ax

00801170 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  801176:	e8 ba ff ff ff       	call   801135 <fs_sync>
	return 0;
}
  80117b:	b8 00 00 00 00       	mov    $0x0,%eax
  801180:	c9                   	leave  
  801181:	c3                   	ret    

00801182 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	ba 60 50 80 00       	mov    $0x805060,%edx
	int i;
	uintptr_t va = FILEVA;
  80118a:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  80118f:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801194:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  801196:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  801199:	81 c1 00 10 00 00    	add    $0x1000,%ecx
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  80119f:	83 c0 01             	add    $0x1,%eax
  8011a2:	83 c2 10             	add    $0x10,%edx
  8011a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8011aa:	75 e8                	jne    801194 <serve_init+0x12>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  8011ac:	5d                   	pop    %ebp
  8011ad:	c3                   	ret    

008011ae <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	56                   	push   %esi
  8011b2:	53                   	push   %ebx
  8011b3:	83 ec 10             	sub    $0x10,%esp
  8011b6:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8011b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011be:	89 d8                	mov    %ebx,%eax
  8011c0:	c1 e0 04             	shl    $0x4,%eax
		switch (pageref(opentab[i].o_fd)) {
  8011c3:	8b 80 6c 50 80 00    	mov    0x80506c(%eax),%eax
  8011c9:	89 04 24             	mov    %eax,(%esp)
  8011cc:	e8 dd 22 00 00       	call   8034ae <pageref>
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	74 0d                	je     8011e2 <openfile_alloc+0x34>
  8011d5:	83 f8 01             	cmp    $0x1,%eax
  8011d8:	74 31                	je     80120b <openfile_alloc+0x5d>
  8011da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011e0:	eb 62                	jmp    801244 <openfile_alloc+0x96>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  8011e2:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011e9:	00 
  8011ea:	89 d8                	mov    %ebx,%eax
  8011ec:	c1 e0 04             	shl    $0x4,%eax
  8011ef:	8b 80 6c 50 80 00    	mov    0x80506c(%eax),%eax
  8011f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801200:	e8 5e 15 00 00       	call   802763 <sys_page_alloc>
  801205:	89 c2                	mov    %eax,%edx
  801207:	85 d2                	test   %edx,%edx
  801209:	78 4d                	js     801258 <openfile_alloc+0xaa>
				return r;
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  80120b:	c1 e3 04             	shl    $0x4,%ebx
  80120e:	8d 83 60 50 80 00    	lea    0x805060(%ebx),%eax
  801214:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  80121b:	04 00 00 
			*o = &opentab[i];
  80121e:	89 06                	mov    %eax,(%esi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  801220:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801227:	00 
  801228:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80122f:	00 
  801230:	8b 83 6c 50 80 00    	mov    0x80506c(%ebx),%eax
  801236:	89 04 24             	mov    %eax,(%esp)
  801239:	e8 59 12 00 00       	call   802497 <memset>
			return (*o)->o_fileid;
  80123e:	8b 06                	mov    (%esi),%eax
  801240:	8b 00                	mov    (%eax),%eax
  801242:	eb 14                	jmp    801258 <openfile_alloc+0xaa>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801244:	83 c3 01             	add    $0x1,%ebx
  801247:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  80124d:	0f 85 6b ff ff ff    	jne    8011be <openfile_alloc+0x10>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  801253:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801258:	83 c4 10             	add    $0x10,%esp
  80125b:	5b                   	pop    %ebx
  80125c:	5e                   	pop    %esi
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    

0080125f <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	57                   	push   %edi
  801263:	56                   	push   %esi
  801264:	53                   	push   %ebx
  801265:	83 ec 1c             	sub    $0x1c,%esp
  801268:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  80126b:	89 de                	mov    %ebx,%esi
  80126d:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801273:	c1 e6 04             	shl    $0x4,%esi
  801276:	8d be 60 50 80 00    	lea    0x805060(%esi),%edi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  80127c:	8b 86 6c 50 80 00    	mov    0x80506c(%esi),%eax
  801282:	89 04 24             	mov    %eax,(%esp)
  801285:	e8 24 22 00 00       	call   8034ae <pageref>
  80128a:	83 f8 01             	cmp    $0x1,%eax
  80128d:	7e 14                	jle    8012a3 <openfile_lookup+0x44>
  80128f:	39 9e 60 50 80 00    	cmp    %ebx,0x805060(%esi)
  801295:	75 13                	jne    8012aa <openfile_lookup+0x4b>
		return -E_INVAL;
	*po = o;
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	89 38                	mov    %edi,(%eax)
	return 0;
  80129c:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a1:	eb 0c                	jmp    8012af <openfile_lookup+0x50>
{
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
		return -E_INVAL;
  8012a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a8:	eb 05                	jmp    8012af <openfile_lookup+0x50>
  8012aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	*po = o;
	return 0;
}
  8012af:	83 c4 1c             	add    $0x1c,%esp
  8012b2:	5b                   	pop    %ebx
  8012b3:	5e                   	pop    %esi
  8012b4:	5f                   	pop    %edi
  8012b5:	5d                   	pop    %ebp
  8012b6:	c3                   	ret    

008012b7 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	53                   	push   %ebx
  8012bb:	83 ec 24             	sub    $0x24,%esp
  8012be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8012c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012c8:	8b 03                	mov    (%ebx),%eax
  8012ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	89 04 24             	mov    %eax,(%esp)
  8012d4:	e8 86 ff ff ff       	call   80125f <openfile_lookup>
  8012d9:	89 c2                	mov    %eax,%edx
  8012db:	85 d2                	test   %edx,%edx
  8012dd:	78 15                	js     8012f4 <serve_set_size+0x3d>
		return r;

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  8012df:	8b 43 04             	mov    0x4(%ebx),%eax
  8012e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e9:	8b 40 04             	mov    0x4(%eax),%eax
  8012ec:	89 04 24             	mov    %eax,(%esp)
  8012ef:	e8 cc fa ff ff       	call   800dc0 <file_set_size>
}
  8012f4:	83 c4 24             	add    $0x24,%esp
  8012f7:	5b                   	pop    %ebx
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    

008012fa <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	53                   	push   %ebx
  8012fe:	83 ec 24             	sub    $0x24,%esp
  801301:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if (debug)
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// Lab 5: Your code here:

	if ((r = openfile_lookup(envid, ipc->read.req_fileid, &o)) < 0)
  801304:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801307:	89 44 24 08          	mov    %eax,0x8(%esp)
  80130b:	8b 03                	mov    (%ebx),%eax
  80130d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 04 24             	mov    %eax,(%esp)
  801317:	e8 43 ff ff ff       	call   80125f <openfile_lookup>
		return r;
  80131c:	89 c2                	mov    %eax,%edx
	if (debug)
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// Lab 5: Your code here:

	if ((r = openfile_lookup(envid, ipc->read.req_fileid, &o)) < 0)
  80131e:	85 c0                	test   %eax,%eax
  801320:	78 34                	js     801356 <serve_read+0x5c>
		return r;
	if ((r = file_read(o->o_file,ret,ipc->read.req_n,o->o_fd->fd_offset)) > 0)
  801322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801325:	8b 50 0c             	mov    0xc(%eax),%edx
  801328:	8b 52 04             	mov    0x4(%edx),%edx
  80132b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80132f:	8b 53 04             	mov    0x4(%ebx),%edx
  801332:	89 54 24 08          	mov    %edx,0x8(%esp)
  801336:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80133a:	8b 40 04             	mov    0x4(%eax),%eax
  80133d:	89 04 24             	mov    %eax,(%esp)
  801340:	e8 cb f9 ff ff       	call   800d10 <file_read>
	{	
	o->o_fd->fd_offset = o->o_fd->fd_offset+r;
}
	return r;
  801345:	89 c2                	mov    %eax,%edx

	// Lab 5: Your code here:

	if ((r = openfile_lookup(envid, ipc->read.req_fileid, &o)) < 0)
		return r;
	if ((r = file_read(o->o_file,ret,ipc->read.req_n,o->o_fd->fd_offset)) > 0)
  801347:	85 c0                	test   %eax,%eax
  801349:	7e 0b                	jle    801356 <serve_read+0x5c>
	{	
	o->o_fd->fd_offset = o->o_fd->fd_offset+r;
  80134b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134e:	8b 52 0c             	mov    0xc(%edx),%edx
  801351:	01 42 04             	add    %eax,0x4(%edx)
}
	return r;
  801354:	89 c2                	mov    %eax,%edx
}
  801356:	89 d0                	mov    %edx,%eax
  801358:	83 c4 24             	add    $0x24,%esp
  80135b:	5b                   	pop    %ebx
  80135c:	5d                   	pop    %ebp
  80135d:	c3                   	ret    

0080135e <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	53                   	push   %ebx
  801362:	83 ec 24             	sub    $0x24,%esp
  801365:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);
	struct OpenFile *o;
	if((r= openfile_lookup(envid,req->req_fileid,&o))<0)
  801368:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80136f:	8b 03                	mov    (%ebx),%eax
  801371:	89 44 24 04          	mov    %eax,0x4(%esp)
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	89 04 24             	mov    %eax,(%esp)
  80137b:	e8 df fe ff ff       	call   80125f <openfile_lookup>
		return r;
  801380:	89 c2                	mov    %eax,%edx
{
	int r;
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);
	struct OpenFile *o;
	if((r= openfile_lookup(envid,req->req_fileid,&o))<0)
  801382:	85 c0                	test   %eax,%eax
  801384:	78 37                	js     8013bd <serve_write+0x5f>
		return r;
	if((r=file_write(o->o_file,req->req_buf,req->req_n,o->o_fd->fd_offset))>0)
  801386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801389:	8b 50 0c             	mov    0xc(%eax),%edx
  80138c:	8b 52 04             	mov    0x4(%edx),%edx
  80138f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801393:	8b 53 04             	mov    0x4(%ebx),%edx
  801396:	89 54 24 08          	mov    %edx,0x8(%esp)
  80139a:	83 c3 08             	add    $0x8,%ebx
  80139d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013a1:	8b 40 04             	mov    0x4(%eax),%eax
  8013a4:	89 04 24             	mov    %eax,(%esp)
  8013a7:	e8 e7 fa ff ff       	call   800e93 <file_write>
		o->o_fd->fd_offset = o->o_fd->fd_offset+r;
	return r;
  8013ac:	89 c2                	mov    %eax,%edx
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);
	struct OpenFile *o;
	if((r= openfile_lookup(envid,req->req_fileid,&o))<0)
		return r;
	if((r=file_write(o->o_file,req->req_buf,req->req_n,o->o_fd->fd_offset))>0)
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	7e 0b                	jle    8013bd <serve_write+0x5f>
		o->o_fd->fd_offset = o->o_fd->fd_offset+r;
  8013b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8013b8:	01 42 04             	add    %eax,0x4(%edx)
	return r;
  8013bb:	89 c2                	mov    %eax,%edx

	// LAB 5: Your code here.
	//panic("serve_write not implemented");


}
  8013bd:	89 d0                	mov    %edx,%eax
  8013bf:	83 c4 24             	add    $0x24,%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    

008013c5 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	53                   	push   %ebx
  8013c9:	83 ec 24             	sub    $0x24,%esp
  8013cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013d6:	8b 03                	mov    (%ebx),%eax
  8013d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	89 04 24             	mov    %eax,(%esp)
  8013e2:	e8 78 fe ff ff       	call   80125f <openfile_lookup>
  8013e7:	89 c2                	mov    %eax,%edx
  8013e9:	85 d2                	test   %edx,%edx
  8013eb:	78 3f                	js     80142c <serve_stat+0x67>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  8013ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f0:	8b 40 04             	mov    0x4(%eax),%eax
  8013f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f7:	89 1c 24             	mov    %ebx,(%esp)
  8013fa:	e8 48 0f 00 00       	call   802347 <strcpy>
	ret->ret_size = o->o_file->f_size;
  8013ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801402:	8b 50 04             	mov    0x4(%eax),%edx
  801405:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  80140b:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  801411:	8b 40 04             	mov    0x4(%eax),%eax
  801414:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  80141b:	0f 94 c0             	sete   %al
  80141e:	0f b6 c0             	movzbl %al,%eax
  801421:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801427:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142c:	83 c4 24             	add    $0x24,%esp
  80142f:	5b                   	pop    %ebx
  801430:	5d                   	pop    %ebp
  801431:	c3                   	ret    

00801432 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 28             	sub    $0x28,%esp
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801438:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	8b 00                	mov    (%eax),%eax
  801444:	89 44 24 04          	mov    %eax,0x4(%esp)
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	89 04 24             	mov    %eax,(%esp)
  80144e:	e8 0c fe ff ff       	call   80125f <openfile_lookup>
  801453:	89 c2                	mov    %eax,%edx
  801455:	85 d2                	test   %edx,%edx
  801457:	78 13                	js     80146c <serve_flush+0x3a>
		return r;
	file_flush(o->o_file);
  801459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145c:	8b 40 04             	mov    0x4(%eax),%eax
  80145f:	89 04 24             	mov    %eax,(%esp)
  801462:	e8 dc fa ff ff       	call   800f43 <file_flush>
	return 0;
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	53                   	push   %ebx
  801472:	81 ec 24 04 00 00    	sub    $0x424,%esp
  801478:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  80147b:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  801482:	00 
  801483:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801487:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80148d:	89 04 24             	mov    %eax,(%esp)
  801490:	e8 4f 10 00 00       	call   8024e4 <memmove>
	path[MAXPATHLEN-1] = 0;
  801495:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  801499:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  80149f:	89 04 24             	mov    %eax,(%esp)
  8014a2:	e8 07 fd ff ff       	call   8011ae <openfile_alloc>
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	0f 88 f2 00 00 00    	js     8015a1 <serve_open+0x133>
		return r;
	}
	fileid = r;

	// Open the file
	if (req->req_omode & O_CREAT) {
  8014af:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  8014b6:	74 34                	je     8014ec <serve_open+0x7e>
		if ((r = file_create(path, &f)) < 0) {
  8014b8:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c2:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014c8:	89 04 24             	mov    %eax,(%esp)
  8014cb:	e8 03 fb ff ff       	call   800fd3 <file_create>
  8014d0:	89 c2                	mov    %eax,%edx
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	79 36                	jns    80150c <serve_open+0x9e>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8014d6:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  8014dd:	0f 85 be 00 00 00    	jne    8015a1 <serve_open+0x133>
  8014e3:	83 fa f3             	cmp    $0xfffffff3,%edx
  8014e6:	0f 85 b5 00 00 00    	jne    8015a1 <serve_open+0x133>
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  8014ec:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f6:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014fc:	89 04 24             	mov    %eax,(%esp)
  8014ff:	e8 ed f7 ff ff       	call   800cf1 <file_open>
  801504:	85 c0                	test   %eax,%eax
  801506:	0f 88 95 00 00 00    	js     8015a1 <serve_open+0x133>
			return r;
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  80150c:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  801513:	74 1a                	je     80152f <serve_open+0xc1>
		if ((r = file_set_size(f, 0)) < 0) {
  801515:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80151c:	00 
  80151d:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  801523:	89 04 24             	mov    %eax,(%esp)
  801526:	e8 95 f8 ff ff       	call   800dc0 <file_set_size>
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 72                	js     8015a1 <serve_open+0x133>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
		}
	}
	if ((r = file_open(path, &f)) < 0) {
  80152f:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801535:	89 44 24 04          	mov    %eax,0x4(%esp)
  801539:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80153f:	89 04 24             	mov    %eax,(%esp)
  801542:	e8 aa f7 ff ff       	call   800cf1 <file_open>
  801547:	85 c0                	test   %eax,%eax
  801549:	78 56                	js     8015a1 <serve_open+0x133>
			cprintf("file_open failed: %e", r);
		return r;
	}

	// Save the file pointer
	o->o_file = f;
  80154b:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801551:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  801557:	89 50 04             	mov    %edx,0x4(%eax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  80155a:	8b 50 0c             	mov    0xc(%eax),%edx
  80155d:	8b 08                	mov    (%eax),%ecx
  80155f:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801562:	8b 50 0c             	mov    0xc(%eax),%edx
  801565:	8b 8b 00 04 00 00    	mov    0x400(%ebx),%ecx
  80156b:	83 e1 03             	and    $0x3,%ecx
  80156e:	89 4a 08             	mov    %ecx,0x8(%edx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801571:	8b 40 0c             	mov    0xc(%eax),%eax
  801574:	8b 15 64 90 80 00    	mov    0x809064,%edx
  80157a:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  80157c:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801582:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801588:	89 50 08             	mov    %edx,0x8(%eax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  80158b:	8b 50 0c             	mov    0xc(%eax),%edx
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  801593:	8b 45 14             	mov    0x14(%ebp),%eax
  801596:	c7 00 07 04 00 00    	movl   $0x407,(%eax)

	return 0;
  80159c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a1:	81 c4 24 04 00 00    	add    $0x424,%esp
  8015a7:	5b                   	pop    %ebx
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	56                   	push   %esi
  8015ae:	53                   	push   %ebx
  8015af:	83 ec 20             	sub    $0x20,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8015b2:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8015b5:	8d 75 f4             	lea    -0xc(%ebp),%esi
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  8015b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8015bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015c3:	a1 44 50 80 00       	mov    0x805044,%eax
  8015c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015cc:	89 34 24             	mov    %esi,(%esp)
  8015cf:	e8 54 15 00 00       	call   802b28 <ipc_recv>
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  8015d4:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  8015d8:	75 15                	jne    8015ef <serve+0x45>
			cprintf("Invalid request from %08x: no argument page\n",
  8015da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e1:	c7 04 24 b8 44 80 00 	movl   $0x8044b8,(%esp)
  8015e8:	e8 2e 07 00 00       	call   801d1b <cprintf>
				whom);
			continue; // just leave it hanging...
  8015ed:	eb c9                	jmp    8015b8 <serve+0xe>
		}

		pg = NULL;
  8015ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  8015f6:	83 f8 01             	cmp    $0x1,%eax
  8015f9:	75 21                	jne    80161c <serve+0x72>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8015fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015ff:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801602:	89 44 24 08          	mov    %eax,0x8(%esp)
  801606:	a1 44 50 80 00       	mov    0x805044,%eax
  80160b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801612:	89 04 24             	mov    %eax,(%esp)
  801615:	e8 54 fe ff ff       	call   80146e <serve_open>
  80161a:	eb 3f                	jmp    80165b <serve+0xb1>
		} else if (req < NHANDLERS && handlers[req]) {
  80161c:	83 f8 08             	cmp    $0x8,%eax
  80161f:	77 1e                	ja     80163f <serve+0x95>
  801621:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  801628:	85 d2                	test   %edx,%edx
  80162a:	74 13                	je     80163f <serve+0x95>
			r = handlers[req](whom, fsreq);
  80162c:	a1 44 50 80 00       	mov    0x805044,%eax
  801631:	89 44 24 04          	mov    %eax,0x4(%esp)
  801635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801638:	89 04 24             	mov    %eax,(%esp)
  80163b:	ff d2                	call   *%edx
  80163d:	eb 1c                	jmp    80165b <serve+0xb1>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  80163f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801642:	89 54 24 08          	mov    %edx,0x8(%esp)
  801646:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164a:	c7 04 24 e8 44 80 00 	movl   $0x8044e8,(%esp)
  801651:	e8 c5 06 00 00       	call   801d1b <cprintf>
			r = -E_INVAL;
  801656:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  80165b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801662:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801665:	89 54 24 08          	mov    %edx,0x8(%esp)
  801669:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801670:	89 04 24             	mov    %eax,(%esp)
  801673:	e8 1a 15 00 00       	call   802b92 <ipc_send>
		sys_page_unmap(0, fsreq);
  801678:	a1 44 50 80 00       	mov    0x805044,%eax
  80167d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801681:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801688:	e8 7d 11 00 00       	call   80280a <sys_page_unmap>
  80168d:	e9 26 ff ff ff       	jmp    8015b8 <serve+0xe>

00801692 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801698:	c7 05 60 90 80 00 0b 	movl   $0x80450b,0x809060
  80169f:	45 80 00 
	cprintf("FS is running\n");
  8016a2:	c7 04 24 0e 45 80 00 	movl   $0x80450e,(%esp)
  8016a9:	e8 6d 06 00 00       	call   801d1b <cprintf>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8016ae:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  8016b3:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  8016b8:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8016ba:	c7 04 24 1d 45 80 00 	movl   $0x80451d,(%esp)
  8016c1:	e8 55 06 00 00       	call   801d1b <cprintf>

	serve_init();
  8016c6:	e8 b7 fa ff ff       	call   801182 <serve_init>
	fs_init();
  8016cb:	e8 29 f3 ff ff       	call   8009f9 <fs_init>

        fs_test();
  8016d0:	e8 05 00 00 00       	call   8016da <fs_test>

	serve();
  8016d5:	e8 d0 fe ff ff       	call   8015aa <serve>

008016da <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8016e1:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8016e8:	00 
  8016e9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  8016f0:	00 
  8016f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f8:	e8 66 10 00 00       	call   802763 <sys_page_alloc>
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	79 20                	jns    801721 <fs_test+0x47>
		panic("sys_page_alloc: %e", r);
  801701:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801705:	c7 44 24 08 2c 45 80 	movl   $0x80452c,0x8(%esp)
  80170c:	00 
  80170d:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  801714:	00 
  801715:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  80171c:	e8 01 05 00 00       	call   801c22 <_panic>
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  801721:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801728:	00 
  801729:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80172e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801732:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  801739:	e8 a6 0d 00 00       	call   8024e4 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  80173e:	e8 d0 f0 ff ff       	call   800813 <alloc_block>
  801743:	85 c0                	test   %eax,%eax
  801745:	79 20                	jns    801767 <fs_test+0x8d>
		panic("alloc_block: %e", r);
  801747:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80174b:	c7 44 24 08 49 45 80 	movl   $0x804549,0x8(%esp)
  801752:	00 
  801753:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  80175a:	00 
  80175b:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801762:	e8 bb 04 00 00       	call   801c22 <_panic>
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801767:	8d 58 1f             	lea    0x1f(%eax),%ebx
  80176a:	85 c0                	test   %eax,%eax
  80176c:	0f 49 d8             	cmovns %eax,%ebx
  80176f:	c1 fb 05             	sar    $0x5,%ebx
  801772:	99                   	cltd   
  801773:	c1 ea 1b             	shr    $0x1b,%edx
  801776:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801779:	83 e1 1f             	and    $0x1f,%ecx
  80177c:	29 d1                	sub    %edx,%ecx
  80177e:	ba 01 00 00 00       	mov    $0x1,%edx
  801783:	d3 e2                	shl    %cl,%edx
  801785:	85 14 9d 00 10 00 00 	test   %edx,0x1000(,%ebx,4)
  80178c:	75 24                	jne    8017b2 <fs_test+0xd8>
  80178e:	c7 44 24 0c 59 45 80 	movl   $0x804559,0xc(%esp)
  801795:	00 
  801796:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  80179d:	00 
  80179e:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  8017a5:	00 
  8017a6:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  8017ad:	e8 70 04 00 00       	call   801c22 <_panic>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8017b2:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8017b7:	85 14 98             	test   %edx,(%eax,%ebx,4)
  8017ba:	74 24                	je     8017e0 <fs_test+0x106>
  8017bc:	c7 44 24 0c d4 46 80 	movl   $0x8046d4,0xc(%esp)
  8017c3:	00 
  8017c4:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  8017cb:	00 
  8017cc:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8017d3:	00 
  8017d4:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  8017db:	e8 42 04 00 00       	call   801c22 <_panic>
	cprintf("alloc_block is good\n");
  8017e0:	c7 04 24 74 45 80 00 	movl   $0x804574,(%esp)
  8017e7:	e8 2f 05 00 00       	call   801d1b <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  8017ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f3:	c7 04 24 89 45 80 00 	movl   $0x804589,(%esp)
  8017fa:	e8 f2 f4 ff ff       	call   800cf1 <file_open>
  8017ff:	85 c0                	test   %eax,%eax
  801801:	79 25                	jns    801828 <fs_test+0x14e>
  801803:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801806:	74 40                	je     801848 <fs_test+0x16e>
		panic("file_open /not-found: %e", r);
  801808:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80180c:	c7 44 24 08 94 45 80 	movl   $0x804594,0x8(%esp)
  801813:	00 
  801814:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  80181b:	00 
  80181c:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801823:	e8 fa 03 00 00       	call   801c22 <_panic>
	else if (r == 0)
  801828:	85 c0                	test   %eax,%eax
  80182a:	75 1c                	jne    801848 <fs_test+0x16e>
		panic("file_open /not-found succeeded!");
  80182c:	c7 44 24 08 f4 46 80 	movl   $0x8046f4,0x8(%esp)
  801833:	00 
  801834:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  80183b:	00 
  80183c:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801843:	e8 da 03 00 00       	call   801c22 <_panic>
	if ((r = file_open("/newmotd", &f)) < 0)
  801848:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184f:	c7 04 24 ad 45 80 00 	movl   $0x8045ad,(%esp)
  801856:	e8 96 f4 ff ff       	call   800cf1 <file_open>
  80185b:	85 c0                	test   %eax,%eax
  80185d:	79 20                	jns    80187f <fs_test+0x1a5>
		panic("file_open /newmotd: %e", r);
  80185f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801863:	c7 44 24 08 b6 45 80 	movl   $0x8045b6,0x8(%esp)
  80186a:	00 
  80186b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801872:	00 
  801873:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  80187a:	e8 a3 03 00 00       	call   801c22 <_panic>
	cprintf("file_open is good\n");
  80187f:	c7 04 24 cd 45 80 00 	movl   $0x8045cd,(%esp)
  801886:	e8 90 04 00 00       	call   801d1b <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  80188b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80188e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801892:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801899:	00 
  80189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189d:	89 04 24             	mov    %eax,(%esp)
  8018a0:	e8 b0 f1 ff ff       	call   800a55 <file_get_block>
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	79 20                	jns    8018c9 <fs_test+0x1ef>
		panic("file_get_block: %e", r);
  8018a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018ad:	c7 44 24 08 e0 45 80 	movl   $0x8045e0,0x8(%esp)
  8018b4:	00 
  8018b5:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  8018bc:	00 
  8018bd:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  8018c4:	e8 59 03 00 00       	call   801c22 <_panic>
	if (strcmp(blk, msg) != 0)
  8018c9:	c7 44 24 04 14 47 80 	movl   $0x804714,0x4(%esp)
  8018d0:	00 
  8018d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d4:	89 04 24             	mov    %eax,(%esp)
  8018d7:	e8 20 0b 00 00       	call   8023fc <strcmp>
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	74 1c                	je     8018fc <fs_test+0x222>
		panic("file_get_block returned wrong data");
  8018e0:	c7 44 24 08 3c 47 80 	movl   $0x80473c,0x8(%esp)
  8018e7:	00 
  8018e8:	c7 44 24 04 29 00 00 	movl   $0x29,0x4(%esp)
  8018ef:	00 
  8018f0:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  8018f7:	e8 26 03 00 00       	call   801c22 <_panic>
	cprintf("file_get_block is good\n");
  8018fc:	c7 04 24 f3 45 80 00 	movl   $0x8045f3,(%esp)
  801903:	e8 13 04 00 00       	call   801d1b <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190b:	0f b6 10             	movzbl (%eax),%edx
  80190e:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801913:	c1 e8 0c             	shr    $0xc,%eax
  801916:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80191d:	a8 40                	test   $0x40,%al
  80191f:	75 24                	jne    801945 <fs_test+0x26b>
  801921:	c7 44 24 0c 0c 46 80 	movl   $0x80460c,0xc(%esp)
  801928:	00 
  801929:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  801930:	00 
  801931:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801938:	00 
  801939:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801940:	e8 dd 02 00 00       	call   801c22 <_panic>
	file_flush(f);
  801945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801948:	89 04 24             	mov    %eax,(%esp)
  80194b:	e8 f3 f5 ff ff       	call   800f43 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801953:	c1 e8 0c             	shr    $0xc,%eax
  801956:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80195d:	a8 40                	test   $0x40,%al
  80195f:	74 24                	je     801985 <fs_test+0x2ab>
  801961:	c7 44 24 0c 0b 46 80 	movl   $0x80460b,0xc(%esp)
  801968:	00 
  801969:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  801970:	00 
  801971:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801978:	00 
  801979:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801980:	e8 9d 02 00 00       	call   801c22 <_panic>
	cprintf("file_flush is good\n");
  801985:	c7 04 24 27 46 80 00 	movl   $0x804627,(%esp)
  80198c:	e8 8a 03 00 00       	call   801d1b <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801991:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801998:	00 
  801999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199c:	89 04 24             	mov    %eax,(%esp)
  80199f:	e8 1c f4 ff ff       	call   800dc0 <file_set_size>
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	79 20                	jns    8019c8 <fs_test+0x2ee>
		panic("file_set_size: %e", r);
  8019a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019ac:	c7 44 24 08 3b 46 80 	movl   $0x80463b,0x8(%esp)
  8019b3:	00 
  8019b4:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8019bb:	00 
  8019bc:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  8019c3:	e8 5a 02 00 00       	call   801c22 <_panic>
	assert(f->f_direct[0] == 0);
  8019c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cb:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  8019d2:	74 24                	je     8019f8 <fs_test+0x31e>
  8019d4:	c7 44 24 0c 4d 46 80 	movl   $0x80464d,0xc(%esp)
  8019db:	00 
  8019dc:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  8019e3:	00 
  8019e4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8019eb:	00 
  8019ec:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  8019f3:	e8 2a 02 00 00       	call   801c22 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8019f8:	c1 e8 0c             	shr    $0xc,%eax
  8019fb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a02:	a8 40                	test   $0x40,%al
  801a04:	74 24                	je     801a2a <fs_test+0x350>
  801a06:	c7 44 24 0c 61 46 80 	movl   $0x804661,0xc(%esp)
  801a0d:	00 
  801a0e:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  801a15:	00 
  801a16:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801a1d:	00 
  801a1e:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801a25:	e8 f8 01 00 00       	call   801c22 <_panic>
	cprintf("file_truncate is good\n");
  801a2a:	c7 04 24 7b 46 80 00 	movl   $0x80467b,(%esp)
  801a31:	e8 e5 02 00 00       	call   801d1b <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801a36:	c7 04 24 14 47 80 00 	movl   $0x804714,(%esp)
  801a3d:	e8 ce 08 00 00       	call   802310 <strlen>
  801a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a49:	89 04 24             	mov    %eax,(%esp)
  801a4c:	e8 6f f3 ff ff       	call   800dc0 <file_set_size>
  801a51:	85 c0                	test   %eax,%eax
  801a53:	79 20                	jns    801a75 <fs_test+0x39b>
		panic("file_set_size 2: %e", r);
  801a55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a59:	c7 44 24 08 92 46 80 	movl   $0x804692,0x8(%esp)
  801a60:	00 
  801a61:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801a68:	00 
  801a69:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801a70:	e8 ad 01 00 00       	call   801c22 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a78:	89 c2                	mov    %eax,%edx
  801a7a:	c1 ea 0c             	shr    $0xc,%edx
  801a7d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a84:	f6 c2 40             	test   $0x40,%dl
  801a87:	74 24                	je     801aad <fs_test+0x3d3>
  801a89:	c7 44 24 0c 61 46 80 	movl   $0x804661,0xc(%esp)
  801a90:	00 
  801a91:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  801a98:	00 
  801a99:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801aa0:	00 
  801aa1:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801aa8:	e8 75 01 00 00       	call   801c22 <_panic>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801aad:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801ab0:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ab4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801abb:	00 
  801abc:	89 04 24             	mov    %eax,(%esp)
  801abf:	e8 91 ef ff ff       	call   800a55 <file_get_block>
  801ac4:	85 c0                	test   %eax,%eax
  801ac6:	79 20                	jns    801ae8 <fs_test+0x40e>
		panic("file_get_block 2: %e", r);
  801ac8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801acc:	c7 44 24 08 a6 46 80 	movl   $0x8046a6,0x8(%esp)
  801ad3:	00 
  801ad4:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  801adb:	00 
  801adc:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801ae3:	e8 3a 01 00 00       	call   801c22 <_panic>
	strcpy(blk, msg);
  801ae8:	c7 44 24 04 14 47 80 	movl   $0x804714,0x4(%esp)
  801aef:	00 
  801af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af3:	89 04 24             	mov    %eax,(%esp)
  801af6:	e8 4c 08 00 00       	call   802347 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afe:	c1 e8 0c             	shr    $0xc,%eax
  801b01:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b08:	a8 40                	test   $0x40,%al
  801b0a:	75 24                	jne    801b30 <fs_test+0x456>
  801b0c:	c7 44 24 0c 0c 46 80 	movl   $0x80460c,0xc(%esp)
  801b13:	00 
  801b14:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  801b1b:	00 
  801b1c:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  801b23:	00 
  801b24:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801b2b:	e8 f2 00 00 00       	call   801c22 <_panic>
	file_flush(f);
  801b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b33:	89 04 24             	mov    %eax,(%esp)
  801b36:	e8 08 f4 ff ff       	call   800f43 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3e:	c1 e8 0c             	shr    $0xc,%eax
  801b41:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b48:	a8 40                	test   $0x40,%al
  801b4a:	74 24                	je     801b70 <fs_test+0x496>
  801b4c:	c7 44 24 0c 0b 46 80 	movl   $0x80460b,0xc(%esp)
  801b53:	00 
  801b54:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  801b5b:	00 
  801b5c:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  801b63:	00 
  801b64:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801b6b:	e8 b2 00 00 00       	call   801c22 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b73:	c1 e8 0c             	shr    $0xc,%eax
  801b76:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b7d:	a8 40                	test   $0x40,%al
  801b7f:	74 24                	je     801ba5 <fs_test+0x4cb>
  801b81:	c7 44 24 0c 61 46 80 	movl   $0x804661,0xc(%esp)
  801b88:	00 
  801b89:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  801b90:	00 
  801b91:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
  801b98:	00 
  801b99:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  801ba0:	e8 7d 00 00 00       	call   801c22 <_panic>
	cprintf("file rewrite is good\n");
  801ba5:	c7 04 24 bb 46 80 00 	movl   $0x8046bb,(%esp)
  801bac:	e8 6a 01 00 00       	call   801d1b <cprintf>
}
  801bb1:	83 c4 24             	add    $0x24,%esp
  801bb4:	5b                   	pop    %ebx
  801bb5:	5d                   	pop    %ebp
  801bb6:	c3                   	ret    

00801bb7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	56                   	push   %esi
  801bbb:	53                   	push   %ebx
  801bbc:	83 ec 10             	sub    $0x10,%esp
  801bbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801bc2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  801bc5:	c7 05 10 a0 80 00 00 	movl   $0x0,0x80a010
  801bcc:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  801bcf:	e8 51 0b 00 00       	call   802725 <sys_getenvid>
  801bd4:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  801bd9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801bdc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801be1:	a3 10 a0 80 00       	mov    %eax,0x80a010


	// save the name of the program so that panic() can use it
	if (argc > 0)
  801be6:	85 db                	test   %ebx,%ebx
  801be8:	7e 07                	jle    801bf1 <libmain+0x3a>
		binaryname = argv[0];
  801bea:	8b 06                	mov    (%esi),%eax
  801bec:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801bf1:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bf5:	89 1c 24             	mov    %ebx,(%esp)
  801bf8:	e8 95 fa ff ff       	call   801692 <umain>

	// exit gracefully
	exit();
  801bfd:	e8 07 00 00 00       	call   801c09 <exit>
}
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	5b                   	pop    %ebx
  801c06:	5e                   	pop    %esi
  801c07:	5d                   	pop    %ebp
  801c08:	c3                   	ret    

00801c09 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 18             	sub    $0x18,%esp
	close_all();
  801c0f:	e8 f6 11 00 00       	call   802e0a <close_all>
	sys_env_destroy(0);
  801c14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c1b:	e8 b3 0a 00 00       	call   8026d3 <sys_env_destroy>
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	56                   	push   %esi
  801c26:	53                   	push   %ebx
  801c27:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801c2a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c2d:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801c33:	e8 ed 0a 00 00       	call   802725 <sys_getenvid>
  801c38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3b:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c3f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c42:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c46:	89 74 24 08          	mov    %esi,0x8(%esp)
  801c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4e:	c7 04 24 6c 47 80 00 	movl   $0x80476c,(%esp)
  801c55:	e8 c1 00 00 00       	call   801d1b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c61:	89 04 24             	mov    %eax,(%esp)
  801c64:	e8 51 00 00 00       	call   801cba <vcprintf>
	cprintf("\n");
  801c69:	c7 04 24 48 43 80 00 	movl   $0x804348,(%esp)
  801c70:	e8 a6 00 00 00       	call   801d1b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c75:	cc                   	int3   
  801c76:	eb fd                	jmp    801c75 <_panic+0x53>

00801c78 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	53                   	push   %ebx
  801c7c:	83 ec 14             	sub    $0x14,%esp
  801c7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c82:	8b 13                	mov    (%ebx),%edx
  801c84:	8d 42 01             	lea    0x1(%edx),%eax
  801c87:	89 03                	mov    %eax,(%ebx)
  801c89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c8c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801c90:	3d ff 00 00 00       	cmp    $0xff,%eax
  801c95:	75 19                	jne    801cb0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801c97:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801c9e:	00 
  801c9f:	8d 43 08             	lea    0x8(%ebx),%eax
  801ca2:	89 04 24             	mov    %eax,(%esp)
  801ca5:	e8 ec 09 00 00       	call   802696 <sys_cputs>
		b->idx = 0;
  801caa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801cb0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801cb4:	83 c4 14             	add    $0x14,%esp
  801cb7:	5b                   	pop    %ebx
  801cb8:	5d                   	pop    %ebp
  801cb9:	c3                   	ret    

00801cba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801cc3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801cca:	00 00 00 
	b.cnt = 0;
  801ccd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801cd4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cda:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ce5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cef:	c7 04 24 78 1c 80 00 	movl   $0x801c78,(%esp)
  801cf6:	e8 b3 01 00 00       	call   801eae <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801cfb:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801d01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d05:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801d0b:	89 04 24             	mov    %eax,(%esp)
  801d0e:	e8 83 09 00 00       	call   802696 <sys_cputs>

	return b.cnt;
}
  801d13:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d21:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	89 04 24             	mov    %eax,(%esp)
  801d2e:	e8 87 ff ff ff       	call   801cba <vcprintf>
	va_end(ap);

	return cnt;
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    
  801d35:	66 90                	xchg   %ax,%ax
  801d37:	66 90                	xchg   %ax,%ax
  801d39:	66 90                	xchg   %ax,%ax
  801d3b:	66 90                	xchg   %ax,%ax
  801d3d:	66 90                	xchg   %ax,%ax
  801d3f:	90                   	nop

00801d40 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	57                   	push   %edi
  801d44:	56                   	push   %esi
  801d45:	53                   	push   %ebx
  801d46:	83 ec 3c             	sub    $0x3c,%esp
  801d49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d4c:	89 d7                	mov    %edx,%edi
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d57:	89 c3                	mov    %eax,%ebx
  801d59:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801d62:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d67:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d6a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801d6d:	39 d9                	cmp    %ebx,%ecx
  801d6f:	72 05                	jb     801d76 <printnum+0x36>
  801d71:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801d74:	77 69                	ja     801ddf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801d76:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801d79:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801d7d:	83 ee 01             	sub    $0x1,%esi
  801d80:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d84:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d88:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d8c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801d90:	89 c3                	mov    %eax,%ebx
  801d92:	89 d6                	mov    %edx,%esi
  801d94:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d97:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801d9a:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d9e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801da2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801da5:	89 04 24             	mov    %eax,(%esp)
  801da8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801daf:	e8 7c 21 00 00       	call   803f30 <__udivdi3>
  801db4:	89 d9                	mov    %ebx,%ecx
  801db6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801dbe:	89 04 24             	mov    %eax,(%esp)
  801dc1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dc5:	89 fa                	mov    %edi,%edx
  801dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dca:	e8 71 ff ff ff       	call   801d40 <printnum>
  801dcf:	eb 1b                	jmp    801dec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801dd1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dd5:	8b 45 18             	mov    0x18(%ebp),%eax
  801dd8:	89 04 24             	mov    %eax,(%esp)
  801ddb:	ff d3                	call   *%ebx
  801ddd:	eb 03                	jmp    801de2 <printnum+0xa2>
  801ddf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801de2:	83 ee 01             	sub    $0x1,%esi
  801de5:	85 f6                	test   %esi,%esi
  801de7:	7f e8                	jg     801dd1 <printnum+0x91>
  801de9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801dec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801df0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801df4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801df7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801dfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dfe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e05:	89 04 24             	mov    %eax,(%esp)
  801e08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0f:	e8 4c 22 00 00       	call   804060 <__umoddi3>
  801e14:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e18:	0f be 80 8f 47 80 00 	movsbl 0x80478f(%eax),%eax
  801e1f:	89 04 24             	mov    %eax,(%esp)
  801e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e25:	ff d0                	call   *%eax
}
  801e27:	83 c4 3c             	add    $0x3c,%esp
  801e2a:	5b                   	pop    %ebx
  801e2b:	5e                   	pop    %esi
  801e2c:	5f                   	pop    %edi
  801e2d:	5d                   	pop    %ebp
  801e2e:	c3                   	ret    

00801e2f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801e32:	83 fa 01             	cmp    $0x1,%edx
  801e35:	7e 0e                	jle    801e45 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801e37:	8b 10                	mov    (%eax),%edx
  801e39:	8d 4a 08             	lea    0x8(%edx),%ecx
  801e3c:	89 08                	mov    %ecx,(%eax)
  801e3e:	8b 02                	mov    (%edx),%eax
  801e40:	8b 52 04             	mov    0x4(%edx),%edx
  801e43:	eb 22                	jmp    801e67 <getuint+0x38>
	else if (lflag)
  801e45:	85 d2                	test   %edx,%edx
  801e47:	74 10                	je     801e59 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801e49:	8b 10                	mov    (%eax),%edx
  801e4b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e4e:	89 08                	mov    %ecx,(%eax)
  801e50:	8b 02                	mov    (%edx),%eax
  801e52:	ba 00 00 00 00       	mov    $0x0,%edx
  801e57:	eb 0e                	jmp    801e67 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801e59:	8b 10                	mov    (%eax),%edx
  801e5b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e5e:	89 08                	mov    %ecx,(%eax)
  801e60:	8b 02                	mov    (%edx),%eax
  801e62:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801e67:	5d                   	pop    %ebp
  801e68:	c3                   	ret    

00801e69 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801e6f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801e73:	8b 10                	mov    (%eax),%edx
  801e75:	3b 50 04             	cmp    0x4(%eax),%edx
  801e78:	73 0a                	jae    801e84 <sprintputch+0x1b>
		*b->buf++ = ch;
  801e7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e7d:	89 08                	mov    %ecx,(%eax)
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	88 02                	mov    %al,(%edx)
}
  801e84:	5d                   	pop    %ebp
  801e85:	c3                   	ret    

00801e86 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e8c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801e8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e93:	8b 45 10             	mov    0x10(%ebp),%eax
  801e96:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	89 04 24             	mov    %eax,(%esp)
  801ea7:	e8 02 00 00 00       	call   801eae <vprintfmt>
	va_end(ap);
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	57                   	push   %edi
  801eb2:	56                   	push   %esi
  801eb3:	53                   	push   %ebx
  801eb4:	83 ec 3c             	sub    $0x3c,%esp
  801eb7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801eba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ebd:	eb 14                	jmp    801ed3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	0f 84 b3 03 00 00    	je     80227a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801ec7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ecb:	89 04 24             	mov    %eax,(%esp)
  801ece:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ed1:	89 f3                	mov    %esi,%ebx
  801ed3:	8d 73 01             	lea    0x1(%ebx),%esi
  801ed6:	0f b6 03             	movzbl (%ebx),%eax
  801ed9:	83 f8 25             	cmp    $0x25,%eax
  801edc:	75 e1                	jne    801ebf <vprintfmt+0x11>
  801ede:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801ee2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ee9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801ef0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801ef7:	ba 00 00 00 00       	mov    $0x0,%edx
  801efc:	eb 1d                	jmp    801f1b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801efe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801f00:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801f04:	eb 15                	jmp    801f1b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f06:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801f08:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801f0c:	eb 0d                	jmp    801f1b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801f0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f11:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f14:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f1b:	8d 5e 01             	lea    0x1(%esi),%ebx
  801f1e:	0f b6 0e             	movzbl (%esi),%ecx
  801f21:	0f b6 c1             	movzbl %cl,%eax
  801f24:	83 e9 23             	sub    $0x23,%ecx
  801f27:	80 f9 55             	cmp    $0x55,%cl
  801f2a:	0f 87 2a 03 00 00    	ja     80225a <vprintfmt+0x3ac>
  801f30:	0f b6 c9             	movzbl %cl,%ecx
  801f33:	ff 24 8d e0 48 80 00 	jmp    *0x8048e0(,%ecx,4)
  801f3a:	89 de                	mov    %ebx,%esi
  801f3c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801f41:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801f44:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801f48:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801f4b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801f4e:	83 fb 09             	cmp    $0x9,%ebx
  801f51:	77 36                	ja     801f89 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801f53:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801f56:	eb e9                	jmp    801f41 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801f58:	8b 45 14             	mov    0x14(%ebp),%eax
  801f5b:	8d 48 04             	lea    0x4(%eax),%ecx
  801f5e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801f61:	8b 00                	mov    (%eax),%eax
  801f63:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f66:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801f68:	eb 22                	jmp    801f8c <vprintfmt+0xde>
  801f6a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801f6d:	85 c9                	test   %ecx,%ecx
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	0f 49 c1             	cmovns %ecx,%eax
  801f77:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f7a:	89 de                	mov    %ebx,%esi
  801f7c:	eb 9d                	jmp    801f1b <vprintfmt+0x6d>
  801f7e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801f80:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801f87:	eb 92                	jmp    801f1b <vprintfmt+0x6d>
  801f89:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801f8c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801f90:	79 89                	jns    801f1b <vprintfmt+0x6d>
  801f92:	e9 77 ff ff ff       	jmp    801f0e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801f97:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f9a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801f9c:	e9 7a ff ff ff       	jmp    801f1b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801fa1:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa4:	8d 50 04             	lea    0x4(%eax),%edx
  801fa7:	89 55 14             	mov    %edx,0x14(%ebp)
  801faa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801fae:	8b 00                	mov    (%eax),%eax
  801fb0:	89 04 24             	mov    %eax,(%esp)
  801fb3:	ff 55 08             	call   *0x8(%ebp)
			break;
  801fb6:	e9 18 ff ff ff       	jmp    801ed3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801fbb:	8b 45 14             	mov    0x14(%ebp),%eax
  801fbe:	8d 50 04             	lea    0x4(%eax),%edx
  801fc1:	89 55 14             	mov    %edx,0x14(%ebp)
  801fc4:	8b 00                	mov    (%eax),%eax
  801fc6:	99                   	cltd   
  801fc7:	31 d0                	xor    %edx,%eax
  801fc9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801fcb:	83 f8 0f             	cmp    $0xf,%eax
  801fce:	7f 0b                	jg     801fdb <vprintfmt+0x12d>
  801fd0:	8b 14 85 40 4a 80 00 	mov    0x804a40(,%eax,4),%edx
  801fd7:	85 d2                	test   %edx,%edx
  801fd9:	75 20                	jne    801ffb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801fdb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fdf:	c7 44 24 08 a7 47 80 	movl   $0x8047a7,0x8(%esp)
  801fe6:	00 
  801fe7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	89 04 24             	mov    %eax,(%esp)
  801ff1:	e8 90 fe ff ff       	call   801e86 <printfmt>
  801ff6:	e9 d8 fe ff ff       	jmp    801ed3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801ffb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fff:	c7 44 24 08 0f 42 80 	movl   $0x80420f,0x8(%esp)
  802006:	00 
  802007:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	89 04 24             	mov    %eax,(%esp)
  802011:	e8 70 fe ff ff       	call   801e86 <printfmt>
  802016:	e9 b8 fe ff ff       	jmp    801ed3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80201b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80201e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802021:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  802024:	8b 45 14             	mov    0x14(%ebp),%eax
  802027:	8d 50 04             	lea    0x4(%eax),%edx
  80202a:	89 55 14             	mov    %edx,0x14(%ebp)
  80202d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80202f:	85 f6                	test   %esi,%esi
  802031:	b8 a0 47 80 00       	mov    $0x8047a0,%eax
  802036:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  802039:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80203d:	0f 84 97 00 00 00    	je     8020da <vprintfmt+0x22c>
  802043:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802047:	0f 8e 9b 00 00 00    	jle    8020e8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80204d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802051:	89 34 24             	mov    %esi,(%esp)
  802054:	e8 cf 02 00 00       	call   802328 <strnlen>
  802059:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80205c:	29 c2                	sub    %eax,%edx
  80205e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  802061:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  802065:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802068:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80206b:	8b 75 08             	mov    0x8(%ebp),%esi
  80206e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802071:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802073:	eb 0f                	jmp    802084 <vprintfmt+0x1d6>
					putch(padc, putdat);
  802075:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802079:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80207c:	89 04 24             	mov    %eax,(%esp)
  80207f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802081:	83 eb 01             	sub    $0x1,%ebx
  802084:	85 db                	test   %ebx,%ebx
  802086:	7f ed                	jg     802075 <vprintfmt+0x1c7>
  802088:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80208b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80208e:	85 d2                	test   %edx,%edx
  802090:	b8 00 00 00 00       	mov    $0x0,%eax
  802095:	0f 49 c2             	cmovns %edx,%eax
  802098:	29 c2                	sub    %eax,%edx
  80209a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80209d:	89 d7                	mov    %edx,%edi
  80209f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8020a2:	eb 50                	jmp    8020f4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8020a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020a8:	74 1e                	je     8020c8 <vprintfmt+0x21a>
  8020aa:	0f be d2             	movsbl %dl,%edx
  8020ad:	83 ea 20             	sub    $0x20,%edx
  8020b0:	83 fa 5e             	cmp    $0x5e,%edx
  8020b3:	76 13                	jbe    8020c8 <vprintfmt+0x21a>
					putch('?', putdat);
  8020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020bc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8020c3:	ff 55 08             	call   *0x8(%ebp)
  8020c6:	eb 0d                	jmp    8020d5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8020c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020cf:	89 04 24             	mov    %eax,(%esp)
  8020d2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8020d5:	83 ef 01             	sub    $0x1,%edi
  8020d8:	eb 1a                	jmp    8020f4 <vprintfmt+0x246>
  8020da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8020dd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8020e0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8020e3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8020e6:	eb 0c                	jmp    8020f4 <vprintfmt+0x246>
  8020e8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8020eb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8020ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8020f1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8020f4:	83 c6 01             	add    $0x1,%esi
  8020f7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8020fb:	0f be c2             	movsbl %dl,%eax
  8020fe:	85 c0                	test   %eax,%eax
  802100:	74 27                	je     802129 <vprintfmt+0x27b>
  802102:	85 db                	test   %ebx,%ebx
  802104:	78 9e                	js     8020a4 <vprintfmt+0x1f6>
  802106:	83 eb 01             	sub    $0x1,%ebx
  802109:	79 99                	jns    8020a4 <vprintfmt+0x1f6>
  80210b:	89 f8                	mov    %edi,%eax
  80210d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802110:	8b 75 08             	mov    0x8(%ebp),%esi
  802113:	89 c3                	mov    %eax,%ebx
  802115:	eb 1a                	jmp    802131 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  802117:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80211b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  802122:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802124:	83 eb 01             	sub    $0x1,%ebx
  802127:	eb 08                	jmp    802131 <vprintfmt+0x283>
  802129:	89 fb                	mov    %edi,%ebx
  80212b:	8b 75 08             	mov    0x8(%ebp),%esi
  80212e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802131:	85 db                	test   %ebx,%ebx
  802133:	7f e2                	jg     802117 <vprintfmt+0x269>
  802135:	89 75 08             	mov    %esi,0x8(%ebp)
  802138:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80213b:	e9 93 fd ff ff       	jmp    801ed3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  802140:	83 fa 01             	cmp    $0x1,%edx
  802143:	7e 16                	jle    80215b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  802145:	8b 45 14             	mov    0x14(%ebp),%eax
  802148:	8d 50 08             	lea    0x8(%eax),%edx
  80214b:	89 55 14             	mov    %edx,0x14(%ebp)
  80214e:	8b 50 04             	mov    0x4(%eax),%edx
  802151:	8b 00                	mov    (%eax),%eax
  802153:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802156:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802159:	eb 32                	jmp    80218d <vprintfmt+0x2df>
	else if (lflag)
  80215b:	85 d2                	test   %edx,%edx
  80215d:	74 18                	je     802177 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80215f:	8b 45 14             	mov    0x14(%ebp),%eax
  802162:	8d 50 04             	lea    0x4(%eax),%edx
  802165:	89 55 14             	mov    %edx,0x14(%ebp)
  802168:	8b 30                	mov    (%eax),%esi
  80216a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80216d:	89 f0                	mov    %esi,%eax
  80216f:	c1 f8 1f             	sar    $0x1f,%eax
  802172:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802175:	eb 16                	jmp    80218d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  802177:	8b 45 14             	mov    0x14(%ebp),%eax
  80217a:	8d 50 04             	lea    0x4(%eax),%edx
  80217d:	89 55 14             	mov    %edx,0x14(%ebp)
  802180:	8b 30                	mov    (%eax),%esi
  802182:	89 75 e0             	mov    %esi,-0x20(%ebp)
  802185:	89 f0                	mov    %esi,%eax
  802187:	c1 f8 1f             	sar    $0x1f,%eax
  80218a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80218d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802190:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  802193:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  802198:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80219c:	0f 89 80 00 00 00    	jns    802222 <vprintfmt+0x374>
				putch('-', putdat);
  8021a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8021a6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8021ad:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8021b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021b6:	f7 d8                	neg    %eax
  8021b8:	83 d2 00             	adc    $0x0,%edx
  8021bb:	f7 da                	neg    %edx
			}
			base = 10;
  8021bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8021c2:	eb 5e                	jmp    802222 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8021c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8021c7:	e8 63 fc ff ff       	call   801e2f <getuint>
			base = 10;
  8021cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8021d1:	eb 4f                	jmp    802222 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  8021d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8021d6:	e8 54 fc ff ff       	call   801e2f <getuint>
			base =8;
  8021db:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8021e0:	eb 40                	jmp    802222 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  8021e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8021e6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8021ed:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8021f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8021f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8021fb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8021fe:	8b 45 14             	mov    0x14(%ebp),%eax
  802201:	8d 50 04             	lea    0x4(%eax),%edx
  802204:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802207:	8b 00                	mov    (%eax),%eax
  802209:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80220e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  802213:	eb 0d                	jmp    802222 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802215:	8d 45 14             	lea    0x14(%ebp),%eax
  802218:	e8 12 fc ff ff       	call   801e2f <getuint>
			base = 16;
  80221d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  802222:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  802226:	89 74 24 10          	mov    %esi,0x10(%esp)
  80222a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80222d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802231:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802235:	89 04 24             	mov    %eax,(%esp)
  802238:	89 54 24 04          	mov    %edx,0x4(%esp)
  80223c:	89 fa                	mov    %edi,%edx
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	e8 fa fa ff ff       	call   801d40 <printnum>
			break;
  802246:	e9 88 fc ff ff       	jmp    801ed3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80224b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80224f:	89 04 24             	mov    %eax,(%esp)
  802252:	ff 55 08             	call   *0x8(%ebp)
			break;
  802255:	e9 79 fc ff ff       	jmp    801ed3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80225a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80225e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  802265:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  802268:	89 f3                	mov    %esi,%ebx
  80226a:	eb 03                	jmp    80226f <vprintfmt+0x3c1>
  80226c:	83 eb 01             	sub    $0x1,%ebx
  80226f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  802273:	75 f7                	jne    80226c <vprintfmt+0x3be>
  802275:	e9 59 fc ff ff       	jmp    801ed3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80227a:	83 c4 3c             	add    $0x3c,%esp
  80227d:	5b                   	pop    %ebx
  80227e:	5e                   	pop    %esi
  80227f:	5f                   	pop    %edi
  802280:	5d                   	pop    %ebp
  802281:	c3                   	ret    

00802282 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 28             	sub    $0x28,%esp
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80228e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802291:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802295:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	74 30                	je     8022d3 <vsnprintf+0x51>
  8022a3:	85 d2                	test   %edx,%edx
  8022a5:	7e 2c                	jle    8022d3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8022a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8022aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8022b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022bc:	c7 04 24 69 1e 80 00 	movl   $0x801e69,(%esp)
  8022c3:	e8 e6 fb ff ff       	call   801eae <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8022c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	eb 05                	jmp    8022d8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8022d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8022e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8022e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	89 04 24             	mov    %eax,(%esp)
  8022fb:	e8 82 ff ff ff       	call   802282 <vsnprintf>
	va_end(ap);

	return rc;
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    
  802302:	66 90                	xchg   %ax,%ax
  802304:	66 90                	xchg   %ax,%ax
  802306:	66 90                	xchg   %ax,%ax
  802308:	66 90                	xchg   %ax,%ax
  80230a:	66 90                	xchg   %ax,%ax
  80230c:	66 90                	xchg   %ax,%ax
  80230e:	66 90                	xchg   %ax,%ax

00802310 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802316:	b8 00 00 00 00       	mov    $0x0,%eax
  80231b:	eb 03                	jmp    802320 <strlen+0x10>
		n++;
  80231d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802320:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802324:	75 f7                	jne    80231d <strlen+0xd>
		n++;
	return n;
}
  802326:	5d                   	pop    %ebp
  802327:	c3                   	ret    

00802328 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80232e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802331:	b8 00 00 00 00       	mov    $0x0,%eax
  802336:	eb 03                	jmp    80233b <strnlen+0x13>
		n++;
  802338:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80233b:	39 d0                	cmp    %edx,%eax
  80233d:	74 06                	je     802345 <strnlen+0x1d>
  80233f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  802343:	75 f3                	jne    802338 <strnlen+0x10>
		n++;
	return n;
}
  802345:	5d                   	pop    %ebp
  802346:	c3                   	ret    

00802347 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
  80234a:	53                   	push   %ebx
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802351:	89 c2                	mov    %eax,%edx
  802353:	83 c2 01             	add    $0x1,%edx
  802356:	83 c1 01             	add    $0x1,%ecx
  802359:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80235d:	88 5a ff             	mov    %bl,-0x1(%edx)
  802360:	84 db                	test   %bl,%bl
  802362:	75 ef                	jne    802353 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  802364:	5b                   	pop    %ebx
  802365:	5d                   	pop    %ebp
  802366:	c3                   	ret    

00802367 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	53                   	push   %ebx
  80236b:	83 ec 08             	sub    $0x8,%esp
  80236e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802371:	89 1c 24             	mov    %ebx,(%esp)
  802374:	e8 97 ff ff ff       	call   802310 <strlen>
	strcpy(dst + len, src);
  802379:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802380:	01 d8                	add    %ebx,%eax
  802382:	89 04 24             	mov    %eax,(%esp)
  802385:	e8 bd ff ff ff       	call   802347 <strcpy>
	return dst;
}
  80238a:	89 d8                	mov    %ebx,%eax
  80238c:	83 c4 08             	add    $0x8,%esp
  80238f:	5b                   	pop    %ebx
  802390:	5d                   	pop    %ebp
  802391:	c3                   	ret    

00802392 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
  802395:	56                   	push   %esi
  802396:	53                   	push   %ebx
  802397:	8b 75 08             	mov    0x8(%ebp),%esi
  80239a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80239d:	89 f3                	mov    %esi,%ebx
  80239f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8023a2:	89 f2                	mov    %esi,%edx
  8023a4:	eb 0f                	jmp    8023b5 <strncpy+0x23>
		*dst++ = *src;
  8023a6:	83 c2 01             	add    $0x1,%edx
  8023a9:	0f b6 01             	movzbl (%ecx),%eax
  8023ac:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8023af:	80 39 01             	cmpb   $0x1,(%ecx)
  8023b2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8023b5:	39 da                	cmp    %ebx,%edx
  8023b7:	75 ed                	jne    8023a6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8023b9:	89 f0                	mov    %esi,%eax
  8023bb:	5b                   	pop    %ebx
  8023bc:	5e                   	pop    %esi
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	56                   	push   %esi
  8023c3:	53                   	push   %ebx
  8023c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8023c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023cd:	89 f0                	mov    %esi,%eax
  8023cf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8023d3:	85 c9                	test   %ecx,%ecx
  8023d5:	75 0b                	jne    8023e2 <strlcpy+0x23>
  8023d7:	eb 1d                	jmp    8023f6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8023d9:	83 c0 01             	add    $0x1,%eax
  8023dc:	83 c2 01             	add    $0x1,%edx
  8023df:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8023e2:	39 d8                	cmp    %ebx,%eax
  8023e4:	74 0b                	je     8023f1 <strlcpy+0x32>
  8023e6:	0f b6 0a             	movzbl (%edx),%ecx
  8023e9:	84 c9                	test   %cl,%cl
  8023eb:	75 ec                	jne    8023d9 <strlcpy+0x1a>
  8023ed:	89 c2                	mov    %eax,%edx
  8023ef:	eb 02                	jmp    8023f3 <strlcpy+0x34>
  8023f1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8023f3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8023f6:	29 f0                	sub    %esi,%eax
}
  8023f8:	5b                   	pop    %ebx
  8023f9:	5e                   	pop    %esi
  8023fa:	5d                   	pop    %ebp
  8023fb:	c3                   	ret    

008023fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802402:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802405:	eb 06                	jmp    80240d <strcmp+0x11>
		p++, q++;
  802407:	83 c1 01             	add    $0x1,%ecx
  80240a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80240d:	0f b6 01             	movzbl (%ecx),%eax
  802410:	84 c0                	test   %al,%al
  802412:	74 04                	je     802418 <strcmp+0x1c>
  802414:	3a 02                	cmp    (%edx),%al
  802416:	74 ef                	je     802407 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802418:	0f b6 c0             	movzbl %al,%eax
  80241b:	0f b6 12             	movzbl (%edx),%edx
  80241e:	29 d0                	sub    %edx,%eax
}
  802420:	5d                   	pop    %ebp
  802421:	c3                   	ret    

00802422 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	53                   	push   %ebx
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242c:	89 c3                	mov    %eax,%ebx
  80242e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802431:	eb 06                	jmp    802439 <strncmp+0x17>
		n--, p++, q++;
  802433:	83 c0 01             	add    $0x1,%eax
  802436:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802439:	39 d8                	cmp    %ebx,%eax
  80243b:	74 15                	je     802452 <strncmp+0x30>
  80243d:	0f b6 08             	movzbl (%eax),%ecx
  802440:	84 c9                	test   %cl,%cl
  802442:	74 04                	je     802448 <strncmp+0x26>
  802444:	3a 0a                	cmp    (%edx),%cl
  802446:	74 eb                	je     802433 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802448:	0f b6 00             	movzbl (%eax),%eax
  80244b:	0f b6 12             	movzbl (%edx),%edx
  80244e:	29 d0                	sub    %edx,%eax
  802450:	eb 05                	jmp    802457 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  802452:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802457:	5b                   	pop    %ebx
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    

0080245a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802464:	eb 07                	jmp    80246d <strchr+0x13>
		if (*s == c)
  802466:	38 ca                	cmp    %cl,%dl
  802468:	74 0f                	je     802479 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80246a:	83 c0 01             	add    $0x1,%eax
  80246d:	0f b6 10             	movzbl (%eax),%edx
  802470:	84 d2                	test   %dl,%dl
  802472:	75 f2                	jne    802466 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  802474:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802479:	5d                   	pop    %ebp
  80247a:	c3                   	ret    

0080247b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802485:	eb 07                	jmp    80248e <strfind+0x13>
		if (*s == c)
  802487:	38 ca                	cmp    %cl,%dl
  802489:	74 0a                	je     802495 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80248b:	83 c0 01             	add    $0x1,%eax
  80248e:	0f b6 10             	movzbl (%eax),%edx
  802491:	84 d2                	test   %dl,%dl
  802493:	75 f2                	jne    802487 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  802495:	5d                   	pop    %ebp
  802496:	c3                   	ret    

00802497 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	57                   	push   %edi
  80249b:	56                   	push   %esi
  80249c:	53                   	push   %ebx
  80249d:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8024a3:	85 c9                	test   %ecx,%ecx
  8024a5:	74 36                	je     8024dd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8024a7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8024ad:	75 28                	jne    8024d7 <memset+0x40>
  8024af:	f6 c1 03             	test   $0x3,%cl
  8024b2:	75 23                	jne    8024d7 <memset+0x40>
		c &= 0xFF;
  8024b4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8024b8:	89 d3                	mov    %edx,%ebx
  8024ba:	c1 e3 08             	shl    $0x8,%ebx
  8024bd:	89 d6                	mov    %edx,%esi
  8024bf:	c1 e6 18             	shl    $0x18,%esi
  8024c2:	89 d0                	mov    %edx,%eax
  8024c4:	c1 e0 10             	shl    $0x10,%eax
  8024c7:	09 f0                	or     %esi,%eax
  8024c9:	09 c2                	or     %eax,%edx
  8024cb:	89 d0                	mov    %edx,%eax
  8024cd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8024cf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8024d2:	fc                   	cld    
  8024d3:	f3 ab                	rep stos %eax,%es:(%edi)
  8024d5:	eb 06                	jmp    8024dd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	fc                   	cld    
  8024db:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8024dd:	89 f8                	mov    %edi,%eax
  8024df:	5b                   	pop    %ebx
  8024e0:	5e                   	pop    %esi
  8024e1:	5f                   	pop    %edi
  8024e2:	5d                   	pop    %ebp
  8024e3:	c3                   	ret    

008024e4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	57                   	push   %edi
  8024e8:	56                   	push   %esi
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8024f2:	39 c6                	cmp    %eax,%esi
  8024f4:	73 35                	jae    80252b <memmove+0x47>
  8024f6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8024f9:	39 d0                	cmp    %edx,%eax
  8024fb:	73 2e                	jae    80252b <memmove+0x47>
		s += n;
		d += n;
  8024fd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802500:	89 d6                	mov    %edx,%esi
  802502:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802504:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80250a:	75 13                	jne    80251f <memmove+0x3b>
  80250c:	f6 c1 03             	test   $0x3,%cl
  80250f:	75 0e                	jne    80251f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802511:	83 ef 04             	sub    $0x4,%edi
  802514:	8d 72 fc             	lea    -0x4(%edx),%esi
  802517:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80251a:	fd                   	std    
  80251b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80251d:	eb 09                	jmp    802528 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80251f:	83 ef 01             	sub    $0x1,%edi
  802522:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802525:	fd                   	std    
  802526:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802528:	fc                   	cld    
  802529:	eb 1d                	jmp    802548 <memmove+0x64>
  80252b:	89 f2                	mov    %esi,%edx
  80252d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80252f:	f6 c2 03             	test   $0x3,%dl
  802532:	75 0f                	jne    802543 <memmove+0x5f>
  802534:	f6 c1 03             	test   $0x3,%cl
  802537:	75 0a                	jne    802543 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802539:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80253c:	89 c7                	mov    %eax,%edi
  80253e:	fc                   	cld    
  80253f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802541:	eb 05                	jmp    802548 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802543:	89 c7                	mov    %eax,%edi
  802545:	fc                   	cld    
  802546:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802548:	5e                   	pop    %esi
  802549:	5f                   	pop    %edi
  80254a:	5d                   	pop    %ebp
  80254b:	c3                   	ret    

0080254c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802552:	8b 45 10             	mov    0x10(%ebp),%eax
  802555:	89 44 24 08          	mov    %eax,0x8(%esp)
  802559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802560:	8b 45 08             	mov    0x8(%ebp),%eax
  802563:	89 04 24             	mov    %eax,(%esp)
  802566:	e8 79 ff ff ff       	call   8024e4 <memmove>
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
  802570:	56                   	push   %esi
  802571:	53                   	push   %ebx
  802572:	8b 55 08             	mov    0x8(%ebp),%edx
  802575:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802578:	89 d6                	mov    %edx,%esi
  80257a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80257d:	eb 1a                	jmp    802599 <memcmp+0x2c>
		if (*s1 != *s2)
  80257f:	0f b6 02             	movzbl (%edx),%eax
  802582:	0f b6 19             	movzbl (%ecx),%ebx
  802585:	38 d8                	cmp    %bl,%al
  802587:	74 0a                	je     802593 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  802589:	0f b6 c0             	movzbl %al,%eax
  80258c:	0f b6 db             	movzbl %bl,%ebx
  80258f:	29 d8                	sub    %ebx,%eax
  802591:	eb 0f                	jmp    8025a2 <memcmp+0x35>
		s1++, s2++;
  802593:	83 c2 01             	add    $0x1,%edx
  802596:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802599:	39 f2                	cmp    %esi,%edx
  80259b:	75 e2                	jne    80257f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80259d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a2:	5b                   	pop    %ebx
  8025a3:	5e                   	pop    %esi
  8025a4:	5d                   	pop    %ebp
  8025a5:	c3                   	ret    

008025a6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8025af:	89 c2                	mov    %eax,%edx
  8025b1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8025b4:	eb 07                	jmp    8025bd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8025b6:	38 08                	cmp    %cl,(%eax)
  8025b8:	74 07                	je     8025c1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8025ba:	83 c0 01             	add    $0x1,%eax
  8025bd:	39 d0                	cmp    %edx,%eax
  8025bf:	72 f5                	jb     8025b6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8025c1:	5d                   	pop    %ebp
  8025c2:	c3                   	ret    

008025c3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	57                   	push   %edi
  8025c7:	56                   	push   %esi
  8025c8:	53                   	push   %ebx
  8025c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025cc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025cf:	eb 03                	jmp    8025d4 <strtol+0x11>
		s++;
  8025d1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025d4:	0f b6 0a             	movzbl (%edx),%ecx
  8025d7:	80 f9 09             	cmp    $0x9,%cl
  8025da:	74 f5                	je     8025d1 <strtol+0xe>
  8025dc:	80 f9 20             	cmp    $0x20,%cl
  8025df:	74 f0                	je     8025d1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8025e1:	80 f9 2b             	cmp    $0x2b,%cl
  8025e4:	75 0a                	jne    8025f0 <strtol+0x2d>
		s++;
  8025e6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8025e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ee:	eb 11                	jmp    802601 <strtol+0x3e>
  8025f0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8025f5:	80 f9 2d             	cmp    $0x2d,%cl
  8025f8:	75 07                	jne    802601 <strtol+0x3e>
		s++, neg = 1;
  8025fa:	8d 52 01             	lea    0x1(%edx),%edx
  8025fd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802601:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802606:	75 15                	jne    80261d <strtol+0x5a>
  802608:	80 3a 30             	cmpb   $0x30,(%edx)
  80260b:	75 10                	jne    80261d <strtol+0x5a>
  80260d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802611:	75 0a                	jne    80261d <strtol+0x5a>
		s += 2, base = 16;
  802613:	83 c2 02             	add    $0x2,%edx
  802616:	b8 10 00 00 00       	mov    $0x10,%eax
  80261b:	eb 10                	jmp    80262d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80261d:	85 c0                	test   %eax,%eax
  80261f:	75 0c                	jne    80262d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802621:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802623:	80 3a 30             	cmpb   $0x30,(%edx)
  802626:	75 05                	jne    80262d <strtol+0x6a>
		s++, base = 8;
  802628:	83 c2 01             	add    $0x1,%edx
  80262b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80262d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802632:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802635:	0f b6 0a             	movzbl (%edx),%ecx
  802638:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80263b:	89 f0                	mov    %esi,%eax
  80263d:	3c 09                	cmp    $0x9,%al
  80263f:	77 08                	ja     802649 <strtol+0x86>
			dig = *s - '0';
  802641:	0f be c9             	movsbl %cl,%ecx
  802644:	83 e9 30             	sub    $0x30,%ecx
  802647:	eb 20                	jmp    802669 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  802649:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80264c:	89 f0                	mov    %esi,%eax
  80264e:	3c 19                	cmp    $0x19,%al
  802650:	77 08                	ja     80265a <strtol+0x97>
			dig = *s - 'a' + 10;
  802652:	0f be c9             	movsbl %cl,%ecx
  802655:	83 e9 57             	sub    $0x57,%ecx
  802658:	eb 0f                	jmp    802669 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80265a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80265d:	89 f0                	mov    %esi,%eax
  80265f:	3c 19                	cmp    $0x19,%al
  802661:	77 16                	ja     802679 <strtol+0xb6>
			dig = *s - 'A' + 10;
  802663:	0f be c9             	movsbl %cl,%ecx
  802666:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  802669:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80266c:	7d 0f                	jge    80267d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80266e:	83 c2 01             	add    $0x1,%edx
  802671:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  802675:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  802677:	eb bc                	jmp    802635 <strtol+0x72>
  802679:	89 d8                	mov    %ebx,%eax
  80267b:	eb 02                	jmp    80267f <strtol+0xbc>
  80267d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80267f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802683:	74 05                	je     80268a <strtol+0xc7>
		*endptr = (char *) s;
  802685:	8b 75 0c             	mov    0xc(%ebp),%esi
  802688:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80268a:	f7 d8                	neg    %eax
  80268c:	85 ff                	test   %edi,%edi
  80268e:	0f 44 c3             	cmove  %ebx,%eax
}
  802691:	5b                   	pop    %ebx
  802692:	5e                   	pop    %esi
  802693:	5f                   	pop    %edi
  802694:	5d                   	pop    %ebp
  802695:	c3                   	ret    

00802696 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	57                   	push   %edi
  80269a:	56                   	push   %esi
  80269b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a7:	89 c3                	mov    %eax,%ebx
  8026a9:	89 c7                	mov    %eax,%edi
  8026ab:	89 c6                	mov    %eax,%esi
  8026ad:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8026af:	5b                   	pop    %ebx
  8026b0:	5e                   	pop    %esi
  8026b1:	5f                   	pop    %edi
  8026b2:	5d                   	pop    %ebp
  8026b3:	c3                   	ret    

008026b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	57                   	push   %edi
  8026b8:	56                   	push   %esi
  8026b9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8026ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8026bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c4:	89 d1                	mov    %edx,%ecx
  8026c6:	89 d3                	mov    %edx,%ebx
  8026c8:	89 d7                	mov    %edx,%edi
  8026ca:	89 d6                	mov    %edx,%esi
  8026cc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8026ce:	5b                   	pop    %ebx
  8026cf:	5e                   	pop    %esi
  8026d0:	5f                   	pop    %edi
  8026d1:	5d                   	pop    %ebp
  8026d2:	c3                   	ret    

008026d3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
  8026d6:	57                   	push   %edi
  8026d7:	56                   	push   %esi
  8026d8:	53                   	push   %ebx
  8026d9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8026dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8026e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e9:	89 cb                	mov    %ecx,%ebx
  8026eb:	89 cf                	mov    %ecx,%edi
  8026ed:	89 ce                	mov    %ecx,%esi
  8026ef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	7e 28                	jle    80271d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8026f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8026f9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  802700:	00 
  802701:	c7 44 24 08 9f 4a 80 	movl   $0x804a9f,0x8(%esp)
  802708:	00 
  802709:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802710:	00 
  802711:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  802718:	e8 05 f5 ff ff       	call   801c22 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80271d:	83 c4 2c             	add    $0x2c,%esp
  802720:	5b                   	pop    %ebx
  802721:	5e                   	pop    %esi
  802722:	5f                   	pop    %edi
  802723:	5d                   	pop    %ebp
  802724:	c3                   	ret    

00802725 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
  802728:	57                   	push   %edi
  802729:	56                   	push   %esi
  80272a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80272b:	ba 00 00 00 00       	mov    $0x0,%edx
  802730:	b8 02 00 00 00       	mov    $0x2,%eax
  802735:	89 d1                	mov    %edx,%ecx
  802737:	89 d3                	mov    %edx,%ebx
  802739:	89 d7                	mov    %edx,%edi
  80273b:	89 d6                	mov    %edx,%esi
  80273d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80273f:	5b                   	pop    %ebx
  802740:	5e                   	pop    %esi
  802741:	5f                   	pop    %edi
  802742:	5d                   	pop    %ebp
  802743:	c3                   	ret    

00802744 <sys_yield>:

void
sys_yield(void)
{
  802744:	55                   	push   %ebp
  802745:	89 e5                	mov    %esp,%ebp
  802747:	57                   	push   %edi
  802748:	56                   	push   %esi
  802749:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80274a:	ba 00 00 00 00       	mov    $0x0,%edx
  80274f:	b8 0b 00 00 00       	mov    $0xb,%eax
  802754:	89 d1                	mov    %edx,%ecx
  802756:	89 d3                	mov    %edx,%ebx
  802758:	89 d7                	mov    %edx,%edi
  80275a:	89 d6                	mov    %edx,%esi
  80275c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80275e:	5b                   	pop    %ebx
  80275f:	5e                   	pop    %esi
  802760:	5f                   	pop    %edi
  802761:	5d                   	pop    %ebp
  802762:	c3                   	ret    

00802763 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	57                   	push   %edi
  802767:	56                   	push   %esi
  802768:	53                   	push   %ebx
  802769:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80276c:	be 00 00 00 00       	mov    $0x0,%esi
  802771:	b8 04 00 00 00       	mov    $0x4,%eax
  802776:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802779:	8b 55 08             	mov    0x8(%ebp),%edx
  80277c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80277f:	89 f7                	mov    %esi,%edi
  802781:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802783:	85 c0                	test   %eax,%eax
  802785:	7e 28                	jle    8027af <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  802787:	89 44 24 10          	mov    %eax,0x10(%esp)
  80278b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  802792:	00 
  802793:	c7 44 24 08 9f 4a 80 	movl   $0x804a9f,0x8(%esp)
  80279a:	00 
  80279b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8027a2:	00 
  8027a3:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  8027aa:	e8 73 f4 ff ff       	call   801c22 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8027af:	83 c4 2c             	add    $0x2c,%esp
  8027b2:	5b                   	pop    %ebx
  8027b3:	5e                   	pop    %esi
  8027b4:	5f                   	pop    %edi
  8027b5:	5d                   	pop    %ebp
  8027b6:	c3                   	ret    

008027b7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	57                   	push   %edi
  8027bb:	56                   	push   %esi
  8027bc:	53                   	push   %ebx
  8027bd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8027c0:	b8 05 00 00 00       	mov    $0x5,%eax
  8027c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027ce:	8b 7d 14             	mov    0x14(%ebp),%edi
  8027d1:	8b 75 18             	mov    0x18(%ebp),%esi
  8027d4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	7e 28                	jle    802802 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8027da:	89 44 24 10          	mov    %eax,0x10(%esp)
  8027de:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8027e5:	00 
  8027e6:	c7 44 24 08 9f 4a 80 	movl   $0x804a9f,0x8(%esp)
  8027ed:	00 
  8027ee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8027f5:	00 
  8027f6:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  8027fd:	e8 20 f4 ff ff       	call   801c22 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802802:	83 c4 2c             	add    $0x2c,%esp
  802805:	5b                   	pop    %ebx
  802806:	5e                   	pop    %esi
  802807:	5f                   	pop    %edi
  802808:	5d                   	pop    %ebp
  802809:	c3                   	ret    

0080280a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
  80280d:	57                   	push   %edi
  80280e:	56                   	push   %esi
  80280f:	53                   	push   %ebx
  802810:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802813:	bb 00 00 00 00       	mov    $0x0,%ebx
  802818:	b8 06 00 00 00       	mov    $0x6,%eax
  80281d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802820:	8b 55 08             	mov    0x8(%ebp),%edx
  802823:	89 df                	mov    %ebx,%edi
  802825:	89 de                	mov    %ebx,%esi
  802827:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802829:	85 c0                	test   %eax,%eax
  80282b:	7e 28                	jle    802855 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80282d:	89 44 24 10          	mov    %eax,0x10(%esp)
  802831:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  802838:	00 
  802839:	c7 44 24 08 9f 4a 80 	movl   $0x804a9f,0x8(%esp)
  802840:	00 
  802841:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802848:	00 
  802849:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  802850:	e8 cd f3 ff ff       	call   801c22 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802855:	83 c4 2c             	add    $0x2c,%esp
  802858:	5b                   	pop    %ebx
  802859:	5e                   	pop    %esi
  80285a:	5f                   	pop    %edi
  80285b:	5d                   	pop    %ebp
  80285c:	c3                   	ret    

0080285d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
  802860:	57                   	push   %edi
  802861:	56                   	push   %esi
  802862:	53                   	push   %ebx
  802863:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802866:	bb 00 00 00 00       	mov    $0x0,%ebx
  80286b:	b8 08 00 00 00       	mov    $0x8,%eax
  802870:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802873:	8b 55 08             	mov    0x8(%ebp),%edx
  802876:	89 df                	mov    %ebx,%edi
  802878:	89 de                	mov    %ebx,%esi
  80287a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80287c:	85 c0                	test   %eax,%eax
  80287e:	7e 28                	jle    8028a8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802880:	89 44 24 10          	mov    %eax,0x10(%esp)
  802884:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80288b:	00 
  80288c:	c7 44 24 08 9f 4a 80 	movl   $0x804a9f,0x8(%esp)
  802893:	00 
  802894:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80289b:	00 
  80289c:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  8028a3:	e8 7a f3 ff ff       	call   801c22 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8028a8:	83 c4 2c             	add    $0x2c,%esp
  8028ab:	5b                   	pop    %ebx
  8028ac:	5e                   	pop    %esi
  8028ad:	5f                   	pop    %edi
  8028ae:	5d                   	pop    %ebp
  8028af:	c3                   	ret    

008028b0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
  8028b3:	57                   	push   %edi
  8028b4:	56                   	push   %esi
  8028b5:	53                   	push   %ebx
  8028b6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028be:	b8 09 00 00 00       	mov    $0x9,%eax
  8028c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c9:	89 df                	mov    %ebx,%edi
  8028cb:	89 de                	mov    %ebx,%esi
  8028cd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	7e 28                	jle    8028fb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8028d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8028d7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8028de:	00 
  8028df:	c7 44 24 08 9f 4a 80 	movl   $0x804a9f,0x8(%esp)
  8028e6:	00 
  8028e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8028ee:	00 
  8028ef:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  8028f6:	e8 27 f3 ff ff       	call   801c22 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8028fb:	83 c4 2c             	add    $0x2c,%esp
  8028fe:	5b                   	pop    %ebx
  8028ff:	5e                   	pop    %esi
  802900:	5f                   	pop    %edi
  802901:	5d                   	pop    %ebp
  802902:	c3                   	ret    

00802903 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802903:	55                   	push   %ebp
  802904:	89 e5                	mov    %esp,%ebp
  802906:	57                   	push   %edi
  802907:	56                   	push   %esi
  802908:	53                   	push   %ebx
  802909:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80290c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802911:	b8 0a 00 00 00       	mov    $0xa,%eax
  802916:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802919:	8b 55 08             	mov    0x8(%ebp),%edx
  80291c:	89 df                	mov    %ebx,%edi
  80291e:	89 de                	mov    %ebx,%esi
  802920:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802922:	85 c0                	test   %eax,%eax
  802924:	7e 28                	jle    80294e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802926:	89 44 24 10          	mov    %eax,0x10(%esp)
  80292a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  802931:	00 
  802932:	c7 44 24 08 9f 4a 80 	movl   $0x804a9f,0x8(%esp)
  802939:	00 
  80293a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802941:	00 
  802942:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  802949:	e8 d4 f2 ff ff       	call   801c22 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80294e:	83 c4 2c             	add    $0x2c,%esp
  802951:	5b                   	pop    %ebx
  802952:	5e                   	pop    %esi
  802953:	5f                   	pop    %edi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    

00802956 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
  802959:	57                   	push   %edi
  80295a:	56                   	push   %esi
  80295b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80295c:	be 00 00 00 00       	mov    $0x0,%esi
  802961:	b8 0c 00 00 00       	mov    $0xc,%eax
  802966:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802969:	8b 55 08             	mov    0x8(%ebp),%edx
  80296c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80296f:	8b 7d 14             	mov    0x14(%ebp),%edi
  802972:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802974:	5b                   	pop    %ebx
  802975:	5e                   	pop    %esi
  802976:	5f                   	pop    %edi
  802977:	5d                   	pop    %ebp
  802978:	c3                   	ret    

00802979 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802979:	55                   	push   %ebp
  80297a:	89 e5                	mov    %esp,%ebp
  80297c:	57                   	push   %edi
  80297d:	56                   	push   %esi
  80297e:	53                   	push   %ebx
  80297f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802982:	b9 00 00 00 00       	mov    $0x0,%ecx
  802987:	b8 0d 00 00 00       	mov    $0xd,%eax
  80298c:	8b 55 08             	mov    0x8(%ebp),%edx
  80298f:	89 cb                	mov    %ecx,%ebx
  802991:	89 cf                	mov    %ecx,%edi
  802993:	89 ce                	mov    %ecx,%esi
  802995:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802997:	85 c0                	test   %eax,%eax
  802999:	7e 28                	jle    8029c3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80299b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80299f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8029a6:	00 
  8029a7:	c7 44 24 08 9f 4a 80 	movl   $0x804a9f,0x8(%esp)
  8029ae:	00 
  8029af:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8029b6:	00 
  8029b7:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  8029be:	e8 5f f2 ff ff       	call   801c22 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8029c3:	83 c4 2c             	add    $0x2c,%esp
  8029c6:	5b                   	pop    %ebx
  8029c7:	5e                   	pop    %esi
  8029c8:	5f                   	pop    %edi
  8029c9:	5d                   	pop    %ebp
  8029ca:	c3                   	ret    

008029cb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8029cb:	55                   	push   %ebp
  8029cc:	89 e5                	mov    %esp,%ebp
  8029ce:	57                   	push   %edi
  8029cf:	56                   	push   %esi
  8029d0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8029d6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8029db:	89 d1                	mov    %edx,%ecx
  8029dd:	89 d3                	mov    %edx,%ebx
  8029df:	89 d7                	mov    %edx,%edi
  8029e1:	89 d6                	mov    %edx,%esi
  8029e3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8029e5:	5b                   	pop    %ebx
  8029e6:	5e                   	pop    %esi
  8029e7:	5f                   	pop    %edi
  8029e8:	5d                   	pop    %ebp
  8029e9:	c3                   	ret    

008029ea <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  8029ea:	55                   	push   %ebp
  8029eb:	89 e5                	mov    %esp,%ebp
  8029ed:	57                   	push   %edi
  8029ee:	56                   	push   %esi
  8029ef:	53                   	push   %ebx
  8029f0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029f8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8029fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a00:	8b 55 08             	mov    0x8(%ebp),%edx
  802a03:	89 df                	mov    %ebx,%edi
  802a05:	89 de                	mov    %ebx,%esi
  802a07:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	7e 28                	jle    802a35 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a0d:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a11:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  802a18:	00 
  802a19:	c7 44 24 08 9f 4a 80 	movl   $0x804a9f,0x8(%esp)
  802a20:	00 
  802a21:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802a28:	00 
  802a29:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  802a30:	e8 ed f1 ff ff       	call   801c22 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  802a35:	83 c4 2c             	add    $0x2c,%esp
  802a38:	5b                   	pop    %ebx
  802a39:	5e                   	pop    %esi
  802a3a:	5f                   	pop    %edi
  802a3b:	5d                   	pop    %ebp
  802a3c:	c3                   	ret    

00802a3d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  802a3d:	55                   	push   %ebp
  802a3e:	89 e5                	mov    %esp,%ebp
  802a40:	57                   	push   %edi
  802a41:	56                   	push   %esi
  802a42:	53                   	push   %ebx
  802a43:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a46:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a4b:	b8 10 00 00 00       	mov    $0x10,%eax
  802a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a53:	8b 55 08             	mov    0x8(%ebp),%edx
  802a56:	89 df                	mov    %ebx,%edi
  802a58:	89 de                	mov    %ebx,%esi
  802a5a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	7e 28                	jle    802a88 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a60:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a64:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  802a6b:	00 
  802a6c:	c7 44 24 08 9f 4a 80 	movl   $0x804a9f,0x8(%esp)
  802a73:	00 
  802a74:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802a7b:	00 
  802a7c:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  802a83:	e8 9a f1 ff ff       	call   801c22 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  802a88:	83 c4 2c             	add    $0x2c,%esp
  802a8b:	5b                   	pop    %ebx
  802a8c:	5e                   	pop    %esi
  802a8d:	5f                   	pop    %edi
  802a8e:	5d                   	pop    %ebp
  802a8f:	c3                   	ret    

00802a90 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a90:	55                   	push   %ebp
  802a91:	89 e5                	mov    %esp,%ebp
  802a93:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802a96:	83 3d 14 a0 80 00 00 	cmpl   $0x0,0x80a014
  802a9d:	75 58                	jne    802af7 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  802a9f:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802aa4:	8b 40 48             	mov    0x48(%eax),%eax
  802aa7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802aae:	00 
  802aaf:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802ab6:	ee 
  802ab7:	89 04 24             	mov    %eax,(%esp)
  802aba:	e8 a4 fc ff ff       	call   802763 <sys_page_alloc>
		if(return_code!=0)
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	74 1c                	je     802adf <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802ac3:	c7 44 24 08 cc 4a 80 	movl   $0x804acc,0x8(%esp)
  802aca:	00 
  802acb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802ad2:	00 
  802ad3:	c7 04 24 25 4b 80 00 	movl   $0x804b25,(%esp)
  802ada:	e8 43 f1 ff ff       	call   801c22 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  802adf:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802ae4:	8b 40 48             	mov    0x48(%eax),%eax
  802ae7:	c7 44 24 04 01 2b 80 	movl   $0x802b01,0x4(%esp)
  802aee:	00 
  802aef:	89 04 24             	mov    %eax,(%esp)
  802af2:	e8 0c fe ff ff       	call   802903 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	a3 14 a0 80 00       	mov    %eax,0x80a014
}
  802aff:	c9                   	leave  
  802b00:	c3                   	ret    

00802b01 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b01:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b02:	a1 14 a0 80 00       	mov    0x80a014,%eax
	call *%eax
  802b07:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b09:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  802b0c:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  802b0e:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  802b12:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  802b16:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  802b17:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  802b19:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  802b1b:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  802b1f:	58                   	pop    %eax
	popl %eax;
  802b20:	58                   	pop    %eax
	popal;
  802b21:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  802b22:	83 c4 04             	add    $0x4,%esp
	popfl;
  802b25:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802b26:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  802b27:	c3                   	ret    

00802b28 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802b28:	55                   	push   %ebp
  802b29:	89 e5                	mov    %esp,%ebp
  802b2b:	56                   	push   %esi
  802b2c:	53                   	push   %ebx
  802b2d:	83 ec 10             	sub    $0x10,%esp
  802b30:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b36:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802b39:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802b3b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802b40:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802b43:	89 04 24             	mov    %eax,(%esp)
  802b46:	e8 2e fe ff ff       	call   802979 <sys_ipc_recv>
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	75 1e                	jne    802b6d <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802b4f:	85 db                	test   %ebx,%ebx
  802b51:	74 0a                	je     802b5d <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802b53:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802b58:	8b 40 74             	mov    0x74(%eax),%eax
  802b5b:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  802b5d:	85 f6                	test   %esi,%esi
  802b5f:	74 22                	je     802b83 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  802b61:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802b66:	8b 40 78             	mov    0x78(%eax),%eax
  802b69:	89 06                	mov    %eax,(%esi)
  802b6b:	eb 16                	jmp    802b83 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802b6d:	85 f6                	test   %esi,%esi
  802b6f:	74 06                	je     802b77 <ipc_recv+0x4f>
				*perm_store = 0;
  802b71:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802b77:	85 db                	test   %ebx,%ebx
  802b79:	74 10                	je     802b8b <ipc_recv+0x63>
				*from_env_store=0;
  802b7b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802b81:	eb 08                	jmp    802b8b <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802b83:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802b88:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802b8b:	83 c4 10             	add    $0x10,%esp
  802b8e:	5b                   	pop    %ebx
  802b8f:	5e                   	pop    %esi
  802b90:	5d                   	pop    %ebp
  802b91:	c3                   	ret    

00802b92 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b92:	55                   	push   %ebp
  802b93:	89 e5                	mov    %esp,%ebp
  802b95:	57                   	push   %edi
  802b96:	56                   	push   %esi
  802b97:	53                   	push   %ebx
  802b98:	83 ec 1c             	sub    $0x1c,%esp
  802b9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802ba1:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802ba4:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802ba6:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802bab:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802bae:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bb2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802bb6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	89 04 24             	mov    %eax,(%esp)
  802bc0:	e8 91 fd ff ff       	call   802956 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802bc5:	eb 1c                	jmp    802be3 <ipc_send+0x51>
	{
		sys_yield();
  802bc7:	e8 78 fb ff ff       	call   802744 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802bcc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bd0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802bd4:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	89 04 24             	mov    %eax,(%esp)
  802bde:	e8 73 fd ff ff       	call   802956 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802be3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802be6:	74 df                	je     802bc7 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802be8:	83 c4 1c             	add    $0x1c,%esp
  802beb:	5b                   	pop    %ebx
  802bec:	5e                   	pop    %esi
  802bed:	5f                   	pop    %edi
  802bee:	5d                   	pop    %ebp
  802bef:	c3                   	ret    

00802bf0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802bf0:	55                   	push   %ebp
  802bf1:	89 e5                	mov    %esp,%ebp
  802bf3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802bf6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802bfb:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802bfe:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802c04:	8b 52 50             	mov    0x50(%edx),%edx
  802c07:	39 ca                	cmp    %ecx,%edx
  802c09:	75 0d                	jne    802c18 <ipc_find_env+0x28>
			return envs[i].env_id;
  802c0b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802c0e:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802c13:	8b 40 40             	mov    0x40(%eax),%eax
  802c16:	eb 0e                	jmp    802c26 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802c18:	83 c0 01             	add    $0x1,%eax
  802c1b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802c20:	75 d9                	jne    802bfb <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802c22:	66 b8 00 00          	mov    $0x0,%ax
}
  802c26:	5d                   	pop    %ebp
  802c27:	c3                   	ret    
  802c28:	66 90                	xchg   %ax,%ax
  802c2a:	66 90                	xchg   %ax,%ax
  802c2c:	66 90                	xchg   %ax,%ax
  802c2e:	66 90                	xchg   %ax,%ax

00802c30 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802c30:	55                   	push   %ebp
  802c31:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	05 00 00 00 30       	add    $0x30000000,%eax
  802c3b:	c1 e8 0c             	shr    $0xc,%eax
}
  802c3e:	5d                   	pop    %ebp
  802c3f:	c3                   	ret    

00802c40 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802c40:	55                   	push   %ebp
  802c41:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  802c4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802c50:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802c55:	5d                   	pop    %ebp
  802c56:	c3                   	ret    

00802c57 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802c57:	55                   	push   %ebp
  802c58:	89 e5                	mov    %esp,%ebp
  802c5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c5d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802c62:	89 c2                	mov    %eax,%edx
  802c64:	c1 ea 16             	shr    $0x16,%edx
  802c67:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802c6e:	f6 c2 01             	test   $0x1,%dl
  802c71:	74 11                	je     802c84 <fd_alloc+0x2d>
  802c73:	89 c2                	mov    %eax,%edx
  802c75:	c1 ea 0c             	shr    $0xc,%edx
  802c78:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802c7f:	f6 c2 01             	test   $0x1,%dl
  802c82:	75 09                	jne    802c8d <fd_alloc+0x36>
			*fd_store = fd;
  802c84:	89 01                	mov    %eax,(%ecx)
			return 0;
  802c86:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8b:	eb 17                	jmp    802ca4 <fd_alloc+0x4d>
  802c8d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802c92:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802c97:	75 c9                	jne    802c62 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802c99:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  802c9f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  802ca4:	5d                   	pop    %ebp
  802ca5:	c3                   	ret    

00802ca6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802ca6:	55                   	push   %ebp
  802ca7:	89 e5                	mov    %esp,%ebp
  802ca9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802cac:	83 f8 1f             	cmp    $0x1f,%eax
  802caf:	77 36                	ja     802ce7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802cb1:	c1 e0 0c             	shl    $0xc,%eax
  802cb4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802cb9:	89 c2                	mov    %eax,%edx
  802cbb:	c1 ea 16             	shr    $0x16,%edx
  802cbe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802cc5:	f6 c2 01             	test   $0x1,%dl
  802cc8:	74 24                	je     802cee <fd_lookup+0x48>
  802cca:	89 c2                	mov    %eax,%edx
  802ccc:	c1 ea 0c             	shr    $0xc,%edx
  802ccf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802cd6:	f6 c2 01             	test   $0x1,%dl
  802cd9:	74 1a                	je     802cf5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cde:	89 02                	mov    %eax,(%edx)
	return 0;
  802ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce5:	eb 13                	jmp    802cfa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802ce7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cec:	eb 0c                	jmp    802cfa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802cee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cf3:	eb 05                	jmp    802cfa <fd_lookup+0x54>
  802cf5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  802cfa:	5d                   	pop    %ebp
  802cfb:	c3                   	ret    

00802cfc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802cfc:	55                   	push   %ebp
  802cfd:	89 e5                	mov    %esp,%ebp
  802cff:	83 ec 18             	sub    $0x18,%esp
  802d02:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  802d05:	ba 00 00 00 00       	mov    $0x0,%edx
  802d0a:	eb 13                	jmp    802d1f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  802d0c:	39 08                	cmp    %ecx,(%eax)
  802d0e:	75 0c                	jne    802d1c <dev_lookup+0x20>
			*dev = devtab[i];
  802d10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d13:	89 01                	mov    %eax,(%ecx)
			return 0;
  802d15:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1a:	eb 38                	jmp    802d54 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  802d1c:	83 c2 01             	add    $0x1,%edx
  802d1f:	8b 04 95 b4 4b 80 00 	mov    0x804bb4(,%edx,4),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	75 e2                	jne    802d0c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802d2a:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802d2f:	8b 40 48             	mov    0x48(%eax),%eax
  802d32:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d3a:	c7 04 24 34 4b 80 00 	movl   $0x804b34,(%esp)
  802d41:	e8 d5 ef ff ff       	call   801d1b <cprintf>
	*dev = 0;
  802d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802d4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d54:	c9                   	leave  
  802d55:	c3                   	ret    

00802d56 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802d56:	55                   	push   %ebp
  802d57:	89 e5                	mov    %esp,%ebp
  802d59:	56                   	push   %esi
  802d5a:	53                   	push   %ebx
  802d5b:	83 ec 20             	sub    $0x20,%esp
  802d5e:	8b 75 08             	mov    0x8(%ebp),%esi
  802d61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802d64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d67:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802d6b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802d71:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802d74:	89 04 24             	mov    %eax,(%esp)
  802d77:	e8 2a ff ff ff       	call   802ca6 <fd_lookup>
  802d7c:	85 c0                	test   %eax,%eax
  802d7e:	78 05                	js     802d85 <fd_close+0x2f>
	    || fd != fd2)
  802d80:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  802d83:	74 0c                	je     802d91 <fd_close+0x3b>
		return (must_exist ? r : 0);
  802d85:	84 db                	test   %bl,%bl
  802d87:	ba 00 00 00 00       	mov    $0x0,%edx
  802d8c:	0f 44 c2             	cmove  %edx,%eax
  802d8f:	eb 3f                	jmp    802dd0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802d91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d98:	8b 06                	mov    (%esi),%eax
  802d9a:	89 04 24             	mov    %eax,(%esp)
  802d9d:	e8 5a ff ff ff       	call   802cfc <dev_lookup>
  802da2:	89 c3                	mov    %eax,%ebx
  802da4:	85 c0                	test   %eax,%eax
  802da6:	78 16                	js     802dbe <fd_close+0x68>
		if (dev->dev_close)
  802da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  802dae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  802db3:	85 c0                	test   %eax,%eax
  802db5:	74 07                	je     802dbe <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  802db7:	89 34 24             	mov    %esi,(%esp)
  802dba:	ff d0                	call   *%eax
  802dbc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802dbe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802dc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dc9:	e8 3c fa ff ff       	call   80280a <sys_page_unmap>
	return r;
  802dce:	89 d8                	mov    %ebx,%eax
}
  802dd0:	83 c4 20             	add    $0x20,%esp
  802dd3:	5b                   	pop    %ebx
  802dd4:	5e                   	pop    %esi
  802dd5:	5d                   	pop    %ebp
  802dd6:	c3                   	ret    

00802dd7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  802dd7:	55                   	push   %ebp
  802dd8:	89 e5                	mov    %esp,%ebp
  802dda:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ddd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802de0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	89 04 24             	mov    %eax,(%esp)
  802dea:	e8 b7 fe ff ff       	call   802ca6 <fd_lookup>
  802def:	89 c2                	mov    %eax,%edx
  802df1:	85 d2                	test   %edx,%edx
  802df3:	78 13                	js     802e08 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  802df5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802dfc:	00 
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	89 04 24             	mov    %eax,(%esp)
  802e03:	e8 4e ff ff ff       	call   802d56 <fd_close>
}
  802e08:	c9                   	leave  
  802e09:	c3                   	ret    

00802e0a <close_all>:

void
close_all(void)
{
  802e0a:	55                   	push   %ebp
  802e0b:	89 e5                	mov    %esp,%ebp
  802e0d:	53                   	push   %ebx
  802e0e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802e11:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802e16:	89 1c 24             	mov    %ebx,(%esp)
  802e19:	e8 b9 ff ff ff       	call   802dd7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802e1e:	83 c3 01             	add    $0x1,%ebx
  802e21:	83 fb 20             	cmp    $0x20,%ebx
  802e24:	75 f0                	jne    802e16 <close_all+0xc>
		close(i);
}
  802e26:	83 c4 14             	add    $0x14,%esp
  802e29:	5b                   	pop    %ebx
  802e2a:	5d                   	pop    %ebp
  802e2b:	c3                   	ret    

00802e2c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802e2c:	55                   	push   %ebp
  802e2d:	89 e5                	mov    %esp,%ebp
  802e2f:	57                   	push   %edi
  802e30:	56                   	push   %esi
  802e31:	53                   	push   %ebx
  802e32:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802e35:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802e38:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3f:	89 04 24             	mov    %eax,(%esp)
  802e42:	e8 5f fe ff ff       	call   802ca6 <fd_lookup>
  802e47:	89 c2                	mov    %eax,%edx
  802e49:	85 d2                	test   %edx,%edx
  802e4b:	0f 88 e1 00 00 00    	js     802f32 <dup+0x106>
		return r;
	close(newfdnum);
  802e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e54:	89 04 24             	mov    %eax,(%esp)
  802e57:	e8 7b ff ff ff       	call   802dd7 <close>

	newfd = INDEX2FD(newfdnum);
  802e5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802e5f:	c1 e3 0c             	shl    $0xc,%ebx
  802e62:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  802e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6b:	89 04 24             	mov    %eax,(%esp)
  802e6e:	e8 cd fd ff ff       	call   802c40 <fd2data>
  802e73:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  802e75:	89 1c 24             	mov    %ebx,(%esp)
  802e78:	e8 c3 fd ff ff       	call   802c40 <fd2data>
  802e7d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802e7f:	89 f0                	mov    %esi,%eax
  802e81:	c1 e8 16             	shr    $0x16,%eax
  802e84:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802e8b:	a8 01                	test   $0x1,%al
  802e8d:	74 43                	je     802ed2 <dup+0xa6>
  802e8f:	89 f0                	mov    %esi,%eax
  802e91:	c1 e8 0c             	shr    $0xc,%eax
  802e94:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802e9b:	f6 c2 01             	test   $0x1,%dl
  802e9e:	74 32                	je     802ed2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ea0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802ea7:	25 07 0e 00 00       	and    $0xe07,%eax
  802eac:	89 44 24 10          	mov    %eax,0x10(%esp)
  802eb0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802eb4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802ebb:	00 
  802ebc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ec0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ec7:	e8 eb f8 ff ff       	call   8027b7 <sys_page_map>
  802ecc:	89 c6                	mov    %eax,%esi
  802ece:	85 c0                	test   %eax,%eax
  802ed0:	78 3e                	js     802f10 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed5:	89 c2                	mov    %eax,%edx
  802ed7:	c1 ea 0c             	shr    $0xc,%edx
  802eda:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802ee1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802ee7:	89 54 24 10          	mov    %edx,0x10(%esp)
  802eeb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802eef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802ef6:	00 
  802ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802efb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f02:	e8 b0 f8 ff ff       	call   8027b7 <sys_page_map>
  802f07:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  802f09:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f0c:	85 f6                	test   %esi,%esi
  802f0e:	79 22                	jns    802f32 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802f10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f1b:	e8 ea f8 ff ff       	call   80280a <sys_page_unmap>
	sys_page_unmap(0, nva);
  802f20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802f24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f2b:	e8 da f8 ff ff       	call   80280a <sys_page_unmap>
	return r;
  802f30:	89 f0                	mov    %esi,%eax
}
  802f32:	83 c4 3c             	add    $0x3c,%esp
  802f35:	5b                   	pop    %ebx
  802f36:	5e                   	pop    %esi
  802f37:	5f                   	pop    %edi
  802f38:	5d                   	pop    %ebp
  802f39:	c3                   	ret    

00802f3a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f3a:	55                   	push   %ebp
  802f3b:	89 e5                	mov    %esp,%ebp
  802f3d:	53                   	push   %ebx
  802f3e:	83 ec 24             	sub    $0x24,%esp
  802f41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f44:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f47:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f4b:	89 1c 24             	mov    %ebx,(%esp)
  802f4e:	e8 53 fd ff ff       	call   802ca6 <fd_lookup>
  802f53:	89 c2                	mov    %eax,%edx
  802f55:	85 d2                	test   %edx,%edx
  802f57:	78 6d                	js     802fc6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f63:	8b 00                	mov    (%eax),%eax
  802f65:	89 04 24             	mov    %eax,(%esp)
  802f68:	e8 8f fd ff ff       	call   802cfc <dev_lookup>
  802f6d:	85 c0                	test   %eax,%eax
  802f6f:	78 55                	js     802fc6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	8b 50 08             	mov    0x8(%eax),%edx
  802f77:	83 e2 03             	and    $0x3,%edx
  802f7a:	83 fa 01             	cmp    $0x1,%edx
  802f7d:	75 23                	jne    802fa2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802f7f:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802f84:	8b 40 48             	mov    0x48(%eax),%eax
  802f87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f8f:	c7 04 24 78 4b 80 00 	movl   $0x804b78,(%esp)
  802f96:	e8 80 ed ff ff       	call   801d1b <cprintf>
		return -E_INVAL;
  802f9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fa0:	eb 24                	jmp    802fc6 <read+0x8c>
	}
	if (!dev->dev_read)
  802fa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa5:	8b 52 08             	mov    0x8(%edx),%edx
  802fa8:	85 d2                	test   %edx,%edx
  802faa:	74 15                	je     802fc1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802fac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802faf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802fb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802fba:	89 04 24             	mov    %eax,(%esp)
  802fbd:	ff d2                	call   *%edx
  802fbf:	eb 05                	jmp    802fc6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  802fc1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  802fc6:	83 c4 24             	add    $0x24,%esp
  802fc9:	5b                   	pop    %ebx
  802fca:	5d                   	pop    %ebp
  802fcb:	c3                   	ret    

00802fcc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802fcc:	55                   	push   %ebp
  802fcd:	89 e5                	mov    %esp,%ebp
  802fcf:	57                   	push   %edi
  802fd0:	56                   	push   %esi
  802fd1:	53                   	push   %ebx
  802fd2:	83 ec 1c             	sub    $0x1c,%esp
  802fd5:	8b 7d 08             	mov    0x8(%ebp),%edi
  802fd8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802fdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  802fe0:	eb 23                	jmp    803005 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802fe2:	89 f0                	mov    %esi,%eax
  802fe4:	29 d8                	sub    %ebx,%eax
  802fe6:	89 44 24 08          	mov    %eax,0x8(%esp)
  802fea:	89 d8                	mov    %ebx,%eax
  802fec:	03 45 0c             	add    0xc(%ebp),%eax
  802fef:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ff3:	89 3c 24             	mov    %edi,(%esp)
  802ff6:	e8 3f ff ff ff       	call   802f3a <read>
		if (m < 0)
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	78 10                	js     80300f <readn+0x43>
			return m;
		if (m == 0)
  802fff:	85 c0                	test   %eax,%eax
  803001:	74 0a                	je     80300d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803003:	01 c3                	add    %eax,%ebx
  803005:	39 f3                	cmp    %esi,%ebx
  803007:	72 d9                	jb     802fe2 <readn+0x16>
  803009:	89 d8                	mov    %ebx,%eax
  80300b:	eb 02                	jmp    80300f <readn+0x43>
  80300d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80300f:	83 c4 1c             	add    $0x1c,%esp
  803012:	5b                   	pop    %ebx
  803013:	5e                   	pop    %esi
  803014:	5f                   	pop    %edi
  803015:	5d                   	pop    %ebp
  803016:	c3                   	ret    

00803017 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803017:	55                   	push   %ebp
  803018:	89 e5                	mov    %esp,%ebp
  80301a:	53                   	push   %ebx
  80301b:	83 ec 24             	sub    $0x24,%esp
  80301e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803021:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803024:	89 44 24 04          	mov    %eax,0x4(%esp)
  803028:	89 1c 24             	mov    %ebx,(%esp)
  80302b:	e8 76 fc ff ff       	call   802ca6 <fd_lookup>
  803030:	89 c2                	mov    %eax,%edx
  803032:	85 d2                	test   %edx,%edx
  803034:	78 68                	js     80309e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803036:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80303d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	89 04 24             	mov    %eax,(%esp)
  803045:	e8 b2 fc ff ff       	call   802cfc <dev_lookup>
  80304a:	85 c0                	test   %eax,%eax
  80304c:	78 50                	js     80309e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  803055:	75 23                	jne    80307a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803057:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80305c:	8b 40 48             	mov    0x48(%eax),%eax
  80305f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803063:	89 44 24 04          	mov    %eax,0x4(%esp)
  803067:	c7 04 24 94 4b 80 00 	movl   $0x804b94,(%esp)
  80306e:	e8 a8 ec ff ff       	call   801d1b <cprintf>
		return -E_INVAL;
  803073:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803078:	eb 24                	jmp    80309e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80307a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80307d:	8b 52 0c             	mov    0xc(%edx),%edx
  803080:	85 d2                	test   %edx,%edx
  803082:	74 15                	je     803099 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  803084:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803087:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80308b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80308e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803092:	89 04 24             	mov    %eax,(%esp)
  803095:	ff d2                	call   *%edx
  803097:	eb 05                	jmp    80309e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  803099:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80309e:	83 c4 24             	add    $0x24,%esp
  8030a1:	5b                   	pop    %ebx
  8030a2:	5d                   	pop    %ebp
  8030a3:	c3                   	ret    

008030a4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8030a4:	55                   	push   %ebp
  8030a5:	89 e5                	mov    %esp,%ebp
  8030a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030aa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8030ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	89 04 24             	mov    %eax,(%esp)
  8030b7:	e8 ea fb ff ff       	call   802ca6 <fd_lookup>
  8030bc:	85 c0                	test   %eax,%eax
  8030be:	78 0e                	js     8030ce <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8030c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8030c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030ce:	c9                   	leave  
  8030cf:	c3                   	ret    

008030d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8030d0:	55                   	push   %ebp
  8030d1:	89 e5                	mov    %esp,%ebp
  8030d3:	53                   	push   %ebx
  8030d4:	83 ec 24             	sub    $0x24,%esp
  8030d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8030dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030e1:	89 1c 24             	mov    %ebx,(%esp)
  8030e4:	e8 bd fb ff ff       	call   802ca6 <fd_lookup>
  8030e9:	89 c2                	mov    %eax,%edx
  8030eb:	85 d2                	test   %edx,%edx
  8030ed:	78 61                	js     803150 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	89 04 24             	mov    %eax,(%esp)
  8030fe:	e8 f9 fb ff ff       	call   802cfc <dev_lookup>
  803103:	85 c0                	test   %eax,%eax
  803105:	78 49                	js     803150 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80310e:	75 23                	jne    803133 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803110:	a1 10 a0 80 00       	mov    0x80a010,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803115:	8b 40 48             	mov    0x48(%eax),%eax
  803118:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80311c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803120:	c7 04 24 54 4b 80 00 	movl   $0x804b54,(%esp)
  803127:	e8 ef eb ff ff       	call   801d1b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80312c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803131:	eb 1d                	jmp    803150 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  803133:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803136:	8b 52 18             	mov    0x18(%edx),%edx
  803139:	85 d2                	test   %edx,%edx
  80313b:	74 0e                	je     80314b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80313d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803140:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803144:	89 04 24             	mov    %eax,(%esp)
  803147:	ff d2                	call   *%edx
  803149:	eb 05                	jmp    803150 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80314b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  803150:	83 c4 24             	add    $0x24,%esp
  803153:	5b                   	pop    %ebx
  803154:	5d                   	pop    %ebp
  803155:	c3                   	ret    

00803156 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803156:	55                   	push   %ebp
  803157:	89 e5                	mov    %esp,%ebp
  803159:	53                   	push   %ebx
  80315a:	83 ec 24             	sub    $0x24,%esp
  80315d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803160:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803163:	89 44 24 04          	mov    %eax,0x4(%esp)
  803167:	8b 45 08             	mov    0x8(%ebp),%eax
  80316a:	89 04 24             	mov    %eax,(%esp)
  80316d:	e8 34 fb ff ff       	call   802ca6 <fd_lookup>
  803172:	89 c2                	mov    %eax,%edx
  803174:	85 d2                	test   %edx,%edx
  803176:	78 52                	js     8031ca <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803178:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80317b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80317f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803182:	8b 00                	mov    (%eax),%eax
  803184:	89 04 24             	mov    %eax,(%esp)
  803187:	e8 70 fb ff ff       	call   802cfc <dev_lookup>
  80318c:	85 c0                	test   %eax,%eax
  80318e:	78 3a                	js     8031ca <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  803197:	74 2c                	je     8031c5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  803199:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80319c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8031a3:	00 00 00 
	stat->st_isdir = 0;
  8031a6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8031ad:	00 00 00 
	stat->st_dev = dev;
  8031b0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8031b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8031ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031bd:	89 14 24             	mov    %edx,(%esp)
  8031c0:	ff 50 14             	call   *0x14(%eax)
  8031c3:	eb 05                	jmp    8031ca <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8031c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8031ca:	83 c4 24             	add    $0x24,%esp
  8031cd:	5b                   	pop    %ebx
  8031ce:	5d                   	pop    %ebp
  8031cf:	c3                   	ret    

008031d0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8031d0:	55                   	push   %ebp
  8031d1:	89 e5                	mov    %esp,%ebp
  8031d3:	56                   	push   %esi
  8031d4:	53                   	push   %ebx
  8031d5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8031d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8031df:	00 
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	89 04 24             	mov    %eax,(%esp)
  8031e6:	e8 28 02 00 00       	call   803413 <open>
  8031eb:	89 c3                	mov    %eax,%ebx
  8031ed:	85 db                	test   %ebx,%ebx
  8031ef:	78 1b                	js     80320c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8031f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031f8:	89 1c 24             	mov    %ebx,(%esp)
  8031fb:	e8 56 ff ff ff       	call   803156 <fstat>
  803200:	89 c6                	mov    %eax,%esi
	close(fd);
  803202:	89 1c 24             	mov    %ebx,(%esp)
  803205:	e8 cd fb ff ff       	call   802dd7 <close>
	return r;
  80320a:	89 f0                	mov    %esi,%eax
}
  80320c:	83 c4 10             	add    $0x10,%esp
  80320f:	5b                   	pop    %ebx
  803210:	5e                   	pop    %esi
  803211:	5d                   	pop    %ebp
  803212:	c3                   	ret    

00803213 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803213:	55                   	push   %ebp
  803214:	89 e5                	mov    %esp,%ebp
  803216:	56                   	push   %esi
  803217:	53                   	push   %ebx
  803218:	83 ec 10             	sub    $0x10,%esp
  80321b:	89 c6                	mov    %eax,%esi
  80321d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80321f:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  803226:	75 11                	jne    803239 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803228:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80322f:	e8 bc f9 ff ff       	call   802bf0 <ipc_find_env>
  803234:	a3 00 a0 80 00       	mov    %eax,0x80a000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803239:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803240:	00 
  803241:	c7 44 24 08 00 b0 80 	movl   $0x80b000,0x8(%esp)
  803248:	00 
  803249:	89 74 24 04          	mov    %esi,0x4(%esp)
  80324d:	a1 00 a0 80 00       	mov    0x80a000,%eax
  803252:	89 04 24             	mov    %eax,(%esp)
  803255:	e8 38 f9 ff ff       	call   802b92 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80325a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803261:	00 
  803262:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803266:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80326d:	e8 b6 f8 ff ff       	call   802b28 <ipc_recv>
}
  803272:	83 c4 10             	add    $0x10,%esp
  803275:	5b                   	pop    %ebx
  803276:	5e                   	pop    %esi
  803277:	5d                   	pop    %ebp
  803278:	c3                   	ret    

00803279 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803279:	55                   	push   %ebp
  80327a:	89 e5                	mov    %esp,%ebp
  80327c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	8b 40 0c             	mov    0xc(%eax),%eax
  803285:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  80328a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80328d:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  803292:	ba 00 00 00 00       	mov    $0x0,%edx
  803297:	b8 02 00 00 00       	mov    $0x2,%eax
  80329c:	e8 72 ff ff ff       	call   803213 <fsipc>
}
  8032a1:	c9                   	leave  
  8032a2:	c3                   	ret    

008032a3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8032a3:	55                   	push   %ebp
  8032a4:	89 e5                	mov    %esp,%ebp
  8032a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8032af:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  8032b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8032b9:	b8 06 00 00 00       	mov    $0x6,%eax
  8032be:	e8 50 ff ff ff       	call   803213 <fsipc>
}
  8032c3:	c9                   	leave  
  8032c4:	c3                   	ret    

008032c5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8032c5:	55                   	push   %ebp
  8032c6:	89 e5                	mov    %esp,%ebp
  8032c8:	53                   	push   %ebx
  8032c9:	83 ec 14             	sub    $0x14,%esp
  8032cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d5:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8032da:	ba 00 00 00 00       	mov    $0x0,%edx
  8032df:	b8 05 00 00 00       	mov    $0x5,%eax
  8032e4:	e8 2a ff ff ff       	call   803213 <fsipc>
  8032e9:	89 c2                	mov    %eax,%edx
  8032eb:	85 d2                	test   %edx,%edx
  8032ed:	78 2b                	js     80331a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8032ef:	c7 44 24 04 00 b0 80 	movl   $0x80b000,0x4(%esp)
  8032f6:	00 
  8032f7:	89 1c 24             	mov    %ebx,(%esp)
  8032fa:	e8 48 f0 ff ff       	call   802347 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8032ff:	a1 80 b0 80 00       	mov    0x80b080,%eax
  803304:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80330a:	a1 84 b0 80 00       	mov    0x80b084,%eax
  80330f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  803315:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80331a:	83 c4 14             	add    $0x14,%esp
  80331d:	5b                   	pop    %ebx
  80331e:	5d                   	pop    %ebp
  80331f:	c3                   	ret    

00803320 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803320:	55                   	push   %ebp
  803321:	89 e5                	mov    %esp,%ebp
  803323:	83 ec 18             	sub    $0x18,%esp
  803326:	8b 45 10             	mov    0x10(%ebp),%eax
  803329:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80332e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  803333:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  803336:	a3 04 b0 80 00       	mov    %eax,0x80b004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80333b:	8b 55 08             	mov    0x8(%ebp),%edx
  80333e:	8b 52 0c             	mov    0xc(%edx),%edx
  803341:	89 15 00 b0 80 00    	mov    %edx,0x80b000
    memmove(fsipcbuf.write.req_buf,buf,n);
  803347:	89 44 24 08          	mov    %eax,0x8(%esp)
  80334b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803352:	c7 04 24 08 b0 80 00 	movl   $0x80b008,(%esp)
  803359:	e8 86 f1 ff ff       	call   8024e4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  80335e:	ba 00 00 00 00       	mov    $0x0,%edx
  803363:	b8 04 00 00 00       	mov    $0x4,%eax
  803368:	e8 a6 fe ff ff       	call   803213 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  80336d:	c9                   	leave  
  80336e:	c3                   	ret    

0080336f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80336f:	55                   	push   %ebp
  803370:	89 e5                	mov    %esp,%ebp
  803372:	56                   	push   %esi
  803373:	53                   	push   %ebx
  803374:	83 ec 10             	sub    $0x10,%esp
  803377:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	8b 40 0c             	mov    0xc(%eax),%eax
  803380:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  803385:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80338b:	ba 00 00 00 00       	mov    $0x0,%edx
  803390:	b8 03 00 00 00       	mov    $0x3,%eax
  803395:	e8 79 fe ff ff       	call   803213 <fsipc>
  80339a:	89 c3                	mov    %eax,%ebx
  80339c:	85 c0                	test   %eax,%eax
  80339e:	78 6a                	js     80340a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8033a0:	39 c6                	cmp    %eax,%esi
  8033a2:	73 24                	jae    8033c8 <devfile_read+0x59>
  8033a4:	c7 44 24 0c c8 4b 80 	movl   $0x804bc8,0xc(%esp)
  8033ab:	00 
  8033ac:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  8033b3:	00 
  8033b4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8033bb:	00 
  8033bc:	c7 04 24 cf 4b 80 00 	movl   $0x804bcf,(%esp)
  8033c3:	e8 5a e8 ff ff       	call   801c22 <_panic>
	assert(r <= PGSIZE);
  8033c8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8033cd:	7e 24                	jle    8033f3 <devfile_read+0x84>
  8033cf:	c7 44 24 0c da 4b 80 	movl   $0x804bda,0xc(%esp)
  8033d6:	00 
  8033d7:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  8033de:	00 
  8033df:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8033e6:	00 
  8033e7:	c7 04 24 cf 4b 80 00 	movl   $0x804bcf,(%esp)
  8033ee:	e8 2f e8 ff ff       	call   801c22 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8033f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033f7:	c7 44 24 04 00 b0 80 	movl   $0x80b000,0x4(%esp)
  8033fe:	00 
  8033ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803402:	89 04 24             	mov    %eax,(%esp)
  803405:	e8 da f0 ff ff       	call   8024e4 <memmove>
	return r;
}
  80340a:	89 d8                	mov    %ebx,%eax
  80340c:	83 c4 10             	add    $0x10,%esp
  80340f:	5b                   	pop    %ebx
  803410:	5e                   	pop    %esi
  803411:	5d                   	pop    %ebp
  803412:	c3                   	ret    

00803413 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803413:	55                   	push   %ebp
  803414:	89 e5                	mov    %esp,%ebp
  803416:	53                   	push   %ebx
  803417:	83 ec 24             	sub    $0x24,%esp
  80341a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80341d:	89 1c 24             	mov    %ebx,(%esp)
  803420:	e8 eb ee ff ff       	call   802310 <strlen>
  803425:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80342a:	7f 60                	jg     80348c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80342c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80342f:	89 04 24             	mov    %eax,(%esp)
  803432:	e8 20 f8 ff ff       	call   802c57 <fd_alloc>
  803437:	89 c2                	mov    %eax,%edx
  803439:	85 d2                	test   %edx,%edx
  80343b:	78 54                	js     803491 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80343d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803441:	c7 04 24 00 b0 80 00 	movl   $0x80b000,(%esp)
  803448:	e8 fa ee ff ff       	call   802347 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80344d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803450:	a3 00 b4 80 00       	mov    %eax,0x80b400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803455:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803458:	b8 01 00 00 00       	mov    $0x1,%eax
  80345d:	e8 b1 fd ff ff       	call   803213 <fsipc>
  803462:	89 c3                	mov    %eax,%ebx
  803464:	85 c0                	test   %eax,%eax
  803466:	79 17                	jns    80347f <open+0x6c>
		fd_close(fd, 0);
  803468:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80346f:	00 
  803470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803473:	89 04 24             	mov    %eax,(%esp)
  803476:	e8 db f8 ff ff       	call   802d56 <fd_close>
		return r;
  80347b:	89 d8                	mov    %ebx,%eax
  80347d:	eb 12                	jmp    803491 <open+0x7e>
	}

	return fd2num(fd);
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	89 04 24             	mov    %eax,(%esp)
  803485:	e8 a6 f7 ff ff       	call   802c30 <fd2num>
  80348a:	eb 05                	jmp    803491 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80348c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  803491:	83 c4 24             	add    $0x24,%esp
  803494:	5b                   	pop    %ebx
  803495:	5d                   	pop    %ebp
  803496:	c3                   	ret    

00803497 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  803497:	55                   	push   %ebp
  803498:	89 e5                	mov    %esp,%ebp
  80349a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80349d:	ba 00 00 00 00       	mov    $0x0,%edx
  8034a2:	b8 08 00 00 00       	mov    $0x8,%eax
  8034a7:	e8 67 fd ff ff       	call   803213 <fsipc>
}
  8034ac:	c9                   	leave  
  8034ad:	c3                   	ret    

008034ae <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8034ae:	55                   	push   %ebp
  8034af:	89 e5                	mov    %esp,%ebp
  8034b1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8034b4:	89 d0                	mov    %edx,%eax
  8034b6:	c1 e8 16             	shr    $0x16,%eax
  8034b9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8034c0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8034c5:	f6 c1 01             	test   $0x1,%cl
  8034c8:	74 1d                	je     8034e7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8034ca:	c1 ea 0c             	shr    $0xc,%edx
  8034cd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8034d4:	f6 c2 01             	test   $0x1,%dl
  8034d7:	74 0e                	je     8034e7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8034d9:	c1 ea 0c             	shr    $0xc,%edx
  8034dc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8034e3:	ef 
  8034e4:	0f b7 c0             	movzwl %ax,%eax
}
  8034e7:	5d                   	pop    %ebp
  8034e8:	c3                   	ret    
  8034e9:	66 90                	xchg   %ax,%ax
  8034eb:	66 90                	xchg   %ax,%ax
  8034ed:	66 90                	xchg   %ax,%ax
  8034ef:	90                   	nop

008034f0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8034f0:	55                   	push   %ebp
  8034f1:	89 e5                	mov    %esp,%ebp
  8034f3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8034f6:	c7 44 24 04 e6 4b 80 	movl   $0x804be6,0x4(%esp)
  8034fd:	00 
  8034fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803501:	89 04 24             	mov    %eax,(%esp)
  803504:	e8 3e ee ff ff       	call   802347 <strcpy>
	return 0;
}
  803509:	b8 00 00 00 00       	mov    $0x0,%eax
  80350e:	c9                   	leave  
  80350f:	c3                   	ret    

00803510 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803510:	55                   	push   %ebp
  803511:	89 e5                	mov    %esp,%ebp
  803513:	53                   	push   %ebx
  803514:	83 ec 14             	sub    $0x14,%esp
  803517:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80351a:	89 1c 24             	mov    %ebx,(%esp)
  80351d:	e8 8c ff ff ff       	call   8034ae <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803522:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803527:	83 f8 01             	cmp    $0x1,%eax
  80352a:	75 0d                	jne    803539 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80352c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80352f:	89 04 24             	mov    %eax,(%esp)
  803532:	e8 29 03 00 00       	call   803860 <nsipc_close>
  803537:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  803539:	89 d0                	mov    %edx,%eax
  80353b:	83 c4 14             	add    $0x14,%esp
  80353e:	5b                   	pop    %ebx
  80353f:	5d                   	pop    %ebp
  803540:	c3                   	ret    

00803541 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803541:	55                   	push   %ebp
  803542:	89 e5                	mov    %esp,%ebp
  803544:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803547:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80354e:	00 
  80354f:	8b 45 10             	mov    0x10(%ebp),%eax
  803552:	89 44 24 08          	mov    %eax,0x8(%esp)
  803556:	8b 45 0c             	mov    0xc(%ebp),%eax
  803559:	89 44 24 04          	mov    %eax,0x4(%esp)
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	8b 40 0c             	mov    0xc(%eax),%eax
  803563:	89 04 24             	mov    %eax,(%esp)
  803566:	e8 f0 03 00 00       	call   80395b <nsipc_send>
}
  80356b:	c9                   	leave  
  80356c:	c3                   	ret    

0080356d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80356d:	55                   	push   %ebp
  80356e:	89 e5                	mov    %esp,%ebp
  803570:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803573:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80357a:	00 
  80357b:	8b 45 10             	mov    0x10(%ebp),%eax
  80357e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803582:	8b 45 0c             	mov    0xc(%ebp),%eax
  803585:	89 44 24 04          	mov    %eax,0x4(%esp)
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	8b 40 0c             	mov    0xc(%eax),%eax
  80358f:	89 04 24             	mov    %eax,(%esp)
  803592:	e8 44 03 00 00       	call   8038db <nsipc_recv>
}
  803597:	c9                   	leave  
  803598:	c3                   	ret    

00803599 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803599:	55                   	push   %ebp
  80359a:	89 e5                	mov    %esp,%ebp
  80359c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80359f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8035a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8035a6:	89 04 24             	mov    %eax,(%esp)
  8035a9:	e8 f8 f6 ff ff       	call   802ca6 <fd_lookup>
  8035ae:	85 c0                	test   %eax,%eax
  8035b0:	78 17                	js     8035c9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8035b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b5:	8b 0d 80 90 80 00    	mov    0x809080,%ecx
  8035bb:	39 08                	cmp    %ecx,(%eax)
  8035bd:	75 05                	jne    8035c4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8035bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c2:	eb 05                	jmp    8035c9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8035c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8035c9:	c9                   	leave  
  8035ca:	c3                   	ret    

008035cb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8035cb:	55                   	push   %ebp
  8035cc:	89 e5                	mov    %esp,%ebp
  8035ce:	56                   	push   %esi
  8035cf:	53                   	push   %ebx
  8035d0:	83 ec 20             	sub    $0x20,%esp
  8035d3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8035d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8035d8:	89 04 24             	mov    %eax,(%esp)
  8035db:	e8 77 f6 ff ff       	call   802c57 <fd_alloc>
  8035e0:	89 c3                	mov    %eax,%ebx
  8035e2:	85 c0                	test   %eax,%eax
  8035e4:	78 21                	js     803607 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8035e6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8035ed:	00 
  8035ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035fc:	e8 62 f1 ff ff       	call   802763 <sys_page_alloc>
  803601:	89 c3                	mov    %eax,%ebx
  803603:	85 c0                	test   %eax,%eax
  803605:	79 0c                	jns    803613 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  803607:	89 34 24             	mov    %esi,(%esp)
  80360a:	e8 51 02 00 00       	call   803860 <nsipc_close>
		return r;
  80360f:	89 d8                	mov    %ebx,%eax
  803611:	eb 20                	jmp    803633 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803613:	8b 15 80 90 80 00    	mov    0x809080,%edx
  803619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80361e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803621:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  803628:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80362b:	89 14 24             	mov    %edx,(%esp)
  80362e:	e8 fd f5 ff ff       	call   802c30 <fd2num>
}
  803633:	83 c4 20             	add    $0x20,%esp
  803636:	5b                   	pop    %ebx
  803637:	5e                   	pop    %esi
  803638:	5d                   	pop    %ebp
  803639:	c3                   	ret    

0080363a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80363a:	55                   	push   %ebp
  80363b:	89 e5                	mov    %esp,%ebp
  80363d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
  803643:	e8 51 ff ff ff       	call   803599 <fd2sockid>
		return r;
  803648:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80364a:	85 c0                	test   %eax,%eax
  80364c:	78 23                	js     803671 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80364e:	8b 55 10             	mov    0x10(%ebp),%edx
  803651:	89 54 24 08          	mov    %edx,0x8(%esp)
  803655:	8b 55 0c             	mov    0xc(%ebp),%edx
  803658:	89 54 24 04          	mov    %edx,0x4(%esp)
  80365c:	89 04 24             	mov    %eax,(%esp)
  80365f:	e8 45 01 00 00       	call   8037a9 <nsipc_accept>
		return r;
  803664:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803666:	85 c0                	test   %eax,%eax
  803668:	78 07                	js     803671 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80366a:	e8 5c ff ff ff       	call   8035cb <alloc_sockfd>
  80366f:	89 c1                	mov    %eax,%ecx
}
  803671:	89 c8                	mov    %ecx,%eax
  803673:	c9                   	leave  
  803674:	c3                   	ret    

00803675 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803675:	55                   	push   %ebp
  803676:	89 e5                	mov    %esp,%ebp
  803678:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80367b:	8b 45 08             	mov    0x8(%ebp),%eax
  80367e:	e8 16 ff ff ff       	call   803599 <fd2sockid>
  803683:	89 c2                	mov    %eax,%edx
  803685:	85 d2                	test   %edx,%edx
  803687:	78 16                	js     80369f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  803689:	8b 45 10             	mov    0x10(%ebp),%eax
  80368c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803690:	8b 45 0c             	mov    0xc(%ebp),%eax
  803693:	89 44 24 04          	mov    %eax,0x4(%esp)
  803697:	89 14 24             	mov    %edx,(%esp)
  80369a:	e8 60 01 00 00       	call   8037ff <nsipc_bind>
}
  80369f:	c9                   	leave  
  8036a0:	c3                   	ret    

008036a1 <shutdown>:

int
shutdown(int s, int how)
{
  8036a1:	55                   	push   %ebp
  8036a2:	89 e5                	mov    %esp,%ebp
  8036a4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	e8 ea fe ff ff       	call   803599 <fd2sockid>
  8036af:	89 c2                	mov    %eax,%edx
  8036b1:	85 d2                	test   %edx,%edx
  8036b3:	78 0f                	js     8036c4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8036b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036bc:	89 14 24             	mov    %edx,(%esp)
  8036bf:	e8 7a 01 00 00       	call   80383e <nsipc_shutdown>
}
  8036c4:	c9                   	leave  
  8036c5:	c3                   	ret    

008036c6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036c6:	55                   	push   %ebp
  8036c7:	89 e5                	mov    %esp,%ebp
  8036c9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cf:	e8 c5 fe ff ff       	call   803599 <fd2sockid>
  8036d4:	89 c2                	mov    %eax,%edx
  8036d6:	85 d2                	test   %edx,%edx
  8036d8:	78 16                	js     8036f0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8036da:	8b 45 10             	mov    0x10(%ebp),%eax
  8036dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8036e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036e8:	89 14 24             	mov    %edx,(%esp)
  8036eb:	e8 8a 01 00 00       	call   80387a <nsipc_connect>
}
  8036f0:	c9                   	leave  
  8036f1:	c3                   	ret    

008036f2 <listen>:

int
listen(int s, int backlog)
{
  8036f2:	55                   	push   %ebp
  8036f3:	89 e5                	mov    %esp,%ebp
  8036f5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fb:	e8 99 fe ff ff       	call   803599 <fd2sockid>
  803700:	89 c2                	mov    %eax,%edx
  803702:	85 d2                	test   %edx,%edx
  803704:	78 0f                	js     803715 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  803706:	8b 45 0c             	mov    0xc(%ebp),%eax
  803709:	89 44 24 04          	mov    %eax,0x4(%esp)
  80370d:	89 14 24             	mov    %edx,(%esp)
  803710:	e8 a4 01 00 00       	call   8038b9 <nsipc_listen>
}
  803715:	c9                   	leave  
  803716:	c3                   	ret    

00803717 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803717:	55                   	push   %ebp
  803718:	89 e5                	mov    %esp,%ebp
  80371a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80371d:	8b 45 10             	mov    0x10(%ebp),%eax
  803720:	89 44 24 08          	mov    %eax,0x8(%esp)
  803724:	8b 45 0c             	mov    0xc(%ebp),%eax
  803727:	89 44 24 04          	mov    %eax,0x4(%esp)
  80372b:	8b 45 08             	mov    0x8(%ebp),%eax
  80372e:	89 04 24             	mov    %eax,(%esp)
  803731:	e8 98 02 00 00       	call   8039ce <nsipc_socket>
  803736:	89 c2                	mov    %eax,%edx
  803738:	85 d2                	test   %edx,%edx
  80373a:	78 05                	js     803741 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80373c:	e8 8a fe ff ff       	call   8035cb <alloc_sockfd>
}
  803741:	c9                   	leave  
  803742:	c3                   	ret    

00803743 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803743:	55                   	push   %ebp
  803744:	89 e5                	mov    %esp,%ebp
  803746:	53                   	push   %ebx
  803747:	83 ec 14             	sub    $0x14,%esp
  80374a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80374c:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  803753:	75 11                	jne    803766 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803755:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80375c:	e8 8f f4 ff ff       	call   802bf0 <ipc_find_env>
  803761:	a3 04 a0 80 00       	mov    %eax,0x80a004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803766:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80376d:	00 
  80376e:	c7 44 24 08 00 c0 80 	movl   $0x80c000,0x8(%esp)
  803775:	00 
  803776:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80377a:	a1 04 a0 80 00       	mov    0x80a004,%eax
  80377f:	89 04 24             	mov    %eax,(%esp)
  803782:	e8 0b f4 ff ff       	call   802b92 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803787:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80378e:	00 
  80378f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803796:	00 
  803797:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80379e:	e8 85 f3 ff ff       	call   802b28 <ipc_recv>
}
  8037a3:	83 c4 14             	add    $0x14,%esp
  8037a6:	5b                   	pop    %ebx
  8037a7:	5d                   	pop    %ebp
  8037a8:	c3                   	ret    

008037a9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8037a9:	55                   	push   %ebp
  8037aa:	89 e5                	mov    %esp,%ebp
  8037ac:	56                   	push   %esi
  8037ad:	53                   	push   %ebx
  8037ae:	83 ec 10             	sub    $0x10,%esp
  8037b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8037bc:	8b 06                	mov    (%esi),%eax
  8037be:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8037c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8037c8:	e8 76 ff ff ff       	call   803743 <nsipc>
  8037cd:	89 c3                	mov    %eax,%ebx
  8037cf:	85 c0                	test   %eax,%eax
  8037d1:	78 23                	js     8037f6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8037d3:	a1 10 c0 80 00       	mov    0x80c010,%eax
  8037d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037dc:	c7 44 24 04 00 c0 80 	movl   $0x80c000,0x4(%esp)
  8037e3:	00 
  8037e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e7:	89 04 24             	mov    %eax,(%esp)
  8037ea:	e8 f5 ec ff ff       	call   8024e4 <memmove>
		*addrlen = ret->ret_addrlen;
  8037ef:	a1 10 c0 80 00       	mov    0x80c010,%eax
  8037f4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8037f6:	89 d8                	mov    %ebx,%eax
  8037f8:	83 c4 10             	add    $0x10,%esp
  8037fb:	5b                   	pop    %ebx
  8037fc:	5e                   	pop    %esi
  8037fd:	5d                   	pop    %ebp
  8037fe:	c3                   	ret    

008037ff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037ff:	55                   	push   %ebp
  803800:	89 e5                	mov    %esp,%ebp
  803802:	53                   	push   %ebx
  803803:	83 ec 14             	sub    $0x14,%esp
  803806:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803809:	8b 45 08             	mov    0x8(%ebp),%eax
  80380c:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803811:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803815:	8b 45 0c             	mov    0xc(%ebp),%eax
  803818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80381c:	c7 04 24 04 c0 80 00 	movl   $0x80c004,(%esp)
  803823:	e8 bc ec ff ff       	call   8024e4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803828:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  80382e:	b8 02 00 00 00       	mov    $0x2,%eax
  803833:	e8 0b ff ff ff       	call   803743 <nsipc>
}
  803838:	83 c4 14             	add    $0x14,%esp
  80383b:	5b                   	pop    %ebx
  80383c:	5d                   	pop    %ebp
  80383d:	c3                   	ret    

0080383e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80383e:	55                   	push   %ebp
  80383f:	89 e5                	mov    %esp,%ebp
  803841:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803844:	8b 45 08             	mov    0x8(%ebp),%eax
  803847:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  80384c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80384f:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  803854:	b8 03 00 00 00       	mov    $0x3,%eax
  803859:	e8 e5 fe ff ff       	call   803743 <nsipc>
}
  80385e:	c9                   	leave  
  80385f:	c3                   	ret    

00803860 <nsipc_close>:

int
nsipc_close(int s)
{
  803860:	55                   	push   %ebp
  803861:	89 e5                	mov    %esp,%ebp
  803863:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803866:	8b 45 08             	mov    0x8(%ebp),%eax
  803869:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  80386e:	b8 04 00 00 00       	mov    $0x4,%eax
  803873:	e8 cb fe ff ff       	call   803743 <nsipc>
}
  803878:	c9                   	leave  
  803879:	c3                   	ret    

0080387a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80387a:	55                   	push   %ebp
  80387b:	89 e5                	mov    %esp,%ebp
  80387d:	53                   	push   %ebx
  80387e:	83 ec 14             	sub    $0x14,%esp
  803881:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803884:	8b 45 08             	mov    0x8(%ebp),%eax
  803887:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80388c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803890:	8b 45 0c             	mov    0xc(%ebp),%eax
  803893:	89 44 24 04          	mov    %eax,0x4(%esp)
  803897:	c7 04 24 04 c0 80 00 	movl   $0x80c004,(%esp)
  80389e:	e8 41 ec ff ff       	call   8024e4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8038a3:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  8038a9:	b8 05 00 00 00       	mov    $0x5,%eax
  8038ae:	e8 90 fe ff ff       	call   803743 <nsipc>
}
  8038b3:	83 c4 14             	add    $0x14,%esp
  8038b6:	5b                   	pop    %ebx
  8038b7:	5d                   	pop    %ebp
  8038b8:	c3                   	ret    

008038b9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8038b9:	55                   	push   %ebp
  8038ba:	89 e5                	mov    %esp,%ebp
  8038bc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  8038c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038ca:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  8038cf:	b8 06 00 00 00       	mov    $0x6,%eax
  8038d4:	e8 6a fe ff ff       	call   803743 <nsipc>
}
  8038d9:	c9                   	leave  
  8038da:	c3                   	ret    

008038db <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8038db:	55                   	push   %ebp
  8038dc:	89 e5                	mov    %esp,%ebp
  8038de:	56                   	push   %esi
  8038df:	53                   	push   %ebx
  8038e0:	83 ec 10             	sub    $0x10,%esp
  8038e3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8038e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e9:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  8038ee:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  8038f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8038f7:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8038fc:	b8 07 00 00 00       	mov    $0x7,%eax
  803901:	e8 3d fe ff ff       	call   803743 <nsipc>
  803906:	89 c3                	mov    %eax,%ebx
  803908:	85 c0                	test   %eax,%eax
  80390a:	78 46                	js     803952 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80390c:	39 f0                	cmp    %esi,%eax
  80390e:	7f 07                	jg     803917 <nsipc_recv+0x3c>
  803910:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803915:	7e 24                	jle    80393b <nsipc_recv+0x60>
  803917:	c7 44 24 0c f2 4b 80 	movl   $0x804bf2,0xc(%esp)
  80391e:	00 
  80391f:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  803926:	00 
  803927:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80392e:	00 
  80392f:	c7 04 24 07 4c 80 00 	movl   $0x804c07,(%esp)
  803936:	e8 e7 e2 ff ff       	call   801c22 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80393b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80393f:	c7 44 24 04 00 c0 80 	movl   $0x80c000,0x4(%esp)
  803946:	00 
  803947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80394a:	89 04 24             	mov    %eax,(%esp)
  80394d:	e8 92 eb ff ff       	call   8024e4 <memmove>
	}

	return r;
}
  803952:	89 d8                	mov    %ebx,%eax
  803954:	83 c4 10             	add    $0x10,%esp
  803957:	5b                   	pop    %ebx
  803958:	5e                   	pop    %esi
  803959:	5d                   	pop    %ebp
  80395a:	c3                   	ret    

0080395b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80395b:	55                   	push   %ebp
  80395c:	89 e5                	mov    %esp,%ebp
  80395e:	53                   	push   %ebx
  80395f:	83 ec 14             	sub    $0x14,%esp
  803962:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803965:	8b 45 08             	mov    0x8(%ebp),%eax
  803968:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  80396d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803973:	7e 24                	jle    803999 <nsipc_send+0x3e>
  803975:	c7 44 24 0c 13 4c 80 	movl   $0x804c13,0xc(%esp)
  80397c:	00 
  80397d:	c7 44 24 08 fd 41 80 	movl   $0x8041fd,0x8(%esp)
  803984:	00 
  803985:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80398c:	00 
  80398d:	c7 04 24 07 4c 80 00 	movl   $0x804c07,(%esp)
  803994:	e8 89 e2 ff ff       	call   801c22 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803999:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80399d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039a4:	c7 04 24 0c c0 80 00 	movl   $0x80c00c,(%esp)
  8039ab:	e8 34 eb ff ff       	call   8024e4 <memmove>
	nsipcbuf.send.req_size = size;
  8039b0:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  8039b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8039b9:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  8039be:	b8 08 00 00 00       	mov    $0x8,%eax
  8039c3:	e8 7b fd ff ff       	call   803743 <nsipc>
}
  8039c8:	83 c4 14             	add    $0x14,%esp
  8039cb:	5b                   	pop    %ebx
  8039cc:	5d                   	pop    %ebp
  8039cd:	c3                   	ret    

008039ce <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039ce:	55                   	push   %ebp
  8039cf:	89 e5                	mov    %esp,%ebp
  8039d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8039d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d7:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  8039dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039df:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  8039e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8039e7:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  8039ec:	b8 09 00 00 00       	mov    $0x9,%eax
  8039f1:	e8 4d fd ff ff       	call   803743 <nsipc>
}
  8039f6:	c9                   	leave  
  8039f7:	c3                   	ret    

008039f8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039f8:	55                   	push   %ebp
  8039f9:	89 e5                	mov    %esp,%ebp
  8039fb:	56                   	push   %esi
  8039fc:	53                   	push   %ebx
  8039fd:	83 ec 10             	sub    $0x10,%esp
  803a00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a03:	8b 45 08             	mov    0x8(%ebp),%eax
  803a06:	89 04 24             	mov    %eax,(%esp)
  803a09:	e8 32 f2 ff ff       	call   802c40 <fd2data>
  803a0e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803a10:	c7 44 24 04 1f 4c 80 	movl   $0x804c1f,0x4(%esp)
  803a17:	00 
  803a18:	89 1c 24             	mov    %ebx,(%esp)
  803a1b:	e8 27 e9 ff ff       	call   802347 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803a20:	8b 46 04             	mov    0x4(%esi),%eax
  803a23:	2b 06                	sub    (%esi),%eax
  803a25:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803a2b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803a32:	00 00 00 
	stat->st_dev = &devpipe;
  803a35:	c7 83 88 00 00 00 9c 	movl   $0x80909c,0x88(%ebx)
  803a3c:	90 80 00 
	return 0;
}
  803a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a44:	83 c4 10             	add    $0x10,%esp
  803a47:	5b                   	pop    %ebx
  803a48:	5e                   	pop    %esi
  803a49:	5d                   	pop    %ebp
  803a4a:	c3                   	ret    

00803a4b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a4b:	55                   	push   %ebp
  803a4c:	89 e5                	mov    %esp,%ebp
  803a4e:	53                   	push   %ebx
  803a4f:	83 ec 14             	sub    $0x14,%esp
  803a52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803a55:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803a59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a60:	e8 a5 ed ff ff       	call   80280a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803a65:	89 1c 24             	mov    %ebx,(%esp)
  803a68:	e8 d3 f1 ff ff       	call   802c40 <fd2data>
  803a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a78:	e8 8d ed ff ff       	call   80280a <sys_page_unmap>
}
  803a7d:	83 c4 14             	add    $0x14,%esp
  803a80:	5b                   	pop    %ebx
  803a81:	5d                   	pop    %ebp
  803a82:	c3                   	ret    

00803a83 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a83:	55                   	push   %ebp
  803a84:	89 e5                	mov    %esp,%ebp
  803a86:	57                   	push   %edi
  803a87:	56                   	push   %esi
  803a88:	53                   	push   %ebx
  803a89:	83 ec 2c             	sub    $0x2c,%esp
  803a8c:	89 c6                	mov    %eax,%esi
  803a8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a91:	a1 10 a0 80 00       	mov    0x80a010,%eax
  803a96:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803a99:	89 34 24             	mov    %esi,(%esp)
  803a9c:	e8 0d fa ff ff       	call   8034ae <pageref>
  803aa1:	89 c7                	mov    %eax,%edi
  803aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa6:	89 04 24             	mov    %eax,(%esp)
  803aa9:	e8 00 fa ff ff       	call   8034ae <pageref>
  803aae:	39 c7                	cmp    %eax,%edi
  803ab0:	0f 94 c2             	sete   %dl
  803ab3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  803ab6:	8b 0d 10 a0 80 00    	mov    0x80a010,%ecx
  803abc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  803abf:	39 fb                	cmp    %edi,%ebx
  803ac1:	74 21                	je     803ae4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  803ac3:	84 d2                	test   %dl,%dl
  803ac5:	74 ca                	je     803a91 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ac7:	8b 51 58             	mov    0x58(%ecx),%edx
  803aca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ace:	89 54 24 08          	mov    %edx,0x8(%esp)
  803ad2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803ad6:	c7 04 24 26 4c 80 00 	movl   $0x804c26,(%esp)
  803add:	e8 39 e2 ff ff       	call   801d1b <cprintf>
  803ae2:	eb ad                	jmp    803a91 <_pipeisclosed+0xe>
	}
}
  803ae4:	83 c4 2c             	add    $0x2c,%esp
  803ae7:	5b                   	pop    %ebx
  803ae8:	5e                   	pop    %esi
  803ae9:	5f                   	pop    %edi
  803aea:	5d                   	pop    %ebp
  803aeb:	c3                   	ret    

00803aec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803aec:	55                   	push   %ebp
  803aed:	89 e5                	mov    %esp,%ebp
  803aef:	57                   	push   %edi
  803af0:	56                   	push   %esi
  803af1:	53                   	push   %ebx
  803af2:	83 ec 1c             	sub    $0x1c,%esp
  803af5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803af8:	89 34 24             	mov    %esi,(%esp)
  803afb:	e8 40 f1 ff ff       	call   802c40 <fd2data>
  803b00:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b02:	bf 00 00 00 00       	mov    $0x0,%edi
  803b07:	eb 45                	jmp    803b4e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803b09:	89 da                	mov    %ebx,%edx
  803b0b:	89 f0                	mov    %esi,%eax
  803b0d:	e8 71 ff ff ff       	call   803a83 <_pipeisclosed>
  803b12:	85 c0                	test   %eax,%eax
  803b14:	75 41                	jne    803b57 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b16:	e8 29 ec ff ff       	call   802744 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b1b:	8b 43 04             	mov    0x4(%ebx),%eax
  803b1e:	8b 0b                	mov    (%ebx),%ecx
  803b20:	8d 51 20             	lea    0x20(%ecx),%edx
  803b23:	39 d0                	cmp    %edx,%eax
  803b25:	73 e2                	jae    803b09 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803b2a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803b2e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803b31:	99                   	cltd   
  803b32:	c1 ea 1b             	shr    $0x1b,%edx
  803b35:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  803b38:	83 e1 1f             	and    $0x1f,%ecx
  803b3b:	29 d1                	sub    %edx,%ecx
  803b3d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  803b41:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  803b45:	83 c0 01             	add    $0x1,%eax
  803b48:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b4b:	83 c7 01             	add    $0x1,%edi
  803b4e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803b51:	75 c8                	jne    803b1b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b53:	89 f8                	mov    %edi,%eax
  803b55:	eb 05                	jmp    803b5c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803b57:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  803b5c:	83 c4 1c             	add    $0x1c,%esp
  803b5f:	5b                   	pop    %ebx
  803b60:	5e                   	pop    %esi
  803b61:	5f                   	pop    %edi
  803b62:	5d                   	pop    %ebp
  803b63:	c3                   	ret    

00803b64 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b64:	55                   	push   %ebp
  803b65:	89 e5                	mov    %esp,%ebp
  803b67:	57                   	push   %edi
  803b68:	56                   	push   %esi
  803b69:	53                   	push   %ebx
  803b6a:	83 ec 1c             	sub    $0x1c,%esp
  803b6d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803b70:	89 3c 24             	mov    %edi,(%esp)
  803b73:	e8 c8 f0 ff ff       	call   802c40 <fd2data>
  803b78:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b7a:	be 00 00 00 00       	mov    $0x0,%esi
  803b7f:	eb 3d                	jmp    803bbe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803b81:	85 f6                	test   %esi,%esi
  803b83:	74 04                	je     803b89 <devpipe_read+0x25>
				return i;
  803b85:	89 f0                	mov    %esi,%eax
  803b87:	eb 43                	jmp    803bcc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803b89:	89 da                	mov    %ebx,%edx
  803b8b:	89 f8                	mov    %edi,%eax
  803b8d:	e8 f1 fe ff ff       	call   803a83 <_pipeisclosed>
  803b92:	85 c0                	test   %eax,%eax
  803b94:	75 31                	jne    803bc7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b96:	e8 a9 eb ff ff       	call   802744 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803b9b:	8b 03                	mov    (%ebx),%eax
  803b9d:	3b 43 04             	cmp    0x4(%ebx),%eax
  803ba0:	74 df                	je     803b81 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803ba2:	99                   	cltd   
  803ba3:	c1 ea 1b             	shr    $0x1b,%edx
  803ba6:	01 d0                	add    %edx,%eax
  803ba8:	83 e0 1f             	and    $0x1f,%eax
  803bab:	29 d0                	sub    %edx,%eax
  803bad:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803bb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803bb5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803bb8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803bbb:	83 c6 01             	add    $0x1,%esi
  803bbe:	3b 75 10             	cmp    0x10(%ebp),%esi
  803bc1:	75 d8                	jne    803b9b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803bc3:	89 f0                	mov    %esi,%eax
  803bc5:	eb 05                	jmp    803bcc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803bc7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  803bcc:	83 c4 1c             	add    $0x1c,%esp
  803bcf:	5b                   	pop    %ebx
  803bd0:	5e                   	pop    %esi
  803bd1:	5f                   	pop    %edi
  803bd2:	5d                   	pop    %ebp
  803bd3:	c3                   	ret    

00803bd4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803bd4:	55                   	push   %ebp
  803bd5:	89 e5                	mov    %esp,%ebp
  803bd7:	56                   	push   %esi
  803bd8:	53                   	push   %ebx
  803bd9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803bdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803bdf:	89 04 24             	mov    %eax,(%esp)
  803be2:	e8 70 f0 ff ff       	call   802c57 <fd_alloc>
  803be7:	89 c2                	mov    %eax,%edx
  803be9:	85 d2                	test   %edx,%edx
  803beb:	0f 88 4d 01 00 00    	js     803d3e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bf1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803bf8:	00 
  803bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c07:	e8 57 eb ff ff       	call   802763 <sys_page_alloc>
  803c0c:	89 c2                	mov    %eax,%edx
  803c0e:	85 d2                	test   %edx,%edx
  803c10:	0f 88 28 01 00 00    	js     803d3e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803c16:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803c19:	89 04 24             	mov    %eax,(%esp)
  803c1c:	e8 36 f0 ff ff       	call   802c57 <fd_alloc>
  803c21:	89 c3                	mov    %eax,%ebx
  803c23:	85 c0                	test   %eax,%eax
  803c25:	0f 88 fe 00 00 00    	js     803d29 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c2b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803c32:	00 
  803c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c36:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c41:	e8 1d eb ff ff       	call   802763 <sys_page_alloc>
  803c46:	89 c3                	mov    %eax,%ebx
  803c48:	85 c0                	test   %eax,%eax
  803c4a:	0f 88 d9 00 00 00    	js     803d29 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c53:	89 04 24             	mov    %eax,(%esp)
  803c56:	e8 e5 ef ff ff       	call   802c40 <fd2data>
  803c5b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c5d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803c64:	00 
  803c65:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c70:	e8 ee ea ff ff       	call   802763 <sys_page_alloc>
  803c75:	89 c3                	mov    %eax,%ebx
  803c77:	85 c0                	test   %eax,%eax
  803c79:	0f 88 97 00 00 00    	js     803d16 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c82:	89 04 24             	mov    %eax,(%esp)
  803c85:	e8 b6 ef ff ff       	call   802c40 <fd2data>
  803c8a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803c91:	00 
  803c92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c96:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803c9d:	00 
  803c9e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803ca2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ca9:	e8 09 eb ff ff       	call   8027b7 <sys_page_map>
  803cae:	89 c3                	mov    %eax,%ebx
  803cb0:	85 c0                	test   %eax,%eax
  803cb2:	78 52                	js     803d06 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803cb4:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803cc9:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce1:	89 04 24             	mov    %eax,(%esp)
  803ce4:	e8 47 ef ff ff       	call   802c30 <fd2num>
  803ce9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803cec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cf1:	89 04 24             	mov    %eax,(%esp)
  803cf4:	e8 37 ef ff ff       	call   802c30 <fd2num>
  803cf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803cfc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803cff:	b8 00 00 00 00       	mov    $0x0,%eax
  803d04:	eb 38                	jmp    803d3e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  803d06:	89 74 24 04          	mov    %esi,0x4(%esp)
  803d0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d11:	e8 f4 ea ff ff       	call   80280a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d24:	e8 e1 ea ff ff       	call   80280a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  803d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d37:	e8 ce ea ff ff       	call   80280a <sys_page_unmap>
  803d3c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  803d3e:	83 c4 30             	add    $0x30,%esp
  803d41:	5b                   	pop    %ebx
  803d42:	5e                   	pop    %esi
  803d43:	5d                   	pop    %ebp
  803d44:	c3                   	ret    

00803d45 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803d45:	55                   	push   %ebp
  803d46:	89 e5                	mov    %esp,%ebp
  803d48:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d52:	8b 45 08             	mov    0x8(%ebp),%eax
  803d55:	89 04 24             	mov    %eax,(%esp)
  803d58:	e8 49 ef ff ff       	call   802ca6 <fd_lookup>
  803d5d:	89 c2                	mov    %eax,%edx
  803d5f:	85 d2                	test   %edx,%edx
  803d61:	78 15                	js     803d78 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d66:	89 04 24             	mov    %eax,(%esp)
  803d69:	e8 d2 ee ff ff       	call   802c40 <fd2data>
	return _pipeisclosed(fd, p);
  803d6e:	89 c2                	mov    %eax,%edx
  803d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d73:	e8 0b fd ff ff       	call   803a83 <_pipeisclosed>
}
  803d78:	c9                   	leave  
  803d79:	c3                   	ret    
  803d7a:	66 90                	xchg   %ax,%ax
  803d7c:	66 90                	xchg   %ax,%ax
  803d7e:	66 90                	xchg   %ax,%ax

00803d80 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803d80:	55                   	push   %ebp
  803d81:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803d83:	b8 00 00 00 00       	mov    $0x0,%eax
  803d88:	5d                   	pop    %ebp
  803d89:	c3                   	ret    

00803d8a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d8a:	55                   	push   %ebp
  803d8b:	89 e5                	mov    %esp,%ebp
  803d8d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803d90:	c7 44 24 04 3e 4c 80 	movl   $0x804c3e,0x4(%esp)
  803d97:	00 
  803d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d9b:	89 04 24             	mov    %eax,(%esp)
  803d9e:	e8 a4 e5 ff ff       	call   802347 <strcpy>
	return 0;
}
  803da3:	b8 00 00 00 00       	mov    $0x0,%eax
  803da8:	c9                   	leave  
  803da9:	c3                   	ret    

00803daa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803daa:	55                   	push   %ebp
  803dab:	89 e5                	mov    %esp,%ebp
  803dad:	57                   	push   %edi
  803dae:	56                   	push   %esi
  803daf:	53                   	push   %ebx
  803db0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803db6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803dbb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803dc1:	eb 31                	jmp    803df4 <devcons_write+0x4a>
		m = n - tot;
  803dc3:	8b 75 10             	mov    0x10(%ebp),%esi
  803dc6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  803dc8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803dcb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  803dd0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803dd3:	89 74 24 08          	mov    %esi,0x8(%esp)
  803dd7:	03 45 0c             	add    0xc(%ebp),%eax
  803dda:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dde:	89 3c 24             	mov    %edi,(%esp)
  803de1:	e8 fe e6 ff ff       	call   8024e4 <memmove>
		sys_cputs(buf, m);
  803de6:	89 74 24 04          	mov    %esi,0x4(%esp)
  803dea:	89 3c 24             	mov    %edi,(%esp)
  803ded:	e8 a4 e8 ff ff       	call   802696 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803df2:	01 f3                	add    %esi,%ebx
  803df4:	89 d8                	mov    %ebx,%eax
  803df6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  803df9:	72 c8                	jb     803dc3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803dfb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803e01:	5b                   	pop    %ebx
  803e02:	5e                   	pop    %esi
  803e03:	5f                   	pop    %edi
  803e04:	5d                   	pop    %ebp
  803e05:	c3                   	ret    

00803e06 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e06:	55                   	push   %ebp
  803e07:	89 e5                	mov    %esp,%ebp
  803e09:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803e0c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803e11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803e15:	75 07                	jne    803e1e <devcons_read+0x18>
  803e17:	eb 2a                	jmp    803e43 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803e19:	e8 26 e9 ff ff       	call   802744 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803e1e:	66 90                	xchg   %ax,%ax
  803e20:	e8 8f e8 ff ff       	call   8026b4 <sys_cgetc>
  803e25:	85 c0                	test   %eax,%eax
  803e27:	74 f0                	je     803e19 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  803e29:	85 c0                	test   %eax,%eax
  803e2b:	78 16                	js     803e43 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803e2d:	83 f8 04             	cmp    $0x4,%eax
  803e30:	74 0c                	je     803e3e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  803e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e35:	88 02                	mov    %al,(%edx)
	return 1;
  803e37:	b8 01 00 00 00       	mov    $0x1,%eax
  803e3c:	eb 05                	jmp    803e43 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803e3e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803e43:	c9                   	leave  
  803e44:	c3                   	ret    

00803e45 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803e45:	55                   	push   %ebp
  803e46:	89 e5                	mov    %esp,%ebp
  803e48:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803e51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803e58:	00 
  803e59:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803e5c:	89 04 24             	mov    %eax,(%esp)
  803e5f:	e8 32 e8 ff ff       	call   802696 <sys_cputs>
}
  803e64:	c9                   	leave  
  803e65:	c3                   	ret    

00803e66 <getchar>:

int
getchar(void)
{
  803e66:	55                   	push   %ebp
  803e67:	89 e5                	mov    %esp,%ebp
  803e69:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e6c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803e73:	00 
  803e74:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803e77:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e7b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e82:	e8 b3 f0 ff ff       	call   802f3a <read>
	if (r < 0)
  803e87:	85 c0                	test   %eax,%eax
  803e89:	78 0f                	js     803e9a <getchar+0x34>
		return r;
	if (r < 1)
  803e8b:	85 c0                	test   %eax,%eax
  803e8d:	7e 06                	jle    803e95 <getchar+0x2f>
		return -E_EOF;
	return c;
  803e8f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803e93:	eb 05                	jmp    803e9a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803e95:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803e9a:	c9                   	leave  
  803e9b:	c3                   	ret    

00803e9c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e9c:	55                   	push   %ebp
  803e9d:	89 e5                	mov    %esp,%ebp
  803e9f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ea2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  803eac:	89 04 24             	mov    %eax,(%esp)
  803eaf:	e8 f2 ed ff ff       	call   802ca6 <fd_lookup>
  803eb4:	85 c0                	test   %eax,%eax
  803eb6:	78 11                	js     803ec9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  803eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ebb:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803ec1:	39 10                	cmp    %edx,(%eax)
  803ec3:	0f 94 c0             	sete   %al
  803ec6:	0f b6 c0             	movzbl %al,%eax
}
  803ec9:	c9                   	leave  
  803eca:	c3                   	ret    

00803ecb <opencons>:

int
opencons(void)
{
  803ecb:	55                   	push   %ebp
  803ecc:	89 e5                	mov    %esp,%ebp
  803ece:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ed1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ed4:	89 04 24             	mov    %eax,(%esp)
  803ed7:	e8 7b ed ff ff       	call   802c57 <fd_alloc>
		return r;
  803edc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ede:	85 c0                	test   %eax,%eax
  803ee0:	78 40                	js     803f22 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ee2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803ee9:	00 
  803eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eed:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ef1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ef8:	e8 66 e8 ff ff       	call   802763 <sys_page_alloc>
		return r;
  803efd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803eff:	85 c0                	test   %eax,%eax
  803f01:	78 1f                	js     803f22 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803f03:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f0c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f11:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803f18:	89 04 24             	mov    %eax,(%esp)
  803f1b:	e8 10 ed ff ff       	call   802c30 <fd2num>
  803f20:	89 c2                	mov    %eax,%edx
}
  803f22:	89 d0                	mov    %edx,%eax
  803f24:	c9                   	leave  
  803f25:	c3                   	ret    
  803f26:	66 90                	xchg   %ax,%ax
  803f28:	66 90                	xchg   %ax,%ax
  803f2a:	66 90                	xchg   %ax,%ax
  803f2c:	66 90                	xchg   %ax,%ax
  803f2e:	66 90                	xchg   %ax,%ax

00803f30 <__udivdi3>:
  803f30:	55                   	push   %ebp
  803f31:	57                   	push   %edi
  803f32:	56                   	push   %esi
  803f33:	83 ec 0c             	sub    $0xc,%esp
  803f36:	8b 44 24 28          	mov    0x28(%esp),%eax
  803f3a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  803f3e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803f42:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803f46:	85 c0                	test   %eax,%eax
  803f48:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803f4c:	89 ea                	mov    %ebp,%edx
  803f4e:	89 0c 24             	mov    %ecx,(%esp)
  803f51:	75 2d                	jne    803f80 <__udivdi3+0x50>
  803f53:	39 e9                	cmp    %ebp,%ecx
  803f55:	77 61                	ja     803fb8 <__udivdi3+0x88>
  803f57:	85 c9                	test   %ecx,%ecx
  803f59:	89 ce                	mov    %ecx,%esi
  803f5b:	75 0b                	jne    803f68 <__udivdi3+0x38>
  803f5d:	b8 01 00 00 00       	mov    $0x1,%eax
  803f62:	31 d2                	xor    %edx,%edx
  803f64:	f7 f1                	div    %ecx
  803f66:	89 c6                	mov    %eax,%esi
  803f68:	31 d2                	xor    %edx,%edx
  803f6a:	89 e8                	mov    %ebp,%eax
  803f6c:	f7 f6                	div    %esi
  803f6e:	89 c5                	mov    %eax,%ebp
  803f70:	89 f8                	mov    %edi,%eax
  803f72:	f7 f6                	div    %esi
  803f74:	89 ea                	mov    %ebp,%edx
  803f76:	83 c4 0c             	add    $0xc,%esp
  803f79:	5e                   	pop    %esi
  803f7a:	5f                   	pop    %edi
  803f7b:	5d                   	pop    %ebp
  803f7c:	c3                   	ret    
  803f7d:	8d 76 00             	lea    0x0(%esi),%esi
  803f80:	39 e8                	cmp    %ebp,%eax
  803f82:	77 24                	ja     803fa8 <__udivdi3+0x78>
  803f84:	0f bd e8             	bsr    %eax,%ebp
  803f87:	83 f5 1f             	xor    $0x1f,%ebp
  803f8a:	75 3c                	jne    803fc8 <__udivdi3+0x98>
  803f8c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803f90:	39 34 24             	cmp    %esi,(%esp)
  803f93:	0f 86 9f 00 00 00    	jbe    804038 <__udivdi3+0x108>
  803f99:	39 d0                	cmp    %edx,%eax
  803f9b:	0f 82 97 00 00 00    	jb     804038 <__udivdi3+0x108>
  803fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803fa8:	31 d2                	xor    %edx,%edx
  803faa:	31 c0                	xor    %eax,%eax
  803fac:	83 c4 0c             	add    $0xc,%esp
  803faf:	5e                   	pop    %esi
  803fb0:	5f                   	pop    %edi
  803fb1:	5d                   	pop    %ebp
  803fb2:	c3                   	ret    
  803fb3:	90                   	nop
  803fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803fb8:	89 f8                	mov    %edi,%eax
  803fba:	f7 f1                	div    %ecx
  803fbc:	31 d2                	xor    %edx,%edx
  803fbe:	83 c4 0c             	add    $0xc,%esp
  803fc1:	5e                   	pop    %esi
  803fc2:	5f                   	pop    %edi
  803fc3:	5d                   	pop    %ebp
  803fc4:	c3                   	ret    
  803fc5:	8d 76 00             	lea    0x0(%esi),%esi
  803fc8:	89 e9                	mov    %ebp,%ecx
  803fca:	8b 3c 24             	mov    (%esp),%edi
  803fcd:	d3 e0                	shl    %cl,%eax
  803fcf:	89 c6                	mov    %eax,%esi
  803fd1:	b8 20 00 00 00       	mov    $0x20,%eax
  803fd6:	29 e8                	sub    %ebp,%eax
  803fd8:	89 c1                	mov    %eax,%ecx
  803fda:	d3 ef                	shr    %cl,%edi
  803fdc:	89 e9                	mov    %ebp,%ecx
  803fde:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803fe2:	8b 3c 24             	mov    (%esp),%edi
  803fe5:	09 74 24 08          	or     %esi,0x8(%esp)
  803fe9:	89 d6                	mov    %edx,%esi
  803feb:	d3 e7                	shl    %cl,%edi
  803fed:	89 c1                	mov    %eax,%ecx
  803fef:	89 3c 24             	mov    %edi,(%esp)
  803ff2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803ff6:	d3 ee                	shr    %cl,%esi
  803ff8:	89 e9                	mov    %ebp,%ecx
  803ffa:	d3 e2                	shl    %cl,%edx
  803ffc:	89 c1                	mov    %eax,%ecx
  803ffe:	d3 ef                	shr    %cl,%edi
  804000:	09 d7                	or     %edx,%edi
  804002:	89 f2                	mov    %esi,%edx
  804004:	89 f8                	mov    %edi,%eax
  804006:	f7 74 24 08          	divl   0x8(%esp)
  80400a:	89 d6                	mov    %edx,%esi
  80400c:	89 c7                	mov    %eax,%edi
  80400e:	f7 24 24             	mull   (%esp)
  804011:	39 d6                	cmp    %edx,%esi
  804013:	89 14 24             	mov    %edx,(%esp)
  804016:	72 30                	jb     804048 <__udivdi3+0x118>
  804018:	8b 54 24 04          	mov    0x4(%esp),%edx
  80401c:	89 e9                	mov    %ebp,%ecx
  80401e:	d3 e2                	shl    %cl,%edx
  804020:	39 c2                	cmp    %eax,%edx
  804022:	73 05                	jae    804029 <__udivdi3+0xf9>
  804024:	3b 34 24             	cmp    (%esp),%esi
  804027:	74 1f                	je     804048 <__udivdi3+0x118>
  804029:	89 f8                	mov    %edi,%eax
  80402b:	31 d2                	xor    %edx,%edx
  80402d:	e9 7a ff ff ff       	jmp    803fac <__udivdi3+0x7c>
  804032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804038:	31 d2                	xor    %edx,%edx
  80403a:	b8 01 00 00 00       	mov    $0x1,%eax
  80403f:	e9 68 ff ff ff       	jmp    803fac <__udivdi3+0x7c>
  804044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804048:	8d 47 ff             	lea    -0x1(%edi),%eax
  80404b:	31 d2                	xor    %edx,%edx
  80404d:	83 c4 0c             	add    $0xc,%esp
  804050:	5e                   	pop    %esi
  804051:	5f                   	pop    %edi
  804052:	5d                   	pop    %ebp
  804053:	c3                   	ret    
  804054:	66 90                	xchg   %ax,%ax
  804056:	66 90                	xchg   %ax,%ax
  804058:	66 90                	xchg   %ax,%ax
  80405a:	66 90                	xchg   %ax,%ax
  80405c:	66 90                	xchg   %ax,%ax
  80405e:	66 90                	xchg   %ax,%ax

00804060 <__umoddi3>:
  804060:	55                   	push   %ebp
  804061:	57                   	push   %edi
  804062:	56                   	push   %esi
  804063:	83 ec 14             	sub    $0x14,%esp
  804066:	8b 44 24 28          	mov    0x28(%esp),%eax
  80406a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80406e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  804072:	89 c7                	mov    %eax,%edi
  804074:	89 44 24 04          	mov    %eax,0x4(%esp)
  804078:	8b 44 24 30          	mov    0x30(%esp),%eax
  80407c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  804080:	89 34 24             	mov    %esi,(%esp)
  804083:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804087:	85 c0                	test   %eax,%eax
  804089:	89 c2                	mov    %eax,%edx
  80408b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80408f:	75 17                	jne    8040a8 <__umoddi3+0x48>
  804091:	39 fe                	cmp    %edi,%esi
  804093:	76 4b                	jbe    8040e0 <__umoddi3+0x80>
  804095:	89 c8                	mov    %ecx,%eax
  804097:	89 fa                	mov    %edi,%edx
  804099:	f7 f6                	div    %esi
  80409b:	89 d0                	mov    %edx,%eax
  80409d:	31 d2                	xor    %edx,%edx
  80409f:	83 c4 14             	add    $0x14,%esp
  8040a2:	5e                   	pop    %esi
  8040a3:	5f                   	pop    %edi
  8040a4:	5d                   	pop    %ebp
  8040a5:	c3                   	ret    
  8040a6:	66 90                	xchg   %ax,%ax
  8040a8:	39 f8                	cmp    %edi,%eax
  8040aa:	77 54                	ja     804100 <__umoddi3+0xa0>
  8040ac:	0f bd e8             	bsr    %eax,%ebp
  8040af:	83 f5 1f             	xor    $0x1f,%ebp
  8040b2:	75 5c                	jne    804110 <__umoddi3+0xb0>
  8040b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8040b8:	39 3c 24             	cmp    %edi,(%esp)
  8040bb:	0f 87 e7 00 00 00    	ja     8041a8 <__umoddi3+0x148>
  8040c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8040c5:	29 f1                	sub    %esi,%ecx
  8040c7:	19 c7                	sbb    %eax,%edi
  8040c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8040d9:	83 c4 14             	add    $0x14,%esp
  8040dc:	5e                   	pop    %esi
  8040dd:	5f                   	pop    %edi
  8040de:	5d                   	pop    %ebp
  8040df:	c3                   	ret    
  8040e0:	85 f6                	test   %esi,%esi
  8040e2:	89 f5                	mov    %esi,%ebp
  8040e4:	75 0b                	jne    8040f1 <__umoddi3+0x91>
  8040e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8040eb:	31 d2                	xor    %edx,%edx
  8040ed:	f7 f6                	div    %esi
  8040ef:	89 c5                	mov    %eax,%ebp
  8040f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040f5:	31 d2                	xor    %edx,%edx
  8040f7:	f7 f5                	div    %ebp
  8040f9:	89 c8                	mov    %ecx,%eax
  8040fb:	f7 f5                	div    %ebp
  8040fd:	eb 9c                	jmp    80409b <__umoddi3+0x3b>
  8040ff:	90                   	nop
  804100:	89 c8                	mov    %ecx,%eax
  804102:	89 fa                	mov    %edi,%edx
  804104:	83 c4 14             	add    $0x14,%esp
  804107:	5e                   	pop    %esi
  804108:	5f                   	pop    %edi
  804109:	5d                   	pop    %ebp
  80410a:	c3                   	ret    
  80410b:	90                   	nop
  80410c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804110:	8b 04 24             	mov    (%esp),%eax
  804113:	be 20 00 00 00       	mov    $0x20,%esi
  804118:	89 e9                	mov    %ebp,%ecx
  80411a:	29 ee                	sub    %ebp,%esi
  80411c:	d3 e2                	shl    %cl,%edx
  80411e:	89 f1                	mov    %esi,%ecx
  804120:	d3 e8                	shr    %cl,%eax
  804122:	89 e9                	mov    %ebp,%ecx
  804124:	89 44 24 04          	mov    %eax,0x4(%esp)
  804128:	8b 04 24             	mov    (%esp),%eax
  80412b:	09 54 24 04          	or     %edx,0x4(%esp)
  80412f:	89 fa                	mov    %edi,%edx
  804131:	d3 e0                	shl    %cl,%eax
  804133:	89 f1                	mov    %esi,%ecx
  804135:	89 44 24 08          	mov    %eax,0x8(%esp)
  804139:	8b 44 24 10          	mov    0x10(%esp),%eax
  80413d:	d3 ea                	shr    %cl,%edx
  80413f:	89 e9                	mov    %ebp,%ecx
  804141:	d3 e7                	shl    %cl,%edi
  804143:	89 f1                	mov    %esi,%ecx
  804145:	d3 e8                	shr    %cl,%eax
  804147:	89 e9                	mov    %ebp,%ecx
  804149:	09 f8                	or     %edi,%eax
  80414b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80414f:	f7 74 24 04          	divl   0x4(%esp)
  804153:	d3 e7                	shl    %cl,%edi
  804155:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804159:	89 d7                	mov    %edx,%edi
  80415b:	f7 64 24 08          	mull   0x8(%esp)
  80415f:	39 d7                	cmp    %edx,%edi
  804161:	89 c1                	mov    %eax,%ecx
  804163:	89 14 24             	mov    %edx,(%esp)
  804166:	72 2c                	jb     804194 <__umoddi3+0x134>
  804168:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80416c:	72 22                	jb     804190 <__umoddi3+0x130>
  80416e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  804172:	29 c8                	sub    %ecx,%eax
  804174:	19 d7                	sbb    %edx,%edi
  804176:	89 e9                	mov    %ebp,%ecx
  804178:	89 fa                	mov    %edi,%edx
  80417a:	d3 e8                	shr    %cl,%eax
  80417c:	89 f1                	mov    %esi,%ecx
  80417e:	d3 e2                	shl    %cl,%edx
  804180:	89 e9                	mov    %ebp,%ecx
  804182:	d3 ef                	shr    %cl,%edi
  804184:	09 d0                	or     %edx,%eax
  804186:	89 fa                	mov    %edi,%edx
  804188:	83 c4 14             	add    $0x14,%esp
  80418b:	5e                   	pop    %esi
  80418c:	5f                   	pop    %edi
  80418d:	5d                   	pop    %ebp
  80418e:	c3                   	ret    
  80418f:	90                   	nop
  804190:	39 d7                	cmp    %edx,%edi
  804192:	75 da                	jne    80416e <__umoddi3+0x10e>
  804194:	8b 14 24             	mov    (%esp),%edx
  804197:	89 c1                	mov    %eax,%ecx
  804199:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80419d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8041a1:	eb cb                	jmp    80416e <__umoddi3+0x10e>
  8041a3:	90                   	nop
  8041a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8041a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8041ac:	0f 82 0f ff ff ff    	jb     8040c1 <__umoddi3+0x61>
  8041b2:	e9 1a ff ff ff       	jmp    8040d1 <__umoddi3+0x71>
