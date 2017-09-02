
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 2c 09 00 00       	call   80095d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	envid_t ns_envid = sys_getenvid();
  80004c:	e8 74 14 00 00       	call   8014c5 <sys_getenvid>
  800051:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800053:	c7 05 00 40 80 00 c0 	movl   $0x8032c0,0x804000
  80005a:	32 80 00 

	output_envid = fork();
  80005d:	e8 d4 18 00 00       	call   801936 <fork>
  800062:	a3 04 50 80 00       	mov    %eax,0x805004
	if (output_envid < 0)
  800067:	85 c0                	test   %eax,%eax
  800069:	79 1c                	jns    800087 <umain+0x47>
		panic("error forking");
  80006b:	c7 44 24 08 ca 32 80 	movl   $0x8032ca,0x8(%esp)
  800072:	00 
  800073:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80007a:	00 
  80007b:	c7 04 24 d8 32 80 00 	movl   $0x8032d8,(%esp)
  800082:	e8 41 09 00 00       	call   8009c8 <_panic>
	else if (output_envid == 0) {
  800087:	85 c0                	test   %eax,%eax
  800089:	75 0d                	jne    800098 <umain+0x58>
		output(ns_envid);
  80008b:	89 1c 24             	mov    %ebx,(%esp)
  80008e:	e8 56 05 00 00       	call   8005e9 <output>
		return;
  800093:	e9 a5 03 00 00       	jmp    80043d <umain+0x3fd>
	}

	input_envid = fork();
  800098:	e8 99 18 00 00       	call   801936 <fork>
  80009d:	a3 00 50 80 00       	mov    %eax,0x805000
	if (input_envid < 0)
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	79 1c                	jns    8000c2 <umain+0x82>
		panic("error forking");
  8000a6:	c7 44 24 08 ca 32 80 	movl   $0x8032ca,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 d8 32 80 00 	movl   $0x8032d8,(%esp)
  8000bd:	e8 06 09 00 00       	call   8009c8 <_panic>
	else if (input_envid == 0) {
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	75 0f                	jne    8000d5 <umain+0x95>
		input(ns_envid);
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	e8 47 04 00 00       	call   800515 <input>
		return;
  8000ce:	66 90                	xchg   %ax,%ax
  8000d0:	e9 68 03 00 00       	jmp    80043d <umain+0x3fd>
	}

	cprintf("Sending ARP announcement...\n");
  8000d5:	c7 04 24 e8 32 80 00 	movl   $0x8032e8,(%esp)
  8000dc:	e8 e0 09 00 00       	call   800ac1 <cprintf>
	// with ARP requests.  Ideally, we would use gratuitous ARP
	// for this, but QEMU's ARP implementation is dumb and only
	// listens for very specific ARP requests, such as requests
	// for the gateway IP.

	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  8000e1:	c6 45 98 52          	movb   $0x52,-0x68(%ebp)
  8000e5:	c6 45 99 54          	movb   $0x54,-0x67(%ebp)
  8000e9:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
  8000ed:	c6 45 9b 12          	movb   $0x12,-0x65(%ebp)
  8000f1:	c6 45 9c 34          	movb   $0x34,-0x64(%ebp)
  8000f5:	c6 45 9d 56          	movb   $0x56,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000f9:	c7 04 24 05 33 80 00 	movl   $0x803305,(%esp)
  800100:	e8 20 08 00 00       	call   800925 <inet_addr>
  800105:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  800108:	c7 04 24 0f 33 80 00 	movl   $0x80330f,(%esp)
  80010f:	e8 11 08 00 00       	call   800925 <inet_addr>
  800114:	89 45 94             	mov    %eax,-0x6c(%ebp)
	int r;

	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800117:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800126:	0f 
  800127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80012e:	e8 d0 13 00 00       	call   801503 <sys_page_alloc>
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x117>
		panic("sys_page_map: %e", r);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 18 33 80 	movl   $0x803318,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 d8 32 80 00 	movl   $0x8032d8,(%esp)
  800152:	e8 71 08 00 00       	call   8009c8 <_panic>

	struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
	pkt->jp_len = sizeof(*arp);
  800157:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  80015e:	00 00 00 

	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  800161:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800168:	00 
  800169:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800170:	00 
  800171:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  800178:	e8 ba 10 00 00       	call   801237 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80017d:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800184:	00 
  800185:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800188:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80018c:	c7 04 24 0a b0 fe 0f 	movl   $0xffeb00a,(%esp)
  800193:	e8 54 11 00 00       	call   8012ec <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  800198:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  80019f:	e8 52 05 00 00       	call   8006f6 <htons>
  8001a4:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  8001aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001b1:	e8 40 05 00 00       	call   8006f6 <htons>
  8001b6:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  8001bc:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  8001c3:	e8 2e 05 00 00       	call   8006f6 <htons>
  8001c8:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001ce:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  8001d5:	e8 1c 05 00 00       	call   8006f6 <htons>
  8001da:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  8001e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001e7:	e8 0a 05 00 00       	call   8006f6 <htons>
  8001ec:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001f2:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8001f9:	00 
  8001fa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001fe:	c7 04 24 1a b0 fe 0f 	movl   $0xffeb01a,(%esp)
  800205:	e8 e2 10 00 00       	call   8012ec <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  80020a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800211:	00 
  800212:	8d 45 90             	lea    -0x70(%ebp),%eax
  800215:	89 44 24 04          	mov    %eax,0x4(%esp)
  800219:	c7 04 24 20 b0 fe 0f 	movl   $0xffeb020,(%esp)
  800220:	e8 c7 10 00 00       	call   8012ec <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800225:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  80022c:	00 
  80022d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800234:	00 
  800235:	c7 04 24 24 b0 fe 0f 	movl   $0xffeb024,(%esp)
  80023c:	e8 f6 0f 00 00       	call   801237 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  800241:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800248:	00 
  800249:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80024c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800250:	c7 04 24 2a b0 fe 0f 	movl   $0xffeb02a,(%esp)
  800257:	e8 90 10 00 00       	call   8012ec <memcpy>

	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  80025c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800263:	00 
  800264:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  80026b:	0f 
  80026c:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800273:	00 
  800274:	a1 04 50 80 00       	mov    0x805004,%eax
  800279:	89 04 24             	mov    %eax,(%esp)
  80027c:	e8 72 19 00 00       	call   801bf3 <ipc_send>
	sys_page_unmap(0, pkt);
  800281:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800288:	0f 
  800289:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800290:	e8 15 13 00 00       	call   8015aa <sys_page_unmap>

void
umain(int argc, char **argv)
{
	envid_t ns_envid = sys_getenvid();
	int i, r, first = 1;
  800295:	c7 85 7c ff ff ff 01 	movl   $0x1,-0x84(%ebp)
  80029c:	00 00 00 

	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  80029f:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8002a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a6:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  8002ad:	0f 
  8002ae:	8d 45 90             	lea    -0x70(%ebp),%eax
  8002b1:	89 04 24             	mov    %eax,(%esp)
  8002b4:	e8 d0 18 00 00       	call   801b89 <ipc_recv>
		if (req < 0)
  8002b9:	85 c0                	test   %eax,%eax
  8002bb:	79 20                	jns    8002dd <umain+0x29d>
			panic("ipc_recv: %e", req);
  8002bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c1:	c7 44 24 08 29 33 80 	movl   $0x803329,0x8(%esp)
  8002c8:	00 
  8002c9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8002d0:	00 
  8002d1:	c7 04 24 d8 32 80 00 	movl   $0x8032d8,(%esp)
  8002d8:	e8 eb 06 00 00       	call   8009c8 <_panic>
		if (whom != input_envid)
  8002dd:	8b 55 90             	mov    -0x70(%ebp),%edx
  8002e0:	3b 15 00 50 80 00    	cmp    0x805000,%edx
  8002e6:	74 20                	je     800308 <umain+0x2c8>
			panic("IPC from unexpected environment %08x", whom);
  8002e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002ec:	c7 44 24 08 80 33 80 	movl   $0x803380,0x8(%esp)
  8002f3:	00 
  8002f4:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8002fb:	00 
  8002fc:	c7 04 24 d8 32 80 00 	movl   $0x8032d8,(%esp)
  800303:	e8 c0 06 00 00       	call   8009c8 <_panic>
		if (req != NSREQ_INPUT)
  800308:	83 f8 0a             	cmp    $0xa,%eax
  80030b:	74 20                	je     80032d <umain+0x2ed>
			panic("Unexpected IPC %d", req);
  80030d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800311:	c7 44 24 08 36 33 80 	movl   $0x803336,0x8(%esp)
  800318:	00 
  800319:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
  800320:	00 
  800321:	c7 04 24 d8 32 80 00 	movl   $0x8032d8,(%esp)
  800328:	e8 9b 06 00 00       	call   8009c8 <_panic>

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  80032d:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  800332:	89 45 84             	mov    %eax,-0x7c(%ebp)
hexdump(const char *prefix, const void *data, int len)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
  800335:	be 00 00 00 00       	mov    $0x0,%esi
	for (i = 0; i < len; i++) {
  80033a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
		if (i % 16 == 15 || i == len - 1)
  80033f:	83 e8 01             	sub    $0x1,%eax
  800342:	89 45 80             	mov    %eax,-0x80(%ebp)
  800345:	e9 ba 00 00 00       	jmp    800404 <umain+0x3c4>
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
		if (i % 16 == 0)
  80034a:	89 df                	mov    %ebx,%edi
  80034c:	f6 c3 0f             	test   $0xf,%bl
  80034f:	75 2d                	jne    80037e <umain+0x33e>
			out = buf + snprintf(buf, end - buf,
  800351:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800355:	c7 44 24 0c 48 33 80 	movl   $0x803348,0xc(%esp)
  80035c:	00 
  80035d:	c7 44 24 08 50 33 80 	movl   $0x803350,0x8(%esp)
  800364:	00 
  800365:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80036c:	00 
  80036d:	8d 45 98             	lea    -0x68(%ebp),%eax
  800370:	89 04 24             	mov    %eax,(%esp)
  800373:	e8 02 0d 00 00       	call   80107a <snprintf>
  800378:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  80037b:	8d 34 01             	lea    (%ecx,%eax,1),%esi
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  80037e:	b8 04 b0 fe 0f       	mov    $0xffeb004,%eax
  800383:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
  800387:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80038b:	c7 44 24 08 5a 33 80 	movl   $0x80335a,0x8(%esp)
  800392:	00 
  800393:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800396:	29 f0                	sub    %esi,%eax
  800398:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039c:	89 34 24             	mov    %esi,(%esp)
  80039f:	e8 d6 0c 00 00       	call   80107a <snprintf>
  8003a4:	01 c6                	add    %eax,%esi
		if (i % 16 == 15 || i == len - 1)
  8003a6:	89 d8                	mov    %ebx,%eax
  8003a8:	c1 f8 1f             	sar    $0x1f,%eax
  8003ab:	c1 e8 1c             	shr    $0x1c,%eax
  8003ae:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
  8003b1:	83 e7 0f             	and    $0xf,%edi
  8003b4:	29 c7                	sub    %eax,%edi
  8003b6:	83 ff 0f             	cmp    $0xf,%edi
  8003b9:	74 05                	je     8003c0 <umain+0x380>
  8003bb:	3b 5d 80             	cmp    -0x80(%ebp),%ebx
  8003be:	75 1e                	jne    8003de <umain+0x39e>
			cprintf("%.*s\n", out - buf, buf);
  8003c0:	8d 45 98             	lea    -0x68(%ebp),%eax
  8003c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c7:	89 f0                	mov    %esi,%eax
  8003c9:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  8003cc:	29 c8                	sub    %ecx,%eax
  8003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d2:	c7 04 24 5f 33 80 00 	movl   $0x80335f,(%esp)
  8003d9:	e8 e3 06 00 00       	call   800ac1 <cprintf>
		if (i % 2 == 1)
  8003de:	89 d8                	mov    %ebx,%eax
  8003e0:	c1 e8 1f             	shr    $0x1f,%eax
  8003e3:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8003e6:	83 e2 01             	and    $0x1,%edx
  8003e9:	29 c2                	sub    %eax,%edx
  8003eb:	83 fa 01             	cmp    $0x1,%edx
  8003ee:	75 06                	jne    8003f6 <umain+0x3b6>
			*(out++) = ' ';
  8003f0:	c6 06 20             	movb   $0x20,(%esi)
  8003f3:	8d 76 01             	lea    0x1(%esi),%esi
		if (i % 16 == 7)
  8003f6:	83 ff 07             	cmp    $0x7,%edi
  8003f9:	75 06                	jne    800401 <umain+0x3c1>
			*(out++) = ' ';
  8003fb:	c6 06 20             	movb   $0x20,(%esi)
  8003fe:	8d 76 01             	lea    0x1(%esi),%esi
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  800401:	83 c3 01             	add    $0x1,%ebx
  800404:	39 5d 84             	cmp    %ebx,-0x7c(%ebp)
  800407:	0f 8f 3d ff ff ff    	jg     80034a <umain+0x30a>
			panic("IPC from unexpected environment %08x", whom);
		if (req != NSREQ_INPUT)
			panic("Unexpected IPC %d", req);

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
		cprintf("\n");
  80040d:	c7 04 24 22 34 80 00 	movl   $0x803422,(%esp)
  800414:	e8 a8 06 00 00       	call   800ac1 <cprintf>

		// Only indicate that we're waiting for packets once
		// we've received the ARP reply
		if (first)
  800419:	83 bd 7c ff ff ff 00 	cmpl   $0x0,-0x84(%ebp)
  800420:	74 0c                	je     80042e <umain+0x3ee>
			cprintf("Waiting for packets...\n");
  800422:	c7 04 24 65 33 80 00 	movl   $0x803365,(%esp)
  800429:	e8 93 06 00 00       	call   800ac1 <cprintf>
		first = 0;
  80042e:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  800435:	00 00 00 
	}
  800438:	e9 62 fe ff ff       	jmp    80029f <umain+0x25f>
}
  80043d:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  800443:	5b                   	pop    %ebx
  800444:	5e                   	pop    %esi
  800445:	5f                   	pop    %edi
  800446:	5d                   	pop    %ebp
  800447:	c3                   	ret    
  800448:	66 90                	xchg   %ax,%ax
  80044a:	66 90                	xchg   %ax,%ax
  80044c:	66 90                	xchg   %ax,%ax
  80044e:	66 90                	xchg   %ax,%ax

00800450 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	57                   	push   %edi
  800454:	56                   	push   %esi
  800455:	53                   	push   %ebx
  800456:	83 ec 2c             	sub    $0x2c,%esp
  800459:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80045c:	e8 0a 13 00 00       	call   80176b <sys_time_msec>
  800461:	03 45 0c             	add    0xc(%ebp),%eax
  800464:	89 c6                	mov    %eax,%esi

	binaryname = "ns_timer";
  800466:	c7 05 00 40 80 00 a5 	movl   $0x8033a5,0x804000
  80046d:	33 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800470:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800473:	eb 05                	jmp    80047a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
  800475:	e8 6a 10 00 00       	call   8014e4 <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80047a:	e8 ec 12 00 00       	call   80176b <sys_time_msec>
  80047f:	39 c6                	cmp    %eax,%esi
  800481:	76 06                	jbe    800489 <timer+0x39>
  800483:	85 c0                	test   %eax,%eax
  800485:	79 ee                	jns    800475 <timer+0x25>
  800487:	eb 09                	jmp    800492 <timer+0x42>
			sys_yield();
		}
		if (r < 0)
  800489:	85 c0                	test   %eax,%eax
  80048b:	90                   	nop
  80048c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800490:	79 20                	jns    8004b2 <timer+0x62>
			panic("sys_time_msec: %e", r);
  800492:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800496:	c7 44 24 08 ae 33 80 	movl   $0x8033ae,0x8(%esp)
  80049d:	00 
  80049e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8004a5:	00 
  8004a6:	c7 04 24 c0 33 80 00 	movl   $0x8033c0,(%esp)
  8004ad:	e8 16 05 00 00       	call   8009c8 <_panic>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8004b2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004b9:	00 
  8004ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004c1:	00 
  8004c2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8004c9:	00 
  8004ca:	89 1c 24             	mov    %ebx,(%esp)
  8004cd:	e8 21 17 00 00       	call   801bf3 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8004d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004d9:	00 
  8004da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004e1:	00 
  8004e2:	89 3c 24             	mov    %edi,(%esp)
  8004e5:	e8 9f 16 00 00       	call   801b89 <ipc_recv>
  8004ea:	89 c6                	mov    %eax,%esi

			if (whom != ns_envid) {
  8004ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ef:	39 c3                	cmp    %eax,%ebx
  8004f1:	74 12                	je     800505 <timer+0xb5>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8004f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f7:	c7 04 24 cc 33 80 00 	movl   $0x8033cc,(%esp)
  8004fe:	e8 be 05 00 00       	call   800ac1 <cprintf>
  800503:	eb cd                	jmp    8004d2 <timer+0x82>
				continue;
			}

			stop = sys_time_msec() + to;
  800505:	e8 61 12 00 00       	call   80176b <sys_time_msec>
  80050a:	01 c6                	add    %eax,%esi
  80050c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800510:	e9 65 ff ff ff       	jmp    80047a <timer+0x2a>

00800515 <input>:
#include <kern/e1000.h>
extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	57                   	push   %edi
  800519:	56                   	push   %esi
  80051a:	53                   	push   %ebx
  80051b:	81 ec 2c 08 00 00    	sub    $0x82c,%esp
  800521:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r ;
	binaryname = "ns_input";
  800524:	c7 05 00 40 80 00 07 	movl   $0x803407,0x804000
  80052b:	34 80 00 
	char data[2048];
	int len;
	while(1)
	{ 
		while(sys_e1000_recieve(data,&len)<0)
  80052e:	8d bd e4 f7 ff ff    	lea    -0x81c(%ebp),%edi
  800534:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
  80053a:	eb 05                	jmp    800541 <input+0x2c>
		{
			sys_yield();
  80053c:	e8 a3 0f 00 00       	call   8014e4 <sys_yield>
	binaryname = "ns_input";
	char data[2048];
	int len;
	while(1)
	{ 
		while(sys_e1000_recieve(data,&len)<0)
  800541:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800545:	89 34 24             	mov    %esi,(%esp)
  800548:	e8 90 12 00 00       	call   8017dd <sys_e1000_recieve>
  80054d:	85 c0                	test   %eax,%eax
  80054f:	78 eb                	js     80053c <input+0x27>
		{
			sys_yield();
		}
		int r = sys_page_alloc(0,&nsipcbuf,PTE_P|PTE_U|PTE_W);
  800551:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800558:	00 
  800559:	c7 44 24 04 00 70 86 	movl   $0x867000,0x4(%esp)
  800560:	00 
  800561:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800568:	e8 96 0f 00 00       	call   801503 <sys_page_alloc>
		while(r<0)
  80056d:	eb 28                	jmp    800597 <input+0x82>
		{
		   cprintf("page alloc failed \n");
  80056f:	c7 04 24 10 34 80 00 	movl   $0x803410,(%esp)
  800576:	e8 46 05 00 00       	call   800ac1 <cprintf>
		  r = sys_page_alloc(0,&nsipcbuf,PTE_P|PTE_U|PTE_W);
  80057b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800582:	00 
  800583:	c7 44 24 04 00 70 86 	movl   $0x867000,0x4(%esp)
  80058a:	00 
  80058b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800592:	e8 6c 0f 00 00       	call   801503 <sys_page_alloc>
		while(sys_e1000_recieve(data,&len)<0)
		{
			sys_yield();
		}
		int r = sys_page_alloc(0,&nsipcbuf,PTE_P|PTE_U|PTE_W);
		while(r<0)
  800597:	85 c0                	test   %eax,%eax
  800599:	78 d4                	js     80056f <input+0x5a>
		{
		   cprintf("page alloc failed \n");
		  r = sys_page_alloc(0,&nsipcbuf,PTE_P|PTE_U|PTE_W);
		}
		memcpy(nsipcbuf.pkt.jp_data,data,len);
  80059b:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  8005a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005a9:	c7 04 24 04 70 86 00 	movl   $0x867004,(%esp)
  8005b0:	e8 37 0d 00 00       	call   8012ec <memcpy>
		nsipcbuf.pkt.jp_len = len;
  8005b5:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  8005bb:	a3 00 70 86 00       	mov    %eax,0x867000
		while(sys_ipc_try_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_W|PTE_U|PTE_P)<0);
  8005c0:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8005c7:	00 
  8005c8:	c7 44 24 08 00 70 86 	movl   $0x867000,0x8(%esp)
  8005cf:	00 
  8005d0:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8005d7:	00 
  8005d8:	89 1c 24             	mov    %ebx,(%esp)
  8005db:	e8 16 11 00 00       	call   8016f6 <sys_ipc_try_send>
  8005e0:	85 c0                	test   %eax,%eax
  8005e2:	78 dc                	js     8005c0 <input+0xab>
  8005e4:	e9 58 ff ff ff       	jmp    800541 <input+0x2c>

008005e9 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	83 ec 18             	sub    $0x18,%esp
	binaryname = "ns_output";
  8005ef:	c7 05 00 40 80 00 24 	movl   $0x803424,0x804000
  8005f6:	34 80 00 
	while(1)
	{
		sys_ipc_recv(&nsipcbuf);
  8005f9:	c7 04 24 00 70 86 00 	movl   $0x867000,(%esp)
  800600:	e8 14 11 00 00       	call   801719 <sys_ipc_recv>
		cprintf("From output.c length recieved is %d \n",nsipcbuf.pkt.jp_len);
  800605:	a1 00 70 86 00       	mov    0x867000,%eax
  80060a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060e:	c7 04 24 30 34 80 00 	movl   $0x803430,(%esp)
  800615:	e8 a7 04 00 00       	call   800ac1 <cprintf>
		sys_e1000_transmit(nsipcbuf.pkt.jp_data,nsipcbuf.pkt.jp_len);
  80061a:	a1 00 70 86 00       	mov    0x867000,%eax
  80061f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800623:	c7 04 24 04 70 86 00 	movl   $0x867004,(%esp)
  80062a:	e8 5b 11 00 00       	call   80178a <sys_e1000_transmit>
  80062f:	eb c8                	jmp    8005f9 <output+0x10>
  800631:	66 90                	xchg   %ax,%ax
  800633:	66 90                	xchg   %ax,%ax
  800635:	66 90                	xchg   %ax,%ax
  800637:	66 90                	xchg   %ax,%ax
  800639:	66 90                	xchg   %ax,%ax
  80063b:	66 90                	xchg   %ax,%ax
  80063d:	66 90                	xchg   %ax,%ax
  80063f:	90                   	nop

00800640 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800640:	55                   	push   %ebp
  800641:	89 e5                	mov    %esp,%ebp
  800643:	57                   	push   %edi
  800644:	56                   	push   %esi
  800645:	53                   	push   %ebx
  800646:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80064f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800653:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800656:	c7 45 dc 08 50 80 00 	movl   $0x805008,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80065d:	be 00 00 00 00       	mov    $0x0,%esi
  800662:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800665:	eb 02                	jmp    800669 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800667:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800669:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80066c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80066f:	0f b6 c2             	movzbl %dl,%eax
  800672:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  800675:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  800678:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80067b:	66 c1 e8 0b          	shr    $0xb,%ax
  80067f:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800681:	8d 4e 01             	lea    0x1(%esi),%ecx
  800684:	89 f3                	mov    %esi,%ebx
  800686:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800689:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  80068c:	01 ff                	add    %edi,%edi
  80068e:	89 fb                	mov    %edi,%ebx
  800690:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  800692:	83 c2 30             	add    $0x30,%edx
  800695:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  800699:	84 c0                	test   %al,%al
  80069b:	75 ca                	jne    800667 <inet_ntoa+0x27>
  80069d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006a0:	89 c8                	mov    %ecx,%eax
  8006a2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006a5:	89 cf                	mov    %ecx,%edi
  8006a7:	eb 0d                	jmp    8006b6 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  8006a9:	0f b6 f0             	movzbl %al,%esi
  8006ac:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  8006b1:	88 0a                	mov    %cl,(%edx)
  8006b3:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8006b6:	83 e8 01             	sub    $0x1,%eax
  8006b9:	3c ff                	cmp    $0xff,%al
  8006bb:	75 ec                	jne    8006a9 <inet_ntoa+0x69>
  8006bd:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  8006c0:	89 f9                	mov    %edi,%ecx
  8006c2:	0f b6 c9             	movzbl %cl,%ecx
  8006c5:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  8006c8:	8d 41 01             	lea    0x1(%ecx),%eax
  8006cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  8006ce:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8006d2:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  8006d6:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  8006da:	77 0a                	ja     8006e6 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8006dc:	c6 01 2e             	movb   $0x2e,(%ecx)
  8006df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e4:	eb 81                	jmp    800667 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  8006e6:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  8006e9:	b8 08 50 80 00       	mov    $0x805008,%eax
  8006ee:	83 c4 19             	add    $0x19,%esp
  8006f1:	5b                   	pop    %ebx
  8006f2:	5e                   	pop    %esi
  8006f3:	5f                   	pop    %edi
  8006f4:	5d                   	pop    %ebp
  8006f5:	c3                   	ret    

008006f6 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8006f9:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8006fd:	66 c1 c0 08          	rol    $0x8,%ax
}
  800701:	5d                   	pop    %ebp
  800702:	c3                   	ret    

00800703 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800703:	55                   	push   %ebp
  800704:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800706:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80070a:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800716:	89 d1                	mov    %edx,%ecx
  800718:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80071b:	89 d0                	mov    %edx,%eax
  80071d:	c1 e0 18             	shl    $0x18,%eax
  800720:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800722:	89 d1                	mov    %edx,%ecx
  800724:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  80072a:	c1 e1 08             	shl    $0x8,%ecx
  80072d:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  80072f:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800735:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  800738:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80073a:	5d                   	pop    %ebp
  80073b:	c3                   	ret    

0080073c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	57                   	push   %edi
  800740:	56                   	push   %esi
  800741:	53                   	push   %ebx
  800742:	83 ec 20             	sub    $0x20,%esp
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800748:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80074b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80074e:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800751:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800754:	80 f9 09             	cmp    $0x9,%cl
  800757:	0f 87 a6 01 00 00    	ja     800903 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80075d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800764:	83 fa 30             	cmp    $0x30,%edx
  800767:	75 2b                	jne    800794 <inet_aton+0x58>
      c = *++cp;
  800769:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80076d:	89 d1                	mov    %edx,%ecx
  80076f:	83 e1 df             	and    $0xffffffdf,%ecx
  800772:	80 f9 58             	cmp    $0x58,%cl
  800775:	74 0f                	je     800786 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  800777:	83 c0 01             	add    $0x1,%eax
  80077a:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  80077d:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800784:	eb 0e                	jmp    800794 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  800786:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80078a:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80078d:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800794:	83 c0 01             	add    $0x1,%eax
  800797:	bf 00 00 00 00       	mov    $0x0,%edi
  80079c:	eb 03                	jmp    8007a1 <inet_aton+0x65>
  80079e:	83 c0 01             	add    $0x1,%eax
  8007a1:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  8007a4:	89 d3                	mov    %edx,%ebx
  8007a6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8007a9:	80 f9 09             	cmp    $0x9,%cl
  8007ac:	77 0d                	ja     8007bb <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  8007ae:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  8007b2:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  8007b6:	0f be 10             	movsbl (%eax),%edx
  8007b9:	eb e3                	jmp    80079e <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  8007bb:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  8007bf:	75 30                	jne    8007f1 <inet_aton+0xb5>
  8007c1:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  8007c4:	88 4d df             	mov    %cl,-0x21(%ebp)
  8007c7:	89 d1                	mov    %edx,%ecx
  8007c9:	83 e1 df             	and    $0xffffffdf,%ecx
  8007cc:	83 e9 41             	sub    $0x41,%ecx
  8007cf:	80 f9 05             	cmp    $0x5,%cl
  8007d2:	77 23                	ja     8007f7 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8007d4:	89 fb                	mov    %edi,%ebx
  8007d6:	c1 e3 04             	shl    $0x4,%ebx
  8007d9:	8d 7a 0a             	lea    0xa(%edx),%edi
  8007dc:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  8007e0:	19 c9                	sbb    %ecx,%ecx
  8007e2:	83 e1 20             	and    $0x20,%ecx
  8007e5:	83 c1 41             	add    $0x41,%ecx
  8007e8:	29 cf                	sub    %ecx,%edi
  8007ea:	09 df                	or     %ebx,%edi
        c = *++cp;
  8007ec:	0f be 10             	movsbl (%eax),%edx
  8007ef:	eb ad                	jmp    80079e <inet_aton+0x62>
  8007f1:	89 d0                	mov    %edx,%eax
  8007f3:	89 f9                	mov    %edi,%ecx
  8007f5:	eb 04                	jmp    8007fb <inet_aton+0xbf>
  8007f7:	89 d0                	mov    %edx,%eax
  8007f9:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  8007fb:	83 f8 2e             	cmp    $0x2e,%eax
  8007fe:	75 22                	jne    800822 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  800800:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800803:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800806:	0f 84 fe 00 00 00    	je     80090a <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  80080c:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  800810:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800813:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  800816:	8d 46 01             	lea    0x1(%esi),%eax
  800819:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  80081d:	e9 2f ff ff ff       	jmp    800751 <inet_aton+0x15>
  800822:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800824:	85 d2                	test   %edx,%edx
  800826:	74 27                	je     80084f <inet_aton+0x113>
    return (0);
  800828:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80082d:	80 fb 1f             	cmp    $0x1f,%bl
  800830:	0f 86 e7 00 00 00    	jbe    80091d <inet_aton+0x1e1>
  800836:	84 d2                	test   %dl,%dl
  800838:	0f 88 d3 00 00 00    	js     800911 <inet_aton+0x1d5>
  80083e:	83 fa 20             	cmp    $0x20,%edx
  800841:	74 0c                	je     80084f <inet_aton+0x113>
  800843:	83 ea 09             	sub    $0x9,%edx
  800846:	83 fa 04             	cmp    $0x4,%edx
  800849:	0f 87 ce 00 00 00    	ja     80091d <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80084f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800852:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800855:	29 c2                	sub    %eax,%edx
  800857:	c1 fa 02             	sar    $0x2,%edx
  80085a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80085d:	83 fa 02             	cmp    $0x2,%edx
  800860:	74 22                	je     800884 <inet_aton+0x148>
  800862:	83 fa 02             	cmp    $0x2,%edx
  800865:	7f 0f                	jg     800876 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800867:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80086c:	85 d2                	test   %edx,%edx
  80086e:	0f 84 a9 00 00 00    	je     80091d <inet_aton+0x1e1>
  800874:	eb 73                	jmp    8008e9 <inet_aton+0x1ad>
  800876:	83 fa 03             	cmp    $0x3,%edx
  800879:	74 26                	je     8008a1 <inet_aton+0x165>
  80087b:	83 fa 04             	cmp    $0x4,%edx
  80087e:	66 90                	xchg   %ax,%ax
  800880:	74 40                	je     8008c2 <inet_aton+0x186>
  800882:	eb 65                	jmp    8008e9 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  800884:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800889:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  80088f:	0f 87 88 00 00 00    	ja     80091d <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  800895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800898:	c1 e0 18             	shl    $0x18,%eax
  80089b:	89 cf                	mov    %ecx,%edi
  80089d:	09 c7                	or     %eax,%edi
    break;
  80089f:	eb 48                	jmp    8008e9 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  8008a1:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8008a6:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  8008ac:	77 6f                	ja     80091d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  8008ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008b1:	c1 e2 10             	shl    $0x10,%edx
  8008b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008b7:	c1 e0 18             	shl    $0x18,%eax
  8008ba:	09 d0                	or     %edx,%eax
  8008bc:	09 c8                	or     %ecx,%eax
  8008be:	89 c7                	mov    %eax,%edi
    break;
  8008c0:	eb 27                	jmp    8008e9 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  8008c2:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8008c7:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  8008cd:	77 4e                	ja     80091d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8008cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008d2:	c1 e2 10             	shl    $0x10,%edx
  8008d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008d8:	c1 e0 18             	shl    $0x18,%eax
  8008db:	09 c2                	or     %eax,%edx
  8008dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e0:	c1 e0 08             	shl    $0x8,%eax
  8008e3:	09 d0                	or     %edx,%eax
  8008e5:	09 c8                	or     %ecx,%eax
  8008e7:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  8008e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ed:	74 29                	je     800918 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  8008ef:	89 3c 24             	mov    %edi,(%esp)
  8008f2:	e8 19 fe ff ff       	call   800710 <htonl>
  8008f7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008fa:	89 06                	mov    %eax,(%esi)
  return (1);
  8008fc:	b8 01 00 00 00       	mov    $0x1,%eax
  800901:	eb 1a                	jmp    80091d <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
  800908:	eb 13                	jmp    80091d <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  80090a:	b8 00 00 00 00       	mov    $0x0,%eax
  80090f:	eb 0c                	jmp    80091d <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  800911:	b8 00 00 00 00       	mov    $0x0,%eax
  800916:	eb 05                	jmp    80091d <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  800918:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80091d:	83 c4 20             	add    $0x20,%esp
  800920:	5b                   	pop    %ebx
  800921:	5e                   	pop    %esi
  800922:	5f                   	pop    %edi
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80092b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80092e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 04 24             	mov    %eax,(%esp)
  800938:	e8 ff fd ff ff       	call   80073c <inet_aton>
  80093d:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80093f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800944:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  800948:	c9                   	leave  
  800949:	c3                   	ret    

0080094a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	89 04 24             	mov    %eax,(%esp)
  800956:	e8 b5 fd ff ff       	call   800710 <htonl>
}
  80095b:	c9                   	leave  
  80095c:	c3                   	ret    

0080095d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	56                   	push   %esi
  800961:	53                   	push   %ebx
  800962:	83 ec 10             	sub    $0x10,%esp
  800965:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800968:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80096b:	c7 05 40 50 86 00 00 	movl   $0x0,0x865040
  800972:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800975:	e8 4b 0b 00 00       	call   8014c5 <sys_getenvid>
  80097a:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80097f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800982:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800987:	a3 40 50 86 00       	mov    %eax,0x865040


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80098c:	85 db                	test   %ebx,%ebx
  80098e:	7e 07                	jle    800997 <libmain+0x3a>
		binaryname = argv[0];
  800990:	8b 06                	mov    (%esi),%eax
  800992:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800997:	89 74 24 04          	mov    %esi,0x4(%esp)
  80099b:	89 1c 24             	mov    %ebx,(%esp)
  80099e:	e8 9d f6 ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  8009a3:	e8 07 00 00 00       	call   8009af <exit>
}
  8009a8:	83 c4 10             	add    $0x10,%esp
  8009ab:	5b                   	pop    %ebx
  8009ac:	5e                   	pop    %esi
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    

008009af <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8009b5:	e8 b0 14 00 00       	call   801e6a <close_all>
	sys_env_destroy(0);
  8009ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009c1:	e8 ad 0a 00 00       	call   801473 <sys_env_destroy>
}
  8009c6:	c9                   	leave  
  8009c7:	c3                   	ret    

008009c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8009d0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8009d3:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8009d9:	e8 e7 0a 00 00       	call   8014c5 <sys_getenvid>
  8009de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8009e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009ec:	89 74 24 08          	mov    %esi,0x8(%esp)
  8009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f4:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  8009fb:	e8 c1 00 00 00       	call   800ac1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a04:	8b 45 10             	mov    0x10(%ebp),%eax
  800a07:	89 04 24             	mov    %eax,(%esp)
  800a0a:	e8 51 00 00 00       	call   800a60 <vcprintf>
	cprintf("\n");
  800a0f:	c7 04 24 22 34 80 00 	movl   $0x803422,(%esp)
  800a16:	e8 a6 00 00 00       	call   800ac1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a1b:	cc                   	int3   
  800a1c:	eb fd                	jmp    800a1b <_panic+0x53>

00800a1e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	53                   	push   %ebx
  800a22:	83 ec 14             	sub    $0x14,%esp
  800a25:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800a28:	8b 13                	mov    (%ebx),%edx
  800a2a:	8d 42 01             	lea    0x1(%edx),%eax
  800a2d:	89 03                	mov    %eax,(%ebx)
  800a2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a32:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800a36:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a3b:	75 19                	jne    800a56 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800a3d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800a44:	00 
  800a45:	8d 43 08             	lea    0x8(%ebx),%eax
  800a48:	89 04 24             	mov    %eax,(%esp)
  800a4b:	e8 e6 09 00 00       	call   801436 <sys_cputs>
		b->idx = 0;
  800a50:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800a56:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800a5a:	83 c4 14             	add    $0x14,%esp
  800a5d:	5b                   	pop    %ebx
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800a69:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a70:	00 00 00 
	b.cnt = 0;
  800a73:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a7a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a8b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a91:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a95:	c7 04 24 1e 0a 80 00 	movl   $0x800a1e,(%esp)
  800a9c:	e8 ad 01 00 00       	call   800c4e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800aa1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aab:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800ab1:	89 04 24             	mov    %eax,(%esp)
  800ab4:	e8 7d 09 00 00       	call   801436 <sys_cputs>

	return b.cnt;
}
  800ab9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800abf:	c9                   	leave  
  800ac0:	c3                   	ret    

00800ac1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800ac7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	89 04 24             	mov    %eax,(%esp)
  800ad4:	e8 87 ff ff ff       	call   800a60 <vcprintf>
	va_end(ap);

	return cnt;
}
  800ad9:	c9                   	leave  
  800ada:	c3                   	ret    
  800adb:	66 90                	xchg   %ax,%ax
  800add:	66 90                	xchg   %ax,%ax
  800adf:	90                   	nop

00800ae0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	57                   	push   %edi
  800ae4:	56                   	push   %esi
  800ae5:	53                   	push   %ebx
  800ae6:	83 ec 3c             	sub    $0x3c,%esp
  800ae9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aec:	89 d7                	mov    %edx,%edi
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af7:	89 c3                	mov    %eax,%ebx
  800af9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b0a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b0d:	39 d9                	cmp    %ebx,%ecx
  800b0f:	72 05                	jb     800b16 <printnum+0x36>
  800b11:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b14:	77 69                	ja     800b7f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b16:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b19:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800b1d:	83 ee 01             	sub    $0x1,%esi
  800b20:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b24:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b28:	8b 44 24 08          	mov    0x8(%esp),%eax
  800b2c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800b30:	89 c3                	mov    %eax,%ebx
  800b32:	89 d6                	mov    %edx,%esi
  800b34:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b37:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b3a:	89 54 24 08          	mov    %edx,0x8(%esp)
  800b3e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b45:	89 04 24             	mov    %eax,(%esp)
  800b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b4f:	e8 cc 24 00 00       	call   803020 <__udivdi3>
  800b54:	89 d9                	mov    %ebx,%ecx
  800b56:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b5a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b5e:	89 04 24             	mov    %eax,(%esp)
  800b61:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b65:	89 fa                	mov    %edi,%edx
  800b67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b6a:	e8 71 ff ff ff       	call   800ae0 <printnum>
  800b6f:	eb 1b                	jmp    800b8c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b71:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b75:	8b 45 18             	mov    0x18(%ebp),%eax
  800b78:	89 04 24             	mov    %eax,(%esp)
  800b7b:	ff d3                	call   *%ebx
  800b7d:	eb 03                	jmp    800b82 <printnum+0xa2>
  800b7f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b82:	83 ee 01             	sub    $0x1,%esi
  800b85:	85 f6                	test   %esi,%esi
  800b87:	7f e8                	jg     800b71 <printnum+0x91>
  800b89:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b8c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b90:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b97:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800b9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b9e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ba2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ba5:	89 04 24             	mov    %eax,(%esp)
  800ba8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  800baf:	e8 9c 25 00 00       	call   803150 <__umoddi3>
  800bb4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bb8:	0f be 80 83 34 80 00 	movsbl 0x803483(%eax),%eax
  800bbf:	89 04 24             	mov    %eax,(%esp)
  800bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bc5:	ff d0                	call   *%eax
}
  800bc7:	83 c4 3c             	add    $0x3c,%esp
  800bca:	5b                   	pop    %ebx
  800bcb:	5e                   	pop    %esi
  800bcc:	5f                   	pop    %edi
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bd2:	83 fa 01             	cmp    $0x1,%edx
  800bd5:	7e 0e                	jle    800be5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800bd7:	8b 10                	mov    (%eax),%edx
  800bd9:	8d 4a 08             	lea    0x8(%edx),%ecx
  800bdc:	89 08                	mov    %ecx,(%eax)
  800bde:	8b 02                	mov    (%edx),%eax
  800be0:	8b 52 04             	mov    0x4(%edx),%edx
  800be3:	eb 22                	jmp    800c07 <getuint+0x38>
	else if (lflag)
  800be5:	85 d2                	test   %edx,%edx
  800be7:	74 10                	je     800bf9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800be9:	8b 10                	mov    (%eax),%edx
  800beb:	8d 4a 04             	lea    0x4(%edx),%ecx
  800bee:	89 08                	mov    %ecx,(%eax)
  800bf0:	8b 02                	mov    (%edx),%eax
  800bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf7:	eb 0e                	jmp    800c07 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800bf9:	8b 10                	mov    (%eax),%edx
  800bfb:	8d 4a 04             	lea    0x4(%edx),%ecx
  800bfe:	89 08                	mov    %ecx,(%eax)
  800c00:	8b 02                	mov    (%edx),%eax
  800c02:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c0f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c13:	8b 10                	mov    (%eax),%edx
  800c15:	3b 50 04             	cmp    0x4(%eax),%edx
  800c18:	73 0a                	jae    800c24 <sprintputch+0x1b>
		*b->buf++ = ch;
  800c1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1d:	89 08                	mov    %ecx,(%eax)
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	88 02                	mov    %al,(%edx)
}
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c2c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 04 24             	mov    %eax,(%esp)
  800c47:	e8 02 00 00 00       	call   800c4e <vprintfmt>
	va_end(ap);
}
  800c4c:	c9                   	leave  
  800c4d:	c3                   	ret    

00800c4e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	83 ec 3c             	sub    $0x3c,%esp
  800c57:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5d:	eb 14                	jmp    800c73 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800c5f:	85 c0                	test   %eax,%eax
  800c61:	0f 84 b3 03 00 00    	je     80101a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800c67:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c6b:	89 04 24             	mov    %eax,(%esp)
  800c6e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c71:	89 f3                	mov    %esi,%ebx
  800c73:	8d 73 01             	lea    0x1(%ebx),%esi
  800c76:	0f b6 03             	movzbl (%ebx),%eax
  800c79:	83 f8 25             	cmp    $0x25,%eax
  800c7c:	75 e1                	jne    800c5f <vprintfmt+0x11>
  800c7e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800c82:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c89:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800c90:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800c97:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9c:	eb 1d                	jmp    800cbb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c9e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800ca4:	eb 15                	jmp    800cbb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ca6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800cac:	eb 0d                	jmp    800cbb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800cae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800cb1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800cb4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cbb:	8d 5e 01             	lea    0x1(%esi),%ebx
  800cbe:	0f b6 0e             	movzbl (%esi),%ecx
  800cc1:	0f b6 c1             	movzbl %cl,%eax
  800cc4:	83 e9 23             	sub    $0x23,%ecx
  800cc7:	80 f9 55             	cmp    $0x55,%cl
  800cca:	0f 87 2a 03 00 00    	ja     800ffa <vprintfmt+0x3ac>
  800cd0:	0f b6 c9             	movzbl %cl,%ecx
  800cd3:	ff 24 8d c0 35 80 00 	jmp    *0x8035c0(,%ecx,4)
  800cda:	89 de                	mov    %ebx,%esi
  800cdc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800ce1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800ce4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800ce8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800ceb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800cee:	83 fb 09             	cmp    $0x9,%ebx
  800cf1:	77 36                	ja     800d29 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cf3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cf6:	eb e9                	jmp    800ce1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	8d 48 04             	lea    0x4(%eax),%ecx
  800cfe:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d06:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800d08:	eb 22                	jmp    800d2c <vprintfmt+0xde>
  800d0a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800d0d:	85 c9                	test   %ecx,%ecx
  800d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d14:	0f 49 c1             	cmovns %ecx,%eax
  800d17:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d1a:	89 de                	mov    %ebx,%esi
  800d1c:	eb 9d                	jmp    800cbb <vprintfmt+0x6d>
  800d1e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800d20:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800d27:	eb 92                	jmp    800cbb <vprintfmt+0x6d>
  800d29:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800d2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d30:	79 89                	jns    800cbb <vprintfmt+0x6d>
  800d32:	e9 77 ff ff ff       	jmp    800cae <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d37:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d3a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800d3c:	e9 7a ff ff ff       	jmp    800cbb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	8d 50 04             	lea    0x4(%eax),%edx
  800d47:	89 55 14             	mov    %edx,0x14(%ebp)
  800d4a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	89 04 24             	mov    %eax,(%esp)
  800d53:	ff 55 08             	call   *0x8(%ebp)
			break;
  800d56:	e9 18 ff ff ff       	jmp    800c73 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5e:	8d 50 04             	lea    0x4(%eax),%edx
  800d61:	89 55 14             	mov    %edx,0x14(%ebp)
  800d64:	8b 00                	mov    (%eax),%eax
  800d66:	99                   	cltd   
  800d67:	31 d0                	xor    %edx,%eax
  800d69:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d6b:	83 f8 0f             	cmp    $0xf,%eax
  800d6e:	7f 0b                	jg     800d7b <vprintfmt+0x12d>
  800d70:	8b 14 85 20 37 80 00 	mov    0x803720(,%eax,4),%edx
  800d77:	85 d2                	test   %edx,%edx
  800d79:	75 20                	jne    800d9b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800d7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d7f:	c7 44 24 08 9b 34 80 	movl   $0x80349b,0x8(%esp)
  800d86:	00 
  800d87:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	89 04 24             	mov    %eax,(%esp)
  800d91:	e8 90 fe ff ff       	call   800c26 <printfmt>
  800d96:	e9 d8 fe ff ff       	jmp    800c73 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800d9b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800d9f:	c7 44 24 08 e5 39 80 	movl   $0x8039e5,0x8(%esp)
  800da6:	00 
  800da7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	89 04 24             	mov    %eax,(%esp)
  800db1:	e8 70 fe ff ff       	call   800c26 <printfmt>
  800db6:	e9 b8 fe ff ff       	jmp    800c73 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dbb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800dbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800dc1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc7:	8d 50 04             	lea    0x4(%eax),%edx
  800dca:	89 55 14             	mov    %edx,0x14(%ebp)
  800dcd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800dcf:	85 f6                	test   %esi,%esi
  800dd1:	b8 94 34 80 00       	mov    $0x803494,%eax
  800dd6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800dd9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800ddd:	0f 84 97 00 00 00    	je     800e7a <vprintfmt+0x22c>
  800de3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800de7:	0f 8e 9b 00 00 00    	jle    800e88 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ded:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800df1:	89 34 24             	mov    %esi,(%esp)
  800df4:	e8 cf 02 00 00       	call   8010c8 <strnlen>
  800df9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800dfc:	29 c2                	sub    %eax,%edx
  800dfe:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800e01:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800e05:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e08:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800e0b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e0e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e11:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e13:	eb 0f                	jmp    800e24 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800e15:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e1c:	89 04 24             	mov    %eax,(%esp)
  800e1f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e21:	83 eb 01             	sub    $0x1,%ebx
  800e24:	85 db                	test   %ebx,%ebx
  800e26:	7f ed                	jg     800e15 <vprintfmt+0x1c7>
  800e28:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800e2b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e2e:	85 d2                	test   %edx,%edx
  800e30:	b8 00 00 00 00       	mov    $0x0,%eax
  800e35:	0f 49 c2             	cmovns %edx,%eax
  800e38:	29 c2                	sub    %eax,%edx
  800e3a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800e3d:	89 d7                	mov    %edx,%edi
  800e3f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800e42:	eb 50                	jmp    800e94 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800e44:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e48:	74 1e                	je     800e68 <vprintfmt+0x21a>
  800e4a:	0f be d2             	movsbl %dl,%edx
  800e4d:	83 ea 20             	sub    $0x20,%edx
  800e50:	83 fa 5e             	cmp    $0x5e,%edx
  800e53:	76 13                	jbe    800e68 <vprintfmt+0x21a>
					putch('?', putdat);
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e5c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800e63:	ff 55 08             	call   *0x8(%ebp)
  800e66:	eb 0d                	jmp    800e75 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800e68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e6f:	89 04 24             	mov    %eax,(%esp)
  800e72:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e75:	83 ef 01             	sub    $0x1,%edi
  800e78:	eb 1a                	jmp    800e94 <vprintfmt+0x246>
  800e7a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800e7d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800e80:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e83:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800e86:	eb 0c                	jmp    800e94 <vprintfmt+0x246>
  800e88:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800e8b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800e8e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e91:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800e94:	83 c6 01             	add    $0x1,%esi
  800e97:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800e9b:	0f be c2             	movsbl %dl,%eax
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	74 27                	je     800ec9 <vprintfmt+0x27b>
  800ea2:	85 db                	test   %ebx,%ebx
  800ea4:	78 9e                	js     800e44 <vprintfmt+0x1f6>
  800ea6:	83 eb 01             	sub    $0x1,%ebx
  800ea9:	79 99                	jns    800e44 <vprintfmt+0x1f6>
  800eab:	89 f8                	mov    %edi,%eax
  800ead:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800eb0:	8b 75 08             	mov    0x8(%ebp),%esi
  800eb3:	89 c3                	mov    %eax,%ebx
  800eb5:	eb 1a                	jmp    800ed1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800eb7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ebb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800ec2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ec4:	83 eb 01             	sub    $0x1,%ebx
  800ec7:	eb 08                	jmp    800ed1 <vprintfmt+0x283>
  800ec9:	89 fb                	mov    %edi,%ebx
  800ecb:	8b 75 08             	mov    0x8(%ebp),%esi
  800ece:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ed1:	85 db                	test   %ebx,%ebx
  800ed3:	7f e2                	jg     800eb7 <vprintfmt+0x269>
  800ed5:	89 75 08             	mov    %esi,0x8(%ebp)
  800ed8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800edb:	e9 93 fd ff ff       	jmp    800c73 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800ee0:	83 fa 01             	cmp    $0x1,%edx
  800ee3:	7e 16                	jle    800efb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee8:	8d 50 08             	lea    0x8(%eax),%edx
  800eeb:	89 55 14             	mov    %edx,0x14(%ebp)
  800eee:	8b 50 04             	mov    0x4(%eax),%edx
  800ef1:	8b 00                	mov    (%eax),%eax
  800ef3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ef6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ef9:	eb 32                	jmp    800f2d <vprintfmt+0x2df>
	else if (lflag)
  800efb:	85 d2                	test   %edx,%edx
  800efd:	74 18                	je     800f17 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800eff:	8b 45 14             	mov    0x14(%ebp),%eax
  800f02:	8d 50 04             	lea    0x4(%eax),%edx
  800f05:	89 55 14             	mov    %edx,0x14(%ebp)
  800f08:	8b 30                	mov    (%eax),%esi
  800f0a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800f0d:	89 f0                	mov    %esi,%eax
  800f0f:	c1 f8 1f             	sar    $0x1f,%eax
  800f12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f15:	eb 16                	jmp    800f2d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800f17:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1a:	8d 50 04             	lea    0x4(%eax),%edx
  800f1d:	89 55 14             	mov    %edx,0x14(%ebp)
  800f20:	8b 30                	mov    (%eax),%esi
  800f22:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800f25:	89 f0                	mov    %esi,%eax
  800f27:	c1 f8 1f             	sar    $0x1f,%eax
  800f2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800f33:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800f38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f3c:	0f 89 80 00 00 00    	jns    800fc2 <vprintfmt+0x374>
				putch('-', putdat);
  800f42:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f46:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800f4d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800f50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f56:	f7 d8                	neg    %eax
  800f58:	83 d2 00             	adc    $0x0,%edx
  800f5b:	f7 da                	neg    %edx
			}
			base = 10;
  800f5d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f62:	eb 5e                	jmp    800fc2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f64:	8d 45 14             	lea    0x14(%ebp),%eax
  800f67:	e8 63 fc ff ff       	call   800bcf <getuint>
			base = 10;
  800f6c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800f71:	eb 4f                	jmp    800fc2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800f73:	8d 45 14             	lea    0x14(%ebp),%eax
  800f76:	e8 54 fc ff ff       	call   800bcf <getuint>
			base =8;
  800f7b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800f80:	eb 40                	jmp    800fc2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800f82:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f86:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800f8d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800f90:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f94:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800f9b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800f9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa1:	8d 50 04             	lea    0x4(%eax),%edx
  800fa4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fa7:	8b 00                	mov    (%eax),%eax
  800fa9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800fae:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800fb3:	eb 0d                	jmp    800fc2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fb5:	8d 45 14             	lea    0x14(%ebp),%eax
  800fb8:	e8 12 fc ff ff       	call   800bcf <getuint>
			base = 16;
  800fbd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fc2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800fc6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800fca:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800fcd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800fd1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fd5:	89 04 24             	mov    %eax,(%esp)
  800fd8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fdc:	89 fa                	mov    %edi,%edx
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	e8 fa fa ff ff       	call   800ae0 <printnum>
			break;
  800fe6:	e9 88 fc ff ff       	jmp    800c73 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800feb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fef:	89 04 24             	mov    %eax,(%esp)
  800ff2:	ff 55 08             	call   *0x8(%ebp)
			break;
  800ff5:	e9 79 fc ff ff       	jmp    800c73 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ffa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ffe:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801005:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801008:	89 f3                	mov    %esi,%ebx
  80100a:	eb 03                	jmp    80100f <vprintfmt+0x3c1>
  80100c:	83 eb 01             	sub    $0x1,%ebx
  80100f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801013:	75 f7                	jne    80100c <vprintfmt+0x3be>
  801015:	e9 59 fc ff ff       	jmp    800c73 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80101a:	83 c4 3c             	add    $0x3c,%esp
  80101d:	5b                   	pop    %ebx
  80101e:	5e                   	pop    %esi
  80101f:	5f                   	pop    %edi
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    

00801022 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 28             	sub    $0x28,%esp
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80102e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801031:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801035:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801038:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80103f:	85 c0                	test   %eax,%eax
  801041:	74 30                	je     801073 <vsnprintf+0x51>
  801043:	85 d2                	test   %edx,%edx
  801045:	7e 2c                	jle    801073 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801047:	8b 45 14             	mov    0x14(%ebp),%eax
  80104a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80104e:	8b 45 10             	mov    0x10(%ebp),%eax
  801051:	89 44 24 08          	mov    %eax,0x8(%esp)
  801055:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80105c:	c7 04 24 09 0c 80 00 	movl   $0x800c09,(%esp)
  801063:	e8 e6 fb ff ff       	call   800c4e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801068:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80106b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80106e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801071:	eb 05                	jmp    801078 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801073:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801080:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801083:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	89 44 24 04          	mov    %eax,0x4(%esp)
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	89 04 24             	mov    %eax,(%esp)
  80109b:	e8 82 ff ff ff       	call   801022 <vsnprintf>
	va_end(ap);

	return rc;
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    
  8010a2:	66 90                	xchg   %ax,%ax
  8010a4:	66 90                	xchg   %ax,%ax
  8010a6:	66 90                	xchg   %ax,%ax
  8010a8:	66 90                	xchg   %ax,%ax
  8010aa:	66 90                	xchg   %ax,%ax
  8010ac:	66 90                	xchg   %ax,%ax
  8010ae:	66 90                	xchg   %ax,%ax

008010b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8010b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bb:	eb 03                	jmp    8010c0 <strlen+0x10>
		n++;
  8010bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8010c4:	75 f7                	jne    8010bd <strlen+0xd>
		n++;
	return n;
}
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    

008010c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d6:	eb 03                	jmp    8010db <strnlen+0x13>
		n++;
  8010d8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010db:	39 d0                	cmp    %edx,%eax
  8010dd:	74 06                	je     8010e5 <strnlen+0x1d>
  8010df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8010e3:	75 f3                	jne    8010d8 <strnlen+0x10>
		n++;
	return n;
}
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    

008010e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	53                   	push   %ebx
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8010f1:	89 c2                	mov    %eax,%edx
  8010f3:	83 c2 01             	add    $0x1,%edx
  8010f6:	83 c1 01             	add    $0x1,%ecx
  8010f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8010fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  801100:	84 db                	test   %bl,%bl
  801102:	75 ef                	jne    8010f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801104:	5b                   	pop    %ebx
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	53                   	push   %ebx
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801111:	89 1c 24             	mov    %ebx,(%esp)
  801114:	e8 97 ff ff ff       	call   8010b0 <strlen>
	strcpy(dst + len, src);
  801119:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801120:	01 d8                	add    %ebx,%eax
  801122:	89 04 24             	mov    %eax,(%esp)
  801125:	e8 bd ff ff ff       	call   8010e7 <strcpy>
	return dst;
}
  80112a:	89 d8                	mov    %ebx,%eax
  80112c:	83 c4 08             	add    $0x8,%esp
  80112f:	5b                   	pop    %ebx
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    

00801132 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	56                   	push   %esi
  801136:	53                   	push   %ebx
  801137:	8b 75 08             	mov    0x8(%ebp),%esi
  80113a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113d:	89 f3                	mov    %esi,%ebx
  80113f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801142:	89 f2                	mov    %esi,%edx
  801144:	eb 0f                	jmp    801155 <strncpy+0x23>
		*dst++ = *src;
  801146:	83 c2 01             	add    $0x1,%edx
  801149:	0f b6 01             	movzbl (%ecx),%eax
  80114c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80114f:	80 39 01             	cmpb   $0x1,(%ecx)
  801152:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801155:	39 da                	cmp    %ebx,%edx
  801157:	75 ed                	jne    801146 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801159:	89 f0                	mov    %esi,%eax
  80115b:	5b                   	pop    %ebx
  80115c:	5e                   	pop    %esi
  80115d:	5d                   	pop    %ebp
  80115e:	c3                   	ret    

0080115f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	56                   	push   %esi
  801163:	53                   	push   %ebx
  801164:	8b 75 08             	mov    0x8(%ebp),%esi
  801167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80116d:	89 f0                	mov    %esi,%eax
  80116f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801173:	85 c9                	test   %ecx,%ecx
  801175:	75 0b                	jne    801182 <strlcpy+0x23>
  801177:	eb 1d                	jmp    801196 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801179:	83 c0 01             	add    $0x1,%eax
  80117c:	83 c2 01             	add    $0x1,%edx
  80117f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801182:	39 d8                	cmp    %ebx,%eax
  801184:	74 0b                	je     801191 <strlcpy+0x32>
  801186:	0f b6 0a             	movzbl (%edx),%ecx
  801189:	84 c9                	test   %cl,%cl
  80118b:	75 ec                	jne    801179 <strlcpy+0x1a>
  80118d:	89 c2                	mov    %eax,%edx
  80118f:	eb 02                	jmp    801193 <strlcpy+0x34>
  801191:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801193:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801196:	29 f0                	sub    %esi,%eax
}
  801198:	5b                   	pop    %ebx
  801199:	5e                   	pop    %esi
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    

0080119c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8011a5:	eb 06                	jmp    8011ad <strcmp+0x11>
		p++, q++;
  8011a7:	83 c1 01             	add    $0x1,%ecx
  8011aa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011ad:	0f b6 01             	movzbl (%ecx),%eax
  8011b0:	84 c0                	test   %al,%al
  8011b2:	74 04                	je     8011b8 <strcmp+0x1c>
  8011b4:	3a 02                	cmp    (%edx),%al
  8011b6:	74 ef                	je     8011a7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011b8:	0f b6 c0             	movzbl %al,%eax
  8011bb:	0f b6 12             	movzbl (%edx),%edx
  8011be:	29 d0                	sub    %edx,%eax
}
  8011c0:	5d                   	pop    %ebp
  8011c1:	c3                   	ret    

008011c2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	53                   	push   %ebx
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011cc:	89 c3                	mov    %eax,%ebx
  8011ce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8011d1:	eb 06                	jmp    8011d9 <strncmp+0x17>
		n--, p++, q++;
  8011d3:	83 c0 01             	add    $0x1,%eax
  8011d6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011d9:	39 d8                	cmp    %ebx,%eax
  8011db:	74 15                	je     8011f2 <strncmp+0x30>
  8011dd:	0f b6 08             	movzbl (%eax),%ecx
  8011e0:	84 c9                	test   %cl,%cl
  8011e2:	74 04                	je     8011e8 <strncmp+0x26>
  8011e4:	3a 0a                	cmp    (%edx),%cl
  8011e6:	74 eb                	je     8011d3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e8:	0f b6 00             	movzbl (%eax),%eax
  8011eb:	0f b6 12             	movzbl (%edx),%edx
  8011ee:	29 d0                	sub    %edx,%eax
  8011f0:	eb 05                	jmp    8011f7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8011f2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8011f7:	5b                   	pop    %ebx
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    

008011fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801204:	eb 07                	jmp    80120d <strchr+0x13>
		if (*s == c)
  801206:	38 ca                	cmp    %cl,%dl
  801208:	74 0f                	je     801219 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80120a:	83 c0 01             	add    $0x1,%eax
  80120d:	0f b6 10             	movzbl (%eax),%edx
  801210:	84 d2                	test   %dl,%dl
  801212:	75 f2                	jne    801206 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801214:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801219:	5d                   	pop    %ebp
  80121a:	c3                   	ret    

0080121b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801225:	eb 07                	jmp    80122e <strfind+0x13>
		if (*s == c)
  801227:	38 ca                	cmp    %cl,%dl
  801229:	74 0a                	je     801235 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80122b:	83 c0 01             	add    $0x1,%eax
  80122e:	0f b6 10             	movzbl (%eax),%edx
  801231:	84 d2                	test   %dl,%dl
  801233:	75 f2                	jne    801227 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801235:	5d                   	pop    %ebp
  801236:	c3                   	ret    

00801237 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	57                   	push   %edi
  80123b:	56                   	push   %esi
  80123c:	53                   	push   %ebx
  80123d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801240:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801243:	85 c9                	test   %ecx,%ecx
  801245:	74 36                	je     80127d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801247:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80124d:	75 28                	jne    801277 <memset+0x40>
  80124f:	f6 c1 03             	test   $0x3,%cl
  801252:	75 23                	jne    801277 <memset+0x40>
		c &= 0xFF;
  801254:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801258:	89 d3                	mov    %edx,%ebx
  80125a:	c1 e3 08             	shl    $0x8,%ebx
  80125d:	89 d6                	mov    %edx,%esi
  80125f:	c1 e6 18             	shl    $0x18,%esi
  801262:	89 d0                	mov    %edx,%eax
  801264:	c1 e0 10             	shl    $0x10,%eax
  801267:	09 f0                	or     %esi,%eax
  801269:	09 c2                	or     %eax,%edx
  80126b:	89 d0                	mov    %edx,%eax
  80126d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80126f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801272:	fc                   	cld    
  801273:	f3 ab                	rep stos %eax,%es:(%edi)
  801275:	eb 06                	jmp    80127d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	fc                   	cld    
  80127b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80127d:	89 f8                	mov    %edi,%eax
  80127f:	5b                   	pop    %ebx
  801280:	5e                   	pop    %esi
  801281:	5f                   	pop    %edi
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    

00801284 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	57                   	push   %edi
  801288:	56                   	push   %esi
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80128f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801292:	39 c6                	cmp    %eax,%esi
  801294:	73 35                	jae    8012cb <memmove+0x47>
  801296:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801299:	39 d0                	cmp    %edx,%eax
  80129b:	73 2e                	jae    8012cb <memmove+0x47>
		s += n;
		d += n;
  80129d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8012a0:	89 d6                	mov    %edx,%esi
  8012a2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012a4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8012aa:	75 13                	jne    8012bf <memmove+0x3b>
  8012ac:	f6 c1 03             	test   $0x3,%cl
  8012af:	75 0e                	jne    8012bf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012b1:	83 ef 04             	sub    $0x4,%edi
  8012b4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8012b7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012ba:	fd                   	std    
  8012bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8012bd:	eb 09                	jmp    8012c8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012bf:	83 ef 01             	sub    $0x1,%edi
  8012c2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012c5:	fd                   	std    
  8012c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012c8:	fc                   	cld    
  8012c9:	eb 1d                	jmp    8012e8 <memmove+0x64>
  8012cb:	89 f2                	mov    %esi,%edx
  8012cd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012cf:	f6 c2 03             	test   $0x3,%dl
  8012d2:	75 0f                	jne    8012e3 <memmove+0x5f>
  8012d4:	f6 c1 03             	test   $0x3,%cl
  8012d7:	75 0a                	jne    8012e3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012d9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012dc:	89 c7                	mov    %eax,%edi
  8012de:	fc                   	cld    
  8012df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8012e1:	eb 05                	jmp    8012e8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012e3:	89 c7                	mov    %eax,%edi
  8012e5:	fc                   	cld    
  8012e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8012e8:	5e                   	pop    %esi
  8012e9:	5f                   	pop    %edi
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    

008012ec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8012f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	89 04 24             	mov    %eax,(%esp)
  801306:	e8 79 ff ff ff       	call   801284 <memmove>
}
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	56                   	push   %esi
  801311:	53                   	push   %ebx
  801312:	8b 55 08             	mov    0x8(%ebp),%edx
  801315:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801318:	89 d6                	mov    %edx,%esi
  80131a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80131d:	eb 1a                	jmp    801339 <memcmp+0x2c>
		if (*s1 != *s2)
  80131f:	0f b6 02             	movzbl (%edx),%eax
  801322:	0f b6 19             	movzbl (%ecx),%ebx
  801325:	38 d8                	cmp    %bl,%al
  801327:	74 0a                	je     801333 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801329:	0f b6 c0             	movzbl %al,%eax
  80132c:	0f b6 db             	movzbl %bl,%ebx
  80132f:	29 d8                	sub    %ebx,%eax
  801331:	eb 0f                	jmp    801342 <memcmp+0x35>
		s1++, s2++;
  801333:	83 c2 01             	add    $0x1,%edx
  801336:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801339:	39 f2                	cmp    %esi,%edx
  80133b:	75 e2                	jne    80131f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801342:	5b                   	pop    %ebx
  801343:	5e                   	pop    %esi
  801344:	5d                   	pop    %ebp
  801345:	c3                   	ret    

00801346 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80134f:	89 c2                	mov    %eax,%edx
  801351:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801354:	eb 07                	jmp    80135d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  801356:	38 08                	cmp    %cl,(%eax)
  801358:	74 07                	je     801361 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80135a:	83 c0 01             	add    $0x1,%eax
  80135d:	39 d0                	cmp    %edx,%eax
  80135f:	72 f5                	jb     801356 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    

00801363 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	57                   	push   %edi
  801367:	56                   	push   %esi
  801368:	53                   	push   %ebx
  801369:	8b 55 08             	mov    0x8(%ebp),%edx
  80136c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80136f:	eb 03                	jmp    801374 <strtol+0x11>
		s++;
  801371:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801374:	0f b6 0a             	movzbl (%edx),%ecx
  801377:	80 f9 09             	cmp    $0x9,%cl
  80137a:	74 f5                	je     801371 <strtol+0xe>
  80137c:	80 f9 20             	cmp    $0x20,%cl
  80137f:	74 f0                	je     801371 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  801381:	80 f9 2b             	cmp    $0x2b,%cl
  801384:	75 0a                	jne    801390 <strtol+0x2d>
		s++;
  801386:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801389:	bf 00 00 00 00       	mov    $0x0,%edi
  80138e:	eb 11                	jmp    8013a1 <strtol+0x3e>
  801390:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801395:	80 f9 2d             	cmp    $0x2d,%cl
  801398:	75 07                	jne    8013a1 <strtol+0x3e>
		s++, neg = 1;
  80139a:	8d 52 01             	lea    0x1(%edx),%edx
  80139d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013a1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8013a6:	75 15                	jne    8013bd <strtol+0x5a>
  8013a8:	80 3a 30             	cmpb   $0x30,(%edx)
  8013ab:	75 10                	jne    8013bd <strtol+0x5a>
  8013ad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8013b1:	75 0a                	jne    8013bd <strtol+0x5a>
		s += 2, base = 16;
  8013b3:	83 c2 02             	add    $0x2,%edx
  8013b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8013bb:	eb 10                	jmp    8013cd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	75 0c                	jne    8013cd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8013c1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8013c3:	80 3a 30             	cmpb   $0x30,(%edx)
  8013c6:	75 05                	jne    8013cd <strtol+0x6a>
		s++, base = 8;
  8013c8:	83 c2 01             	add    $0x1,%edx
  8013cb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8013cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013d5:	0f b6 0a             	movzbl (%edx),%ecx
  8013d8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8013db:	89 f0                	mov    %esi,%eax
  8013dd:	3c 09                	cmp    $0x9,%al
  8013df:	77 08                	ja     8013e9 <strtol+0x86>
			dig = *s - '0';
  8013e1:	0f be c9             	movsbl %cl,%ecx
  8013e4:	83 e9 30             	sub    $0x30,%ecx
  8013e7:	eb 20                	jmp    801409 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8013e9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8013ec:	89 f0                	mov    %esi,%eax
  8013ee:	3c 19                	cmp    $0x19,%al
  8013f0:	77 08                	ja     8013fa <strtol+0x97>
			dig = *s - 'a' + 10;
  8013f2:	0f be c9             	movsbl %cl,%ecx
  8013f5:	83 e9 57             	sub    $0x57,%ecx
  8013f8:	eb 0f                	jmp    801409 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8013fa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8013fd:	89 f0                	mov    %esi,%eax
  8013ff:	3c 19                	cmp    $0x19,%al
  801401:	77 16                	ja     801419 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801403:	0f be c9             	movsbl %cl,%ecx
  801406:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801409:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80140c:	7d 0f                	jge    80141d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80140e:	83 c2 01             	add    $0x1,%edx
  801411:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801415:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801417:	eb bc                	jmp    8013d5 <strtol+0x72>
  801419:	89 d8                	mov    %ebx,%eax
  80141b:	eb 02                	jmp    80141f <strtol+0xbc>
  80141d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80141f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801423:	74 05                	je     80142a <strtol+0xc7>
		*endptr = (char *) s;
  801425:	8b 75 0c             	mov    0xc(%ebp),%esi
  801428:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80142a:	f7 d8                	neg    %eax
  80142c:	85 ff                	test   %edi,%edi
  80142e:	0f 44 c3             	cmove  %ebx,%eax
}
  801431:	5b                   	pop    %ebx
  801432:	5e                   	pop    %esi
  801433:	5f                   	pop    %edi
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    

00801436 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	57                   	push   %edi
  80143a:	56                   	push   %esi
  80143b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80143c:	b8 00 00 00 00       	mov    $0x0,%eax
  801441:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801444:	8b 55 08             	mov    0x8(%ebp),%edx
  801447:	89 c3                	mov    %eax,%ebx
  801449:	89 c7                	mov    %eax,%edi
  80144b:	89 c6                	mov    %eax,%esi
  80144d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80144f:	5b                   	pop    %ebx
  801450:	5e                   	pop    %esi
  801451:	5f                   	pop    %edi
  801452:	5d                   	pop    %ebp
  801453:	c3                   	ret    

00801454 <sys_cgetc>:

int
sys_cgetc(void)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	57                   	push   %edi
  801458:	56                   	push   %esi
  801459:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80145a:	ba 00 00 00 00       	mov    $0x0,%edx
  80145f:	b8 01 00 00 00       	mov    $0x1,%eax
  801464:	89 d1                	mov    %edx,%ecx
  801466:	89 d3                	mov    %edx,%ebx
  801468:	89 d7                	mov    %edx,%edi
  80146a:	89 d6                	mov    %edx,%esi
  80146c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80146e:	5b                   	pop    %ebx
  80146f:	5e                   	pop    %esi
  801470:	5f                   	pop    %edi
  801471:	5d                   	pop    %ebp
  801472:	c3                   	ret    

00801473 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	57                   	push   %edi
  801477:	56                   	push   %esi
  801478:	53                   	push   %ebx
  801479:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80147c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801481:	b8 03 00 00 00       	mov    $0x3,%eax
  801486:	8b 55 08             	mov    0x8(%ebp),%edx
  801489:	89 cb                	mov    %ecx,%ebx
  80148b:	89 cf                	mov    %ecx,%edi
  80148d:	89 ce                	mov    %ecx,%esi
  80148f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801491:	85 c0                	test   %eax,%eax
  801493:	7e 28                	jle    8014bd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801495:	89 44 24 10          	mov    %eax,0x10(%esp)
  801499:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8014a0:	00 
  8014a1:	c7 44 24 08 7f 37 80 	movl   $0x80377f,0x8(%esp)
  8014a8:	00 
  8014a9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014b0:	00 
  8014b1:	c7 04 24 9c 37 80 00 	movl   $0x80379c,(%esp)
  8014b8:	e8 0b f5 ff ff       	call   8009c8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8014bd:	83 c4 2c             	add    $0x2c,%esp
  8014c0:	5b                   	pop    %ebx
  8014c1:	5e                   	pop    %esi
  8014c2:	5f                   	pop    %edi
  8014c3:	5d                   	pop    %ebp
  8014c4:	c3                   	ret    

008014c5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	57                   	push   %edi
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d0:	b8 02 00 00 00       	mov    $0x2,%eax
  8014d5:	89 d1                	mov    %edx,%ecx
  8014d7:	89 d3                	mov    %edx,%ebx
  8014d9:	89 d7                	mov    %edx,%edi
  8014db:	89 d6                	mov    %edx,%esi
  8014dd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8014df:	5b                   	pop    %ebx
  8014e0:	5e                   	pop    %esi
  8014e1:	5f                   	pop    %edi
  8014e2:	5d                   	pop    %ebp
  8014e3:	c3                   	ret    

008014e4 <sys_yield>:

void
sys_yield(void)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	57                   	push   %edi
  8014e8:	56                   	push   %esi
  8014e9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ef:	b8 0b 00 00 00       	mov    $0xb,%eax
  8014f4:	89 d1                	mov    %edx,%ecx
  8014f6:	89 d3                	mov    %edx,%ebx
  8014f8:	89 d7                	mov    %edx,%edi
  8014fa:	89 d6                	mov    %edx,%esi
  8014fc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8014fe:	5b                   	pop    %ebx
  8014ff:	5e                   	pop    %esi
  801500:	5f                   	pop    %edi
  801501:	5d                   	pop    %ebp
  801502:	c3                   	ret    

00801503 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	57                   	push   %edi
  801507:	56                   	push   %esi
  801508:	53                   	push   %ebx
  801509:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80150c:	be 00 00 00 00       	mov    $0x0,%esi
  801511:	b8 04 00 00 00       	mov    $0x4,%eax
  801516:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801519:	8b 55 08             	mov    0x8(%ebp),%edx
  80151c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80151f:	89 f7                	mov    %esi,%edi
  801521:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801523:	85 c0                	test   %eax,%eax
  801525:	7e 28                	jle    80154f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801527:	89 44 24 10          	mov    %eax,0x10(%esp)
  80152b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801532:	00 
  801533:	c7 44 24 08 7f 37 80 	movl   $0x80377f,0x8(%esp)
  80153a:	00 
  80153b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801542:	00 
  801543:	c7 04 24 9c 37 80 00 	movl   $0x80379c,(%esp)
  80154a:	e8 79 f4 ff ff       	call   8009c8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80154f:	83 c4 2c             	add    $0x2c,%esp
  801552:	5b                   	pop    %ebx
  801553:	5e                   	pop    %esi
  801554:	5f                   	pop    %edi
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	57                   	push   %edi
  80155b:	56                   	push   %esi
  80155c:	53                   	push   %ebx
  80155d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801560:	b8 05 00 00 00       	mov    $0x5,%eax
  801565:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801568:	8b 55 08             	mov    0x8(%ebp),%edx
  80156b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80156e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801571:	8b 75 18             	mov    0x18(%ebp),%esi
  801574:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801576:	85 c0                	test   %eax,%eax
  801578:	7e 28                	jle    8015a2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80157a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80157e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801585:	00 
  801586:	c7 44 24 08 7f 37 80 	movl   $0x80377f,0x8(%esp)
  80158d:	00 
  80158e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801595:	00 
  801596:	c7 04 24 9c 37 80 00 	movl   $0x80379c,(%esp)
  80159d:	e8 26 f4 ff ff       	call   8009c8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8015a2:	83 c4 2c             	add    $0x2c,%esp
  8015a5:	5b                   	pop    %ebx
  8015a6:	5e                   	pop    %esi
  8015a7:	5f                   	pop    %edi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	57                   	push   %edi
  8015ae:	56                   	push   %esi
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b8:	b8 06 00 00 00       	mov    $0x6,%eax
  8015bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c3:	89 df                	mov    %ebx,%edi
  8015c5:	89 de                	mov    %ebx,%esi
  8015c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	7e 28                	jle    8015f5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015d1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8015d8:	00 
  8015d9:	c7 44 24 08 7f 37 80 	movl   $0x80377f,0x8(%esp)
  8015e0:	00 
  8015e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015e8:	00 
  8015e9:	c7 04 24 9c 37 80 00 	movl   $0x80379c,(%esp)
  8015f0:	e8 d3 f3 ff ff       	call   8009c8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8015f5:	83 c4 2c             	add    $0x2c,%esp
  8015f8:	5b                   	pop    %ebx
  8015f9:	5e                   	pop    %esi
  8015fa:	5f                   	pop    %edi
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    

008015fd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	57                   	push   %edi
  801601:	56                   	push   %esi
  801602:	53                   	push   %ebx
  801603:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801606:	bb 00 00 00 00       	mov    $0x0,%ebx
  80160b:	b8 08 00 00 00       	mov    $0x8,%eax
  801610:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801613:	8b 55 08             	mov    0x8(%ebp),%edx
  801616:	89 df                	mov    %ebx,%edi
  801618:	89 de                	mov    %ebx,%esi
  80161a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80161c:	85 c0                	test   %eax,%eax
  80161e:	7e 28                	jle    801648 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801620:	89 44 24 10          	mov    %eax,0x10(%esp)
  801624:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80162b:	00 
  80162c:	c7 44 24 08 7f 37 80 	movl   $0x80377f,0x8(%esp)
  801633:	00 
  801634:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80163b:	00 
  80163c:	c7 04 24 9c 37 80 00 	movl   $0x80379c,(%esp)
  801643:	e8 80 f3 ff ff       	call   8009c8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801648:	83 c4 2c             	add    $0x2c,%esp
  80164b:	5b                   	pop    %ebx
  80164c:	5e                   	pop    %esi
  80164d:	5f                   	pop    %edi
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	57                   	push   %edi
  801654:	56                   	push   %esi
  801655:	53                   	push   %ebx
  801656:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801659:	bb 00 00 00 00       	mov    $0x0,%ebx
  80165e:	b8 09 00 00 00       	mov    $0x9,%eax
  801663:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801666:	8b 55 08             	mov    0x8(%ebp),%edx
  801669:	89 df                	mov    %ebx,%edi
  80166b:	89 de                	mov    %ebx,%esi
  80166d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80166f:	85 c0                	test   %eax,%eax
  801671:	7e 28                	jle    80169b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801673:	89 44 24 10          	mov    %eax,0x10(%esp)
  801677:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80167e:	00 
  80167f:	c7 44 24 08 7f 37 80 	movl   $0x80377f,0x8(%esp)
  801686:	00 
  801687:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80168e:	00 
  80168f:	c7 04 24 9c 37 80 00 	movl   $0x80379c,(%esp)
  801696:	e8 2d f3 ff ff       	call   8009c8 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80169b:	83 c4 2c             	add    $0x2c,%esp
  80169e:	5b                   	pop    %ebx
  80169f:	5e                   	pop    %esi
  8016a0:	5f                   	pop    %edi
  8016a1:	5d                   	pop    %ebp
  8016a2:	c3                   	ret    

008016a3 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	57                   	push   %edi
  8016a7:	56                   	push   %esi
  8016a8:	53                   	push   %ebx
  8016a9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8016b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bc:	89 df                	mov    %ebx,%edi
  8016be:	89 de                	mov    %ebx,%esi
  8016c0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	7e 28                	jle    8016ee <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016ca:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8016d1:	00 
  8016d2:	c7 44 24 08 7f 37 80 	movl   $0x80377f,0x8(%esp)
  8016d9:	00 
  8016da:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016e1:	00 
  8016e2:	c7 04 24 9c 37 80 00 	movl   $0x80379c,(%esp)
  8016e9:	e8 da f2 ff ff       	call   8009c8 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8016ee:	83 c4 2c             	add    $0x2c,%esp
  8016f1:	5b                   	pop    %ebx
  8016f2:	5e                   	pop    %esi
  8016f3:	5f                   	pop    %edi
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    

008016f6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	57                   	push   %edi
  8016fa:	56                   	push   %esi
  8016fb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016fc:	be 00 00 00 00       	mov    $0x0,%esi
  801701:	b8 0c 00 00 00       	mov    $0xc,%eax
  801706:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801709:	8b 55 08             	mov    0x8(%ebp),%edx
  80170c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80170f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801712:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801714:	5b                   	pop    %ebx
  801715:	5e                   	pop    %esi
  801716:	5f                   	pop    %edi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    

00801719 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	57                   	push   %edi
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
  80171f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801722:	b9 00 00 00 00       	mov    $0x0,%ecx
  801727:	b8 0d 00 00 00       	mov    $0xd,%eax
  80172c:	8b 55 08             	mov    0x8(%ebp),%edx
  80172f:	89 cb                	mov    %ecx,%ebx
  801731:	89 cf                	mov    %ecx,%edi
  801733:	89 ce                	mov    %ecx,%esi
  801735:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801737:	85 c0                	test   %eax,%eax
  801739:	7e 28                	jle    801763 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80173b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80173f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801746:	00 
  801747:	c7 44 24 08 7f 37 80 	movl   $0x80377f,0x8(%esp)
  80174e:	00 
  80174f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801756:	00 
  801757:	c7 04 24 9c 37 80 00 	movl   $0x80379c,(%esp)
  80175e:	e8 65 f2 ff ff       	call   8009c8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801763:	83 c4 2c             	add    $0x2c,%esp
  801766:	5b                   	pop    %ebx
  801767:	5e                   	pop    %esi
  801768:	5f                   	pop    %edi
  801769:	5d                   	pop    %ebp
  80176a:	c3                   	ret    

0080176b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	57                   	push   %edi
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801771:	ba 00 00 00 00       	mov    $0x0,%edx
  801776:	b8 0e 00 00 00       	mov    $0xe,%eax
  80177b:	89 d1                	mov    %edx,%ecx
  80177d:	89 d3                	mov    %edx,%ebx
  80177f:	89 d7                	mov    %edx,%edi
  801781:	89 d6                	mov    %edx,%esi
  801783:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801785:	5b                   	pop    %ebx
  801786:	5e                   	pop    %esi
  801787:	5f                   	pop    %edi
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    

0080178a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	57                   	push   %edi
  80178e:	56                   	push   %esi
  80178f:	53                   	push   %ebx
  801790:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801793:	bb 00 00 00 00       	mov    $0x0,%ebx
  801798:	b8 0f 00 00 00       	mov    $0xf,%eax
  80179d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a3:	89 df                	mov    %ebx,%edi
  8017a5:	89 de                	mov    %ebx,%esi
  8017a7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	7e 28                	jle    8017d5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ad:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017b1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8017b8:	00 
  8017b9:	c7 44 24 08 7f 37 80 	movl   $0x80377f,0x8(%esp)
  8017c0:	00 
  8017c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017c8:	00 
  8017c9:	c7 04 24 9c 37 80 00 	movl   $0x80379c,(%esp)
  8017d0:	e8 f3 f1 ff ff       	call   8009c8 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  8017d5:	83 c4 2c             	add    $0x2c,%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5e                   	pop    %esi
  8017da:	5f                   	pop    %edi
  8017db:	5d                   	pop    %ebp
  8017dc:	c3                   	ret    

008017dd <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	57                   	push   %edi
  8017e1:	56                   	push   %esi
  8017e2:	53                   	push   %ebx
  8017e3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017eb:	b8 10 00 00 00       	mov    $0x10,%eax
  8017f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f6:	89 df                	mov    %ebx,%edi
  8017f8:	89 de                	mov    %ebx,%esi
  8017fa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	7e 28                	jle    801828 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801800:	89 44 24 10          	mov    %eax,0x10(%esp)
  801804:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80180b:	00 
  80180c:	c7 44 24 08 7f 37 80 	movl   $0x80377f,0x8(%esp)
  801813:	00 
  801814:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80181b:	00 
  80181c:	c7 04 24 9c 37 80 00 	movl   $0x80379c,(%esp)
  801823:	e8 a0 f1 ff ff       	call   8009c8 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801828:	83 c4 2c             	add    $0x2c,%esp
  80182b:	5b                   	pop    %ebx
  80182c:	5e                   	pop    %esi
  80182d:	5f                   	pop    %edi
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    

00801830 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	53                   	push   %ebx
  801834:	83 ec 24             	sub    $0x24,%esp
  801837:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  80183a:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  80183c:	89 d3                	mov    %edx,%ebx
  80183e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  801844:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801848:	74 1a                	je     801864 <pgfault+0x34>
  80184a:	c1 ea 0c             	shr    $0xc,%edx
  80184d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801854:	a8 01                	test   $0x1,%al
  801856:	74 0c                	je     801864 <pgfault+0x34>
  801858:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80185f:	f6 c4 08             	test   $0x8,%ah
  801862:	75 1c                	jne    801880 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  801864:	c7 44 24 08 ac 37 80 	movl   $0x8037ac,0x8(%esp)
  80186b:	00 
  80186c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801873:	00 
  801874:	c7 04 24 fb 38 80 00 	movl   $0x8038fb,(%esp)
  80187b:	e8 48 f1 ff ff       	call   8009c8 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  801880:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801887:	00 
  801888:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80188f:	00 
  801890:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801897:	e8 67 fc ff ff       	call   801503 <sys_page_alloc>
  80189c:	85 c0                	test   %eax,%eax
  80189e:	79 1c                	jns    8018bc <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  8018a0:	c7 44 24 08 f0 37 80 	movl   $0x8037f0,0x8(%esp)
  8018a7:	00 
  8018a8:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8018af:	00 
  8018b0:	c7 04 24 fb 38 80 00 	movl   $0x8038fb,(%esp)
  8018b7:	e8 0c f1 ff ff       	call   8009c8 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  8018bc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8018c3:	00 
  8018c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018c8:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8018cf:	e8 18 fa ff ff       	call   8012ec <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  8018d4:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8018db:	00 
  8018dc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8018e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018e7:	00 
  8018e8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8018ef:	00 
  8018f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018f7:	e8 5b fc ff ff       	call   801557 <sys_page_map>
  8018fc:	85 c0                	test   %eax,%eax
  8018fe:	74 1c                	je     80191c <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  801900:	c7 44 24 08 06 39 80 	movl   $0x803906,0x8(%esp)
  801907:	00 
  801908:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80190f:	00 
  801910:	c7 04 24 fb 38 80 00 	movl   $0x8038fb,(%esp)
  801917:	e8 ac f0 ff ff       	call   8009c8 <_panic>
    sys_page_unmap(0,PFTEMP);
  80191c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801923:	00 
  801924:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80192b:	e8 7a fc ff ff       	call   8015aa <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  801930:	83 c4 24             	add    $0x24,%esp
  801933:	5b                   	pop    %ebx
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    

00801936 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	57                   	push   %edi
  80193a:	56                   	push   %esi
  80193b:	53                   	push   %ebx
  80193c:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  80193f:	c7 04 24 30 18 80 00 	movl   $0x801830,(%esp)
  801946:	e8 fb 15 00 00       	call   802f46 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80194b:	b8 07 00 00 00       	mov    $0x7,%eax
  801950:	cd 30                	int    $0x30
  801952:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801955:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801957:	bb 00 00 00 00       	mov    $0x0,%ebx
  80195c:	85 c0                	test   %eax,%eax
  80195e:	75 21                	jne    801981 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801960:	e8 60 fb ff ff       	call   8014c5 <sys_getenvid>
  801965:	25 ff 03 00 00       	and    $0x3ff,%eax
  80196a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80196d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801972:	a3 40 50 86 00       	mov    %eax,0x865040
		return 0;
  801977:	b8 00 00 00 00       	mov    $0x0,%eax
  80197c:	e9 de 01 00 00       	jmp    801b5f <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  801981:	89 d8                	mov    %ebx,%eax
  801983:	c1 e8 16             	shr    $0x16,%eax
  801986:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80198d:	a8 01                	test   $0x1,%al
  80198f:	0f 84 58 01 00 00    	je     801aed <fork+0x1b7>
  801995:	89 de                	mov    %ebx,%esi
  801997:	c1 ee 0c             	shr    $0xc,%esi
  80199a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8019a1:	83 e0 05             	and    $0x5,%eax
  8019a4:	83 f8 05             	cmp    $0x5,%eax
  8019a7:	0f 85 40 01 00 00    	jne    801aed <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  8019ad:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8019b4:	f6 c4 04             	test   $0x4,%ah
  8019b7:	74 4f                	je     801a08 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  8019b9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8019c0:	c1 e6 0c             	shl    $0xc,%esi
  8019c3:	25 07 0e 00 00       	and    $0xe07,%eax
  8019c8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019cc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019d0:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8019d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019df:	e8 73 fb ff ff       	call   801557 <sys_page_map>
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	0f 89 01 01 00 00    	jns    801aed <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  8019ec:	c7 44 24 08 10 38 80 	movl   $0x803810,0x8(%esp)
  8019f3:	00 
  8019f4:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  8019fb:	00 
  8019fc:	c7 04 24 fb 38 80 00 	movl   $0x8038fb,(%esp)
  801a03:	e8 c0 ef ff ff       	call   8009c8 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  801a08:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801a0f:	a8 02                	test   $0x2,%al
  801a11:	75 10                	jne    801a23 <fork+0xed>
  801a13:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801a1a:	f6 c4 08             	test   $0x8,%ah
  801a1d:	0f 84 87 00 00 00    	je     801aaa <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  801a23:	c1 e6 0c             	shl    $0xc,%esi
  801a26:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801a2d:	00 
  801a2e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a32:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801a36:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a41:	e8 11 fb ff ff       	call   801557 <sys_page_map>
  801a46:	85 c0                	test   %eax,%eax
  801a48:	79 1c                	jns    801a66 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  801a4a:	c7 44 24 08 48 38 80 	movl   $0x803848,0x8(%esp)
  801a51:	00 
  801a52:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801a59:	00 
  801a5a:	c7 04 24 fb 38 80 00 	movl   $0x8038fb,(%esp)
  801a61:	e8 62 ef ff ff       	call   8009c8 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  801a66:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801a6d:	00 
  801a6e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a72:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a79:	00 
  801a7a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a85:	e8 cd fa ff ff       	call   801557 <sys_page_map>
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	79 5f                	jns    801aed <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  801a8e:	c7 44 24 08 80 38 80 	movl   $0x803880,0x8(%esp)
  801a95:	00 
  801a96:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  801a9d:	00 
  801a9e:	c7 04 24 fb 38 80 00 	movl   $0x8038fb,(%esp)
  801aa5:	e8 1e ef ff ff       	call   8009c8 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  801aaa:	c1 e6 0c             	shl    $0xc,%esi
  801aad:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801ab4:	00 
  801ab5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ab9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801abd:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ac1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ac8:	e8 8a fa ff ff       	call   801557 <sys_page_map>
  801acd:	85 c0                	test   %eax,%eax
  801acf:	74 1c                	je     801aed <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801ad1:	c7 44 24 08 a8 38 80 	movl   $0x8038a8,0x8(%esp)
  801ad8:	00 
  801ad9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801ae0:	00 
  801ae1:	c7 04 24 fb 38 80 00 	movl   $0x8038fb,(%esp)
  801ae8:	e8 db ee ff ff       	call   8009c8 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  801aed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801af3:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801af9:	0f 85 82 fe ff ff    	jne    801981 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  801aff:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801b06:	00 
  801b07:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801b0e:	ee 
  801b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b12:	89 04 24             	mov    %eax,(%esp)
  801b15:	e8 e9 f9 ff ff       	call   801503 <sys_page_alloc>
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	79 1c                	jns    801b3a <fork+0x204>
      panic("sys_page_alloc failure in fork");
  801b1e:	c7 44 24 08 dc 38 80 	movl   $0x8038dc,0x8(%esp)
  801b25:	00 
  801b26:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  801b2d:	00 
  801b2e:	c7 04 24 fb 38 80 00 	movl   $0x8038fb,(%esp)
  801b35:	e8 8e ee ff ff       	call   8009c8 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  801b3a:	c7 44 24 04 b7 2f 80 	movl   $0x802fb7,0x4(%esp)
  801b41:	00 
  801b42:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801b45:	89 3c 24             	mov    %edi,(%esp)
  801b48:	e8 56 fb ff ff       	call   8016a3 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  801b4d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801b54:	00 
  801b55:	89 3c 24             	mov    %edi,(%esp)
  801b58:	e8 a0 fa ff ff       	call   8015fd <sys_env_set_status>
		return child;
  801b5d:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  801b5f:	83 c4 2c             	add    $0x2c,%esp
  801b62:	5b                   	pop    %ebx
  801b63:	5e                   	pop    %esi
  801b64:	5f                   	pop    %edi
  801b65:	5d                   	pop    %ebp
  801b66:	c3                   	ret    

00801b67 <sfork>:

// Challenge!
int
sfork(void)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801b6d:	c7 44 24 08 24 39 80 	movl   $0x803924,0x8(%esp)
  801b74:	00 
  801b75:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  801b7c:	00 
  801b7d:	c7 04 24 fb 38 80 00 	movl   $0x8038fb,(%esp)
  801b84:	e8 3f ee ff ff       	call   8009c8 <_panic>

00801b89 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	56                   	push   %esi
  801b8d:	53                   	push   %ebx
  801b8e:	83 ec 10             	sub    $0x10,%esp
  801b91:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b97:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  801b9a:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  801b9c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801ba1:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  801ba4:	89 04 24             	mov    %eax,(%esp)
  801ba7:	e8 6d fb ff ff       	call   801719 <sys_ipc_recv>
  801bac:	85 c0                	test   %eax,%eax
  801bae:	75 1e                	jne    801bce <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  801bb0:	85 db                	test   %ebx,%ebx
  801bb2:	74 0a                	je     801bbe <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  801bb4:	a1 40 50 86 00       	mov    0x865040,%eax
  801bb9:	8b 40 74             	mov    0x74(%eax),%eax
  801bbc:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  801bbe:	85 f6                	test   %esi,%esi
  801bc0:	74 22                	je     801be4 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  801bc2:	a1 40 50 86 00       	mov    0x865040,%eax
  801bc7:	8b 40 78             	mov    0x78(%eax),%eax
  801bca:	89 06                	mov    %eax,(%esi)
  801bcc:	eb 16                	jmp    801be4 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  801bce:	85 f6                	test   %esi,%esi
  801bd0:	74 06                	je     801bd8 <ipc_recv+0x4f>
				*perm_store = 0;
  801bd2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  801bd8:	85 db                	test   %ebx,%ebx
  801bda:	74 10                	je     801bec <ipc_recv+0x63>
				*from_env_store=0;
  801bdc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801be2:	eb 08                	jmp    801bec <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  801be4:	a1 40 50 86 00       	mov    0x865040,%eax
  801be9:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    

00801bf3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	57                   	push   %edi
  801bf7:	56                   	push   %esi
  801bf8:	53                   	push   %ebx
  801bf9:	83 ec 1c             	sub    $0x1c,%esp
  801bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c02:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  801c05:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  801c07:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  801c0c:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  801c0f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c17:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	89 04 24             	mov    %eax,(%esp)
  801c21:	e8 d0 fa ff ff       	call   8016f6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  801c26:	eb 1c                	jmp    801c44 <ipc_send+0x51>
	{
		sys_yield();
  801c28:	e8 b7 f8 ff ff       	call   8014e4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  801c2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c31:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c35:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	89 04 24             	mov    %eax,(%esp)
  801c3f:	e8 b2 fa ff ff       	call   8016f6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  801c44:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c47:	74 df                	je     801c28 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  801c49:	83 c4 1c             	add    $0x1c,%esp
  801c4c:	5b                   	pop    %ebx
  801c4d:	5e                   	pop    %esi
  801c4e:	5f                   	pop    %edi
  801c4f:	5d                   	pop    %ebp
  801c50:	c3                   	ret    

00801c51 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c5c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c5f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c65:	8b 52 50             	mov    0x50(%edx),%edx
  801c68:	39 ca                	cmp    %ecx,%edx
  801c6a:	75 0d                	jne    801c79 <ipc_find_env+0x28>
			return envs[i].env_id;
  801c6c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c6f:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801c74:	8b 40 40             	mov    0x40(%eax),%eax
  801c77:	eb 0e                	jmp    801c87 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801c79:	83 c0 01             	add    $0x1,%eax
  801c7c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c81:	75 d9                	jne    801c5c <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801c83:	66 b8 00 00          	mov    $0x0,%ax
}
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    
  801c89:	66 90                	xchg   %ax,%ax
  801c8b:	66 90                	xchg   %ax,%ax
  801c8d:	66 90                	xchg   %ax,%ax
  801c8f:	90                   	nop

00801c90 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	05 00 00 00 30       	add    $0x30000000,%eax
  801c9b:	c1 e8 0c             	shr    $0xc,%eax
}
  801c9e:	5d                   	pop    %ebp
  801c9f:	c3                   	ret    

00801ca0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801cab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cb0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    

00801cb7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cbd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cc2:	89 c2                	mov    %eax,%edx
  801cc4:	c1 ea 16             	shr    $0x16,%edx
  801cc7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801cce:	f6 c2 01             	test   $0x1,%dl
  801cd1:	74 11                	je     801ce4 <fd_alloc+0x2d>
  801cd3:	89 c2                	mov    %eax,%edx
  801cd5:	c1 ea 0c             	shr    $0xc,%edx
  801cd8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801cdf:	f6 c2 01             	test   $0x1,%dl
  801ce2:	75 09                	jne    801ced <fd_alloc+0x36>
			*fd_store = fd;
  801ce4:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ceb:	eb 17                	jmp    801d04 <fd_alloc+0x4d>
  801ced:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cf2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801cf7:	75 c9                	jne    801cc2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801cf9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801cff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    

00801d06 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d0c:	83 f8 1f             	cmp    $0x1f,%eax
  801d0f:	77 36                	ja     801d47 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801d11:	c1 e0 0c             	shl    $0xc,%eax
  801d14:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d19:	89 c2                	mov    %eax,%edx
  801d1b:	c1 ea 16             	shr    $0x16,%edx
  801d1e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801d25:	f6 c2 01             	test   $0x1,%dl
  801d28:	74 24                	je     801d4e <fd_lookup+0x48>
  801d2a:	89 c2                	mov    %eax,%edx
  801d2c:	c1 ea 0c             	shr    $0xc,%edx
  801d2f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d36:	f6 c2 01             	test   $0x1,%dl
  801d39:	74 1a                	je     801d55 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3e:	89 02                	mov    %eax,(%edx)
	return 0;
  801d40:	b8 00 00 00 00       	mov    $0x0,%eax
  801d45:	eb 13                	jmp    801d5a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d4c:	eb 0c                	jmp    801d5a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d53:	eb 05                	jmp    801d5a <fd_lookup+0x54>
  801d55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    

00801d5c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	83 ec 18             	sub    $0x18,%esp
  801d62:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801d65:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6a:	eb 13                	jmp    801d7f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  801d6c:	39 08                	cmp    %ecx,(%eax)
  801d6e:	75 0c                	jne    801d7c <dev_lookup+0x20>
			*dev = devtab[i];
  801d70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d73:	89 01                	mov    %eax,(%ecx)
			return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7a:	eb 38                	jmp    801db4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  801d7c:	83 c2 01             	add    $0x1,%edx
  801d7f:	8b 04 95 b8 39 80 00 	mov    0x8039b8(,%edx,4),%eax
  801d86:	85 c0                	test   %eax,%eax
  801d88:	75 e2                	jne    801d6c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801d8a:	a1 40 50 86 00       	mov    0x865040,%eax
  801d8f:	8b 40 48             	mov    0x48(%eax),%eax
  801d92:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9a:	c7 04 24 3c 39 80 00 	movl   $0x80393c,(%esp)
  801da1:	e8 1b ed ff ff       	call   800ac1 <cprintf>
	*dev = 0;
  801da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801daf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	56                   	push   %esi
  801dba:	53                   	push   %ebx
  801dbb:	83 ec 20             	sub    $0x20,%esp
  801dbe:	8b 75 08             	mov    0x8(%ebp),%esi
  801dc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801dc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dcb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801dd1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801dd4:	89 04 24             	mov    %eax,(%esp)
  801dd7:	e8 2a ff ff ff       	call   801d06 <fd_lookup>
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	78 05                	js     801de5 <fd_close+0x2f>
	    || fd != fd2)
  801de0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801de3:	74 0c                	je     801df1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801de5:	84 db                	test   %bl,%bl
  801de7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dec:	0f 44 c2             	cmove  %edx,%eax
  801def:	eb 3f                	jmp    801e30 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801df1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df8:	8b 06                	mov    (%esi),%eax
  801dfa:	89 04 24             	mov    %eax,(%esp)
  801dfd:	e8 5a ff ff ff       	call   801d5c <dev_lookup>
  801e02:	89 c3                	mov    %eax,%ebx
  801e04:	85 c0                	test   %eax,%eax
  801e06:	78 16                	js     801e1e <fd_close+0x68>
		if (dev->dev_close)
  801e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801e0e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801e13:	85 c0                	test   %eax,%eax
  801e15:	74 07                	je     801e1e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801e17:	89 34 24             	mov    %esi,(%esp)
  801e1a:	ff d0                	call   *%eax
  801e1c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e1e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e29:	e8 7c f7 ff ff       	call   8015aa <sys_page_unmap>
	return r;
  801e2e:	89 d8                	mov    %ebx,%eax
}
  801e30:	83 c4 20             	add    $0x20,%esp
  801e33:	5b                   	pop    %ebx
  801e34:	5e                   	pop    %esi
  801e35:	5d                   	pop    %ebp
  801e36:	c3                   	ret    

00801e37 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	89 04 24             	mov    %eax,(%esp)
  801e4a:	e8 b7 fe ff ff       	call   801d06 <fd_lookup>
  801e4f:	89 c2                	mov    %eax,%edx
  801e51:	85 d2                	test   %edx,%edx
  801e53:	78 13                	js     801e68 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801e55:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801e5c:	00 
  801e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e60:	89 04 24             	mov    %eax,(%esp)
  801e63:	e8 4e ff ff ff       	call   801db6 <fd_close>
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <close_all>:

void
close_all(void)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	53                   	push   %ebx
  801e6e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e71:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801e76:	89 1c 24             	mov    %ebx,(%esp)
  801e79:	e8 b9 ff ff ff       	call   801e37 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e7e:	83 c3 01             	add    $0x1,%ebx
  801e81:	83 fb 20             	cmp    $0x20,%ebx
  801e84:	75 f0                	jne    801e76 <close_all+0xc>
		close(i);
}
  801e86:	83 c4 14             	add    $0x14,%esp
  801e89:	5b                   	pop    %ebx
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    

00801e8c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	57                   	push   %edi
  801e90:	56                   	push   %esi
  801e91:	53                   	push   %ebx
  801e92:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e95:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801e98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	89 04 24             	mov    %eax,(%esp)
  801ea2:	e8 5f fe ff ff       	call   801d06 <fd_lookup>
  801ea7:	89 c2                	mov    %eax,%edx
  801ea9:	85 d2                	test   %edx,%edx
  801eab:	0f 88 e1 00 00 00    	js     801f92 <dup+0x106>
		return r;
	close(newfdnum);
  801eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb4:	89 04 24             	mov    %eax,(%esp)
  801eb7:	e8 7b ff ff ff       	call   801e37 <close>

	newfd = INDEX2FD(newfdnum);
  801ebc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ebf:	c1 e3 0c             	shl    $0xc,%ebx
  801ec2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ecb:	89 04 24             	mov    %eax,(%esp)
  801ece:	e8 cd fd ff ff       	call   801ca0 <fd2data>
  801ed3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801ed5:	89 1c 24             	mov    %ebx,(%esp)
  801ed8:	e8 c3 fd ff ff       	call   801ca0 <fd2data>
  801edd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801edf:	89 f0                	mov    %esi,%eax
  801ee1:	c1 e8 16             	shr    $0x16,%eax
  801ee4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801eeb:	a8 01                	test   $0x1,%al
  801eed:	74 43                	je     801f32 <dup+0xa6>
  801eef:	89 f0                	mov    %esi,%eax
  801ef1:	c1 e8 0c             	shr    $0xc,%eax
  801ef4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801efb:	f6 c2 01             	test   $0x1,%dl
  801efe:	74 32                	je     801f32 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f00:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f07:	25 07 0e 00 00       	and    $0xe07,%eax
  801f0c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801f10:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f14:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f1b:	00 
  801f1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f27:	e8 2b f6 ff ff       	call   801557 <sys_page_map>
  801f2c:	89 c6                	mov    %eax,%esi
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	78 3e                	js     801f70 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f35:	89 c2                	mov    %eax,%edx
  801f37:	c1 ea 0c             	shr    $0xc,%edx
  801f3a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f41:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801f47:	89 54 24 10          	mov    %edx,0x10(%esp)
  801f4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f56:	00 
  801f57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f62:	e8 f0 f5 ff ff       	call   801557 <sys_page_map>
  801f67:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801f69:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f6c:	85 f6                	test   %esi,%esi
  801f6e:	79 22                	jns    801f92 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801f70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f7b:	e8 2a f6 ff ff       	call   8015aa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801f80:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f8b:	e8 1a f6 ff ff       	call   8015aa <sys_page_unmap>
	return r;
  801f90:	89 f0                	mov    %esi,%eax
}
  801f92:	83 c4 3c             	add    $0x3c,%esp
  801f95:	5b                   	pop    %ebx
  801f96:	5e                   	pop    %esi
  801f97:	5f                   	pop    %edi
  801f98:	5d                   	pop    %ebp
  801f99:	c3                   	ret    

00801f9a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	53                   	push   %ebx
  801f9e:	83 ec 24             	sub    $0x24,%esp
  801fa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801fa4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fab:	89 1c 24             	mov    %ebx,(%esp)
  801fae:	e8 53 fd ff ff       	call   801d06 <fd_lookup>
  801fb3:	89 c2                	mov    %eax,%edx
  801fb5:	85 d2                	test   %edx,%edx
  801fb7:	78 6d                	js     802026 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc3:	8b 00                	mov    (%eax),%eax
  801fc5:	89 04 24             	mov    %eax,(%esp)
  801fc8:	e8 8f fd ff ff       	call   801d5c <dev_lookup>
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	78 55                	js     802026 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd4:	8b 50 08             	mov    0x8(%eax),%edx
  801fd7:	83 e2 03             	and    $0x3,%edx
  801fda:	83 fa 01             	cmp    $0x1,%edx
  801fdd:	75 23                	jne    802002 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801fdf:	a1 40 50 86 00       	mov    0x865040,%eax
  801fe4:	8b 40 48             	mov    0x48(%eax),%eax
  801fe7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801feb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fef:	c7 04 24 7d 39 80 00 	movl   $0x80397d,(%esp)
  801ff6:	e8 c6 ea ff ff       	call   800ac1 <cprintf>
		return -E_INVAL;
  801ffb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802000:	eb 24                	jmp    802026 <read+0x8c>
	}
	if (!dev->dev_read)
  802002:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802005:	8b 52 08             	mov    0x8(%edx),%edx
  802008:	85 d2                	test   %edx,%edx
  80200a:	74 15                	je     802021 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80200c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80200f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802013:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802016:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80201a:	89 04 24             	mov    %eax,(%esp)
  80201d:	ff d2                	call   *%edx
  80201f:	eb 05                	jmp    802026 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  802021:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  802026:	83 c4 24             	add    $0x24,%esp
  802029:	5b                   	pop    %ebx
  80202a:	5d                   	pop    %ebp
  80202b:	c3                   	ret    

0080202c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	57                   	push   %edi
  802030:	56                   	push   %esi
  802031:	53                   	push   %ebx
  802032:	83 ec 1c             	sub    $0x1c,%esp
  802035:	8b 7d 08             	mov    0x8(%ebp),%edi
  802038:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80203b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802040:	eb 23                	jmp    802065 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802042:	89 f0                	mov    %esi,%eax
  802044:	29 d8                	sub    %ebx,%eax
  802046:	89 44 24 08          	mov    %eax,0x8(%esp)
  80204a:	89 d8                	mov    %ebx,%eax
  80204c:	03 45 0c             	add    0xc(%ebp),%eax
  80204f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802053:	89 3c 24             	mov    %edi,(%esp)
  802056:	e8 3f ff ff ff       	call   801f9a <read>
		if (m < 0)
  80205b:	85 c0                	test   %eax,%eax
  80205d:	78 10                	js     80206f <readn+0x43>
			return m;
		if (m == 0)
  80205f:	85 c0                	test   %eax,%eax
  802061:	74 0a                	je     80206d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802063:	01 c3                	add    %eax,%ebx
  802065:	39 f3                	cmp    %esi,%ebx
  802067:	72 d9                	jb     802042 <readn+0x16>
  802069:	89 d8                	mov    %ebx,%eax
  80206b:	eb 02                	jmp    80206f <readn+0x43>
  80206d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80206f:	83 c4 1c             	add    $0x1c,%esp
  802072:	5b                   	pop    %ebx
  802073:	5e                   	pop    %esi
  802074:	5f                   	pop    %edi
  802075:	5d                   	pop    %ebp
  802076:	c3                   	ret    

00802077 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	53                   	push   %ebx
  80207b:	83 ec 24             	sub    $0x24,%esp
  80207e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802081:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802084:	89 44 24 04          	mov    %eax,0x4(%esp)
  802088:	89 1c 24             	mov    %ebx,(%esp)
  80208b:	e8 76 fc ff ff       	call   801d06 <fd_lookup>
  802090:	89 c2                	mov    %eax,%edx
  802092:	85 d2                	test   %edx,%edx
  802094:	78 68                	js     8020fe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802096:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802099:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a0:	8b 00                	mov    (%eax),%eax
  8020a2:	89 04 24             	mov    %eax,(%esp)
  8020a5:	e8 b2 fc ff ff       	call   801d5c <dev_lookup>
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	78 50                	js     8020fe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8020b5:	75 23                	jne    8020da <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8020b7:	a1 40 50 86 00       	mov    0x865040,%eax
  8020bc:	8b 40 48             	mov    0x48(%eax),%eax
  8020bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c7:	c7 04 24 99 39 80 00 	movl   $0x803999,(%esp)
  8020ce:	e8 ee e9 ff ff       	call   800ac1 <cprintf>
		return -E_INVAL;
  8020d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020d8:	eb 24                	jmp    8020fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020dd:	8b 52 0c             	mov    0xc(%edx),%edx
  8020e0:	85 d2                	test   %edx,%edx
  8020e2:	74 15                	je     8020f9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8020e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020f2:	89 04 24             	mov    %eax,(%esp)
  8020f5:	ff d2                	call   *%edx
  8020f7:	eb 05                	jmp    8020fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8020f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8020fe:	83 c4 24             	add    $0x24,%esp
  802101:	5b                   	pop    %ebx
  802102:	5d                   	pop    %ebp
  802103:	c3                   	ret    

00802104 <seek>:

int
seek(int fdnum, off_t offset)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80210a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80210d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	89 04 24             	mov    %eax,(%esp)
  802117:	e8 ea fb ff ff       	call   801d06 <fd_lookup>
  80211c:	85 c0                	test   %eax,%eax
  80211e:	78 0e                	js     80212e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  802120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802123:	8b 55 0c             	mov    0xc(%ebp),%edx
  802126:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	53                   	push   %ebx
  802134:	83 ec 24             	sub    $0x24,%esp
  802137:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80213a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80213d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802141:	89 1c 24             	mov    %ebx,(%esp)
  802144:	e8 bd fb ff ff       	call   801d06 <fd_lookup>
  802149:	89 c2                	mov    %eax,%edx
  80214b:	85 d2                	test   %edx,%edx
  80214d:	78 61                	js     8021b0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80214f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802152:	89 44 24 04          	mov    %eax,0x4(%esp)
  802156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802159:	8b 00                	mov    (%eax),%eax
  80215b:	89 04 24             	mov    %eax,(%esp)
  80215e:	e8 f9 fb ff ff       	call   801d5c <dev_lookup>
  802163:	85 c0                	test   %eax,%eax
  802165:	78 49                	js     8021b0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80216e:	75 23                	jne    802193 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802170:	a1 40 50 86 00       	mov    0x865040,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802175:	8b 40 48             	mov    0x48(%eax),%eax
  802178:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80217c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802180:	c7 04 24 5c 39 80 00 	movl   $0x80395c,(%esp)
  802187:	e8 35 e9 ff ff       	call   800ac1 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80218c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802191:	eb 1d                	jmp    8021b0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  802193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802196:	8b 52 18             	mov    0x18(%edx),%edx
  802199:	85 d2                	test   %edx,%edx
  80219b:	74 0e                	je     8021ab <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80219d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021a0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021a4:	89 04 24             	mov    %eax,(%esp)
  8021a7:	ff d2                	call   *%edx
  8021a9:	eb 05                	jmp    8021b0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8021ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8021b0:	83 c4 24             	add    $0x24,%esp
  8021b3:	5b                   	pop    %ebx
  8021b4:	5d                   	pop    %ebp
  8021b5:	c3                   	ret    

008021b6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	53                   	push   %ebx
  8021ba:	83 ec 24             	sub    $0x24,%esp
  8021bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	89 04 24             	mov    %eax,(%esp)
  8021cd:	e8 34 fb ff ff       	call   801d06 <fd_lookup>
  8021d2:	89 c2                	mov    %eax,%edx
  8021d4:	85 d2                	test   %edx,%edx
  8021d6:	78 52                	js     80222a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e2:	8b 00                	mov    (%eax),%eax
  8021e4:	89 04 24             	mov    %eax,(%esp)
  8021e7:	e8 70 fb ff ff       	call   801d5c <dev_lookup>
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	78 3a                	js     80222a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8021f7:	74 2c                	je     802225 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8021f9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8021fc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802203:	00 00 00 
	stat->st_isdir = 0;
  802206:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80220d:	00 00 00 
	stat->st_dev = dev;
  802210:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802216:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80221a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80221d:	89 14 24             	mov    %edx,(%esp)
  802220:	ff 50 14             	call   *0x14(%eax)
  802223:	eb 05                	jmp    80222a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  802225:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80222a:	83 c4 24             	add    $0x24,%esp
  80222d:	5b                   	pop    %ebx
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    

00802230 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	56                   	push   %esi
  802234:	53                   	push   %ebx
  802235:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802238:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80223f:	00 
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	89 04 24             	mov    %eax,(%esp)
  802246:	e8 28 02 00 00       	call   802473 <open>
  80224b:	89 c3                	mov    %eax,%ebx
  80224d:	85 db                	test   %ebx,%ebx
  80224f:	78 1b                	js     80226c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  802251:	8b 45 0c             	mov    0xc(%ebp),%eax
  802254:	89 44 24 04          	mov    %eax,0x4(%esp)
  802258:	89 1c 24             	mov    %ebx,(%esp)
  80225b:	e8 56 ff ff ff       	call   8021b6 <fstat>
  802260:	89 c6                	mov    %eax,%esi
	close(fd);
  802262:	89 1c 24             	mov    %ebx,(%esp)
  802265:	e8 cd fb ff ff       	call   801e37 <close>
	return r;
  80226a:	89 f0                	mov    %esi,%eax
}
  80226c:	83 c4 10             	add    $0x10,%esp
  80226f:	5b                   	pop    %ebx
  802270:	5e                   	pop    %esi
  802271:	5d                   	pop    %ebp
  802272:	c3                   	ret    

00802273 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	56                   	push   %esi
  802277:	53                   	push   %ebx
  802278:	83 ec 10             	sub    $0x10,%esp
  80227b:	89 c6                	mov    %eax,%esi
  80227d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80227f:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  802286:	75 11                	jne    802299 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802288:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80228f:	e8 bd f9 ff ff       	call   801c51 <ipc_find_env>
  802294:	a3 18 50 80 00       	mov    %eax,0x805018
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802299:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022a0:	00 
  8022a1:	c7 44 24 08 00 60 86 	movl   $0x866000,0x8(%esp)
  8022a8:	00 
  8022a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ad:	a1 18 50 80 00       	mov    0x805018,%eax
  8022b2:	89 04 24             	mov    %eax,(%esp)
  8022b5:	e8 39 f9 ff ff       	call   801bf3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8022ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022c1:	00 
  8022c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022cd:	e8 b7 f8 ff ff       	call   801b89 <ipc_recv>
}
  8022d2:	83 c4 10             	add    $0x10,%esp
  8022d5:	5b                   	pop    %ebx
  8022d6:	5e                   	pop    %esi
  8022d7:	5d                   	pop    %ebp
  8022d8:	c3                   	ret    

008022d9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e5:	a3 00 60 86 00       	mov    %eax,0x866000
	fsipcbuf.set_size.req_size = newsize;
  8022ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ed:	a3 04 60 86 00       	mov    %eax,0x866004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8022f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8022f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8022fc:	e8 72 ff ff ff       	call   802273 <fsipc>
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8b 40 0c             	mov    0xc(%eax),%eax
  80230f:	a3 00 60 86 00       	mov    %eax,0x866000
	return fsipc(FSREQ_FLUSH, NULL);
  802314:	ba 00 00 00 00       	mov    $0x0,%edx
  802319:	b8 06 00 00 00       	mov    $0x6,%eax
  80231e:	e8 50 ff ff ff       	call   802273 <fsipc>
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	53                   	push   %ebx
  802329:	83 ec 14             	sub    $0x14,%esp
  80232c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	8b 40 0c             	mov    0xc(%eax),%eax
  802335:	a3 00 60 86 00       	mov    %eax,0x866000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80233a:	ba 00 00 00 00       	mov    $0x0,%edx
  80233f:	b8 05 00 00 00       	mov    $0x5,%eax
  802344:	e8 2a ff ff ff       	call   802273 <fsipc>
  802349:	89 c2                	mov    %eax,%edx
  80234b:	85 d2                	test   %edx,%edx
  80234d:	78 2b                	js     80237a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80234f:	c7 44 24 04 00 60 86 	movl   $0x866000,0x4(%esp)
  802356:	00 
  802357:	89 1c 24             	mov    %ebx,(%esp)
  80235a:	e8 88 ed ff ff       	call   8010e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80235f:	a1 80 60 86 00       	mov    0x866080,%eax
  802364:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80236a:	a1 84 60 86 00       	mov    0x866084,%eax
  80236f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80237a:	83 c4 14             	add    $0x14,%esp
  80237d:	5b                   	pop    %ebx
  80237e:	5d                   	pop    %ebp
  80237f:	c3                   	ret    

00802380 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 18             	sub    $0x18,%esp
  802386:	8b 45 10             	mov    0x10(%ebp),%eax
  802389:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80238e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  802393:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  802396:	a3 04 60 86 00       	mov    %eax,0x866004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80239b:	8b 55 08             	mov    0x8(%ebp),%edx
  80239e:	8b 52 0c             	mov    0xc(%edx),%edx
  8023a1:	89 15 00 60 86 00    	mov    %edx,0x866000
    memmove(fsipcbuf.write.req_buf,buf,n);
  8023a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b2:	c7 04 24 08 60 86 00 	movl   $0x866008,(%esp)
  8023b9:	e8 c6 ee ff ff       	call   801284 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  8023be:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c3:	b8 04 00 00 00       	mov    $0x4,%eax
  8023c8:	e8 a6 fe ff ff       	call   802273 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	56                   	push   %esi
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 10             	sub    $0x10,%esp
  8023d7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e0:	a3 00 60 86 00       	mov    %eax,0x866000
	fsipcbuf.read.req_n = n;
  8023e5:	89 35 04 60 86 00    	mov    %esi,0x866004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8023eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8023f5:	e8 79 fe ff ff       	call   802273 <fsipc>
  8023fa:	89 c3                	mov    %eax,%ebx
  8023fc:	85 c0                	test   %eax,%eax
  8023fe:	78 6a                	js     80246a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802400:	39 c6                	cmp    %eax,%esi
  802402:	73 24                	jae    802428 <devfile_read+0x59>
  802404:	c7 44 24 0c cc 39 80 	movl   $0x8039cc,0xc(%esp)
  80240b:	00 
  80240c:	c7 44 24 08 d3 39 80 	movl   $0x8039d3,0x8(%esp)
  802413:	00 
  802414:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80241b:	00 
  80241c:	c7 04 24 e8 39 80 00 	movl   $0x8039e8,(%esp)
  802423:	e8 a0 e5 ff ff       	call   8009c8 <_panic>
	assert(r <= PGSIZE);
  802428:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80242d:	7e 24                	jle    802453 <devfile_read+0x84>
  80242f:	c7 44 24 0c f3 39 80 	movl   $0x8039f3,0xc(%esp)
  802436:	00 
  802437:	c7 44 24 08 d3 39 80 	movl   $0x8039d3,0x8(%esp)
  80243e:	00 
  80243f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802446:	00 
  802447:	c7 04 24 e8 39 80 00 	movl   $0x8039e8,(%esp)
  80244e:	e8 75 e5 ff ff       	call   8009c8 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802453:	89 44 24 08          	mov    %eax,0x8(%esp)
  802457:	c7 44 24 04 00 60 86 	movl   $0x866000,0x4(%esp)
  80245e:	00 
  80245f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802462:	89 04 24             	mov    %eax,(%esp)
  802465:	e8 1a ee ff ff       	call   801284 <memmove>
	return r;
}
  80246a:	89 d8                	mov    %ebx,%eax
  80246c:	83 c4 10             	add    $0x10,%esp
  80246f:	5b                   	pop    %ebx
  802470:	5e                   	pop    %esi
  802471:	5d                   	pop    %ebp
  802472:	c3                   	ret    

00802473 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
  802476:	53                   	push   %ebx
  802477:	83 ec 24             	sub    $0x24,%esp
  80247a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80247d:	89 1c 24             	mov    %ebx,(%esp)
  802480:	e8 2b ec ff ff       	call   8010b0 <strlen>
  802485:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80248a:	7f 60                	jg     8024ec <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80248c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80248f:	89 04 24             	mov    %eax,(%esp)
  802492:	e8 20 f8 ff ff       	call   801cb7 <fd_alloc>
  802497:	89 c2                	mov    %eax,%edx
  802499:	85 d2                	test   %edx,%edx
  80249b:	78 54                	js     8024f1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80249d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024a1:	c7 04 24 00 60 86 00 	movl   $0x866000,(%esp)
  8024a8:	e8 3a ec ff ff       	call   8010e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8024ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b0:	a3 00 64 86 00       	mov    %eax,0x866400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8024bd:	e8 b1 fd ff ff       	call   802273 <fsipc>
  8024c2:	89 c3                	mov    %eax,%ebx
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	79 17                	jns    8024df <open+0x6c>
		fd_close(fd, 0);
  8024c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8024cf:	00 
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	89 04 24             	mov    %eax,(%esp)
  8024d6:	e8 db f8 ff ff       	call   801db6 <fd_close>
		return r;
  8024db:	89 d8                	mov    %ebx,%eax
  8024dd:	eb 12                	jmp    8024f1 <open+0x7e>
	}

	return fd2num(fd);
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	89 04 24             	mov    %eax,(%esp)
  8024e5:	e8 a6 f7 ff ff       	call   801c90 <fd2num>
  8024ea:	eb 05                	jmp    8024f1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8024ec:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8024f1:	83 c4 24             	add    $0x24,%esp
  8024f4:	5b                   	pop    %ebx
  8024f5:	5d                   	pop    %ebp
  8024f6:	c3                   	ret    

008024f7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8024fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802502:	b8 08 00 00 00       	mov    $0x8,%eax
  802507:	e8 67 fd ff ff       	call   802273 <fsipc>
}
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    
  80250e:	66 90                	xchg   %ax,%ax

00802510 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802516:	c7 44 24 04 ff 39 80 	movl   $0x8039ff,0x4(%esp)
  80251d:	00 
  80251e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802521:	89 04 24             	mov    %eax,(%esp)
  802524:	e8 be eb ff ff       	call   8010e7 <strcpy>
	return 0;
}
  802529:	b8 00 00 00 00       	mov    $0x0,%eax
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
  802533:	53                   	push   %ebx
  802534:	83 ec 14             	sub    $0x14,%esp
  802537:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80253a:	89 1c 24             	mov    %ebx,(%esp)
  80253d:	e8 9c 0a 00 00       	call   802fde <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802542:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802547:	83 f8 01             	cmp    $0x1,%eax
  80254a:	75 0d                	jne    802559 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80254c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80254f:	89 04 24             	mov    %eax,(%esp)
  802552:	e8 29 03 00 00       	call   802880 <nsipc_close>
  802557:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802559:	89 d0                	mov    %edx,%eax
  80255b:	83 c4 14             	add    $0x14,%esp
  80255e:	5b                   	pop    %ebx
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    

00802561 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802567:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80256e:	00 
  80256f:	8b 45 10             	mov    0x10(%ebp),%eax
  802572:	89 44 24 08          	mov    %eax,0x8(%esp)
  802576:	8b 45 0c             	mov    0xc(%ebp),%eax
  802579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	8b 40 0c             	mov    0xc(%eax),%eax
  802583:	89 04 24             	mov    %eax,(%esp)
  802586:	e8 f0 03 00 00       	call   80297b <nsipc_send>
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
  802590:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802593:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80259a:	00 
  80259b:	8b 45 10             	mov    0x10(%ebp),%eax
  80259e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8025af:	89 04 24             	mov    %eax,(%esp)
  8025b2:	e8 44 03 00 00       	call   8028fb <nsipc_recv>
}
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
  8025bc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8025bf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8025c2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025c6:	89 04 24             	mov    %eax,(%esp)
  8025c9:	e8 38 f7 ff ff       	call   801d06 <fd_lookup>
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	78 17                	js     8025e9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8025db:	39 08                	cmp    %ecx,(%eax)
  8025dd:	75 05                	jne    8025e4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8025df:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e2:	eb 05                	jmp    8025e9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8025e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	56                   	push   %esi
  8025ef:	53                   	push   %ebx
  8025f0:	83 ec 20             	sub    $0x20,%esp
  8025f3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8025f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025f8:	89 04 24             	mov    %eax,(%esp)
  8025fb:	e8 b7 f6 ff ff       	call   801cb7 <fd_alloc>
  802600:	89 c3                	mov    %eax,%ebx
  802602:	85 c0                	test   %eax,%eax
  802604:	78 21                	js     802627 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802606:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80260d:	00 
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	89 44 24 04          	mov    %eax,0x4(%esp)
  802615:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80261c:	e8 e2 ee ff ff       	call   801503 <sys_page_alloc>
  802621:	89 c3                	mov    %eax,%ebx
  802623:	85 c0                	test   %eax,%eax
  802625:	79 0c                	jns    802633 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802627:	89 34 24             	mov    %esi,(%esp)
  80262a:	e8 51 02 00 00       	call   802880 <nsipc_close>
		return r;
  80262f:	89 d8                	mov    %ebx,%eax
  802631:	eb 20                	jmp    802653 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802633:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80263e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802641:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802648:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80264b:	89 14 24             	mov    %edx,(%esp)
  80264e:	e8 3d f6 ff ff       	call   801c90 <fd2num>
}
  802653:	83 c4 20             	add    $0x20,%esp
  802656:	5b                   	pop    %ebx
  802657:	5e                   	pop    %esi
  802658:	5d                   	pop    %ebp
  802659:	c3                   	ret    

0080265a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
  80265d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	e8 51 ff ff ff       	call   8025b9 <fd2sockid>
		return r;
  802668:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80266a:	85 c0                	test   %eax,%eax
  80266c:	78 23                	js     802691 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80266e:	8b 55 10             	mov    0x10(%ebp),%edx
  802671:	89 54 24 08          	mov    %edx,0x8(%esp)
  802675:	8b 55 0c             	mov    0xc(%ebp),%edx
  802678:	89 54 24 04          	mov    %edx,0x4(%esp)
  80267c:	89 04 24             	mov    %eax,(%esp)
  80267f:	e8 45 01 00 00       	call   8027c9 <nsipc_accept>
		return r;
  802684:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802686:	85 c0                	test   %eax,%eax
  802688:	78 07                	js     802691 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80268a:	e8 5c ff ff ff       	call   8025eb <alloc_sockfd>
  80268f:	89 c1                	mov    %eax,%ecx
}
  802691:	89 c8                	mov    %ecx,%eax
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	e8 16 ff ff ff       	call   8025b9 <fd2sockid>
  8026a3:	89 c2                	mov    %eax,%edx
  8026a5:	85 d2                	test   %edx,%edx
  8026a7:	78 16                	js     8026bf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8026a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b7:	89 14 24             	mov    %edx,(%esp)
  8026ba:	e8 60 01 00 00       	call   80281f <nsipc_bind>
}
  8026bf:	c9                   	leave  
  8026c0:	c3                   	ret    

008026c1 <shutdown>:

int
shutdown(int s, int how)
{
  8026c1:	55                   	push   %ebp
  8026c2:	89 e5                	mov    %esp,%ebp
  8026c4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	e8 ea fe ff ff       	call   8025b9 <fd2sockid>
  8026cf:	89 c2                	mov    %eax,%edx
  8026d1:	85 d2                	test   %edx,%edx
  8026d3:	78 0f                	js     8026e4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8026d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026dc:	89 14 24             	mov    %edx,(%esp)
  8026df:	e8 7a 01 00 00       	call   80285e <nsipc_shutdown>
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
  8026e9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8026ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ef:	e8 c5 fe ff ff       	call   8025b9 <fd2sockid>
  8026f4:	89 c2                	mov    %eax,%edx
  8026f6:	85 d2                	test   %edx,%edx
  8026f8:	78 16                	js     802710 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8026fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8026fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  802701:	8b 45 0c             	mov    0xc(%ebp),%eax
  802704:	89 44 24 04          	mov    %eax,0x4(%esp)
  802708:	89 14 24             	mov    %edx,(%esp)
  80270b:	e8 8a 01 00 00       	call   80289a <nsipc_connect>
}
  802710:	c9                   	leave  
  802711:	c3                   	ret    

00802712 <listen>:

int
listen(int s, int backlog)
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
  802715:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802718:	8b 45 08             	mov    0x8(%ebp),%eax
  80271b:	e8 99 fe ff ff       	call   8025b9 <fd2sockid>
  802720:	89 c2                	mov    %eax,%edx
  802722:	85 d2                	test   %edx,%edx
  802724:	78 0f                	js     802735 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802726:	8b 45 0c             	mov    0xc(%ebp),%eax
  802729:	89 44 24 04          	mov    %eax,0x4(%esp)
  80272d:	89 14 24             	mov    %edx,(%esp)
  802730:	e8 a4 01 00 00       	call   8028d9 <nsipc_listen>
}
  802735:	c9                   	leave  
  802736:	c3                   	ret    

00802737 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802737:	55                   	push   %ebp
  802738:	89 e5                	mov    %esp,%ebp
  80273a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80273d:	8b 45 10             	mov    0x10(%ebp),%eax
  802740:	89 44 24 08          	mov    %eax,0x8(%esp)
  802744:	8b 45 0c             	mov    0xc(%ebp),%eax
  802747:	89 44 24 04          	mov    %eax,0x4(%esp)
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	89 04 24             	mov    %eax,(%esp)
  802751:	e8 98 02 00 00       	call   8029ee <nsipc_socket>
  802756:	89 c2                	mov    %eax,%edx
  802758:	85 d2                	test   %edx,%edx
  80275a:	78 05                	js     802761 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80275c:	e8 8a fe ff ff       	call   8025eb <alloc_sockfd>
}
  802761:	c9                   	leave  
  802762:	c3                   	ret    

00802763 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	53                   	push   %ebx
  802767:	83 ec 14             	sub    $0x14,%esp
  80276a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80276c:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  802773:	75 11                	jne    802786 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802775:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80277c:	e8 d0 f4 ff ff       	call   801c51 <ipc_find_env>
  802781:	a3 1c 50 80 00       	mov    %eax,0x80501c
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802786:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80278d:	00 
  80278e:	c7 44 24 08 00 70 86 	movl   $0x867000,0x8(%esp)
  802795:	00 
  802796:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80279a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80279f:	89 04 24             	mov    %eax,(%esp)
  8027a2:	e8 4c f4 ff ff       	call   801bf3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8027a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8027ae:	00 
  8027af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8027b6:	00 
  8027b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027be:	e8 c6 f3 ff ff       	call   801b89 <ipc_recv>
}
  8027c3:	83 c4 14             	add    $0x14,%esp
  8027c6:	5b                   	pop    %ebx
  8027c7:	5d                   	pop    %ebp
  8027c8:	c3                   	ret    

008027c9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
  8027cc:	56                   	push   %esi
  8027cd:	53                   	push   %ebx
  8027ce:	83 ec 10             	sub    $0x10,%esp
  8027d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8027d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d7:	a3 00 70 86 00       	mov    %eax,0x867000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8027dc:	8b 06                	mov    (%esi),%eax
  8027de:	a3 04 70 86 00       	mov    %eax,0x867004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8027e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e8:	e8 76 ff ff ff       	call   802763 <nsipc>
  8027ed:	89 c3                	mov    %eax,%ebx
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	78 23                	js     802816 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8027f3:	a1 10 70 86 00       	mov    0x867010,%eax
  8027f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027fc:	c7 44 24 04 00 70 86 	movl   $0x867000,0x4(%esp)
  802803:	00 
  802804:	8b 45 0c             	mov    0xc(%ebp),%eax
  802807:	89 04 24             	mov    %eax,(%esp)
  80280a:	e8 75 ea ff ff       	call   801284 <memmove>
		*addrlen = ret->ret_addrlen;
  80280f:	a1 10 70 86 00       	mov    0x867010,%eax
  802814:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802816:	89 d8                	mov    %ebx,%eax
  802818:	83 c4 10             	add    $0x10,%esp
  80281b:	5b                   	pop    %ebx
  80281c:	5e                   	pop    %esi
  80281d:	5d                   	pop    %ebp
  80281e:	c3                   	ret    

0080281f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80281f:	55                   	push   %ebp
  802820:	89 e5                	mov    %esp,%ebp
  802822:	53                   	push   %ebx
  802823:	83 ec 14             	sub    $0x14,%esp
  802826:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	a3 00 70 86 00       	mov    %eax,0x867000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802831:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802835:	8b 45 0c             	mov    0xc(%ebp),%eax
  802838:	89 44 24 04          	mov    %eax,0x4(%esp)
  80283c:	c7 04 24 04 70 86 00 	movl   $0x867004,(%esp)
  802843:	e8 3c ea ff ff       	call   801284 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802848:	89 1d 14 70 86 00    	mov    %ebx,0x867014
	return nsipc(NSREQ_BIND);
  80284e:	b8 02 00 00 00       	mov    $0x2,%eax
  802853:	e8 0b ff ff ff       	call   802763 <nsipc>
}
  802858:	83 c4 14             	add    $0x14,%esp
  80285b:	5b                   	pop    %ebx
  80285c:	5d                   	pop    %ebp
  80285d:	c3                   	ret    

0080285e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	a3 00 70 86 00       	mov    %eax,0x867000
	nsipcbuf.shutdown.req_how = how;
  80286c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80286f:	a3 04 70 86 00       	mov    %eax,0x867004
	return nsipc(NSREQ_SHUTDOWN);
  802874:	b8 03 00 00 00       	mov    $0x3,%eax
  802879:	e8 e5 fe ff ff       	call   802763 <nsipc>
}
  80287e:	c9                   	leave  
  80287f:	c3                   	ret    

00802880 <nsipc_close>:

int
nsipc_close(int s)
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
  802883:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	a3 00 70 86 00       	mov    %eax,0x867000
	return nsipc(NSREQ_CLOSE);
  80288e:	b8 04 00 00 00       	mov    $0x4,%eax
  802893:	e8 cb fe ff ff       	call   802763 <nsipc>
}
  802898:	c9                   	leave  
  802899:	c3                   	ret    

0080289a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
  80289d:	53                   	push   %ebx
  80289e:	83 ec 14             	sub    $0x14,%esp
  8028a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8028a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a7:	a3 00 70 86 00       	mov    %eax,0x867000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8028ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b7:	c7 04 24 04 70 86 00 	movl   $0x867004,(%esp)
  8028be:	e8 c1 e9 ff ff       	call   801284 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8028c3:	89 1d 14 70 86 00    	mov    %ebx,0x867014
	return nsipc(NSREQ_CONNECT);
  8028c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8028ce:	e8 90 fe ff ff       	call   802763 <nsipc>
}
  8028d3:	83 c4 14             	add    $0x14,%esp
  8028d6:	5b                   	pop    %ebx
  8028d7:	5d                   	pop    %ebp
  8028d8:	c3                   	ret    

008028d9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
  8028dc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	a3 00 70 86 00       	mov    %eax,0x867000
	nsipcbuf.listen.req_backlog = backlog;
  8028e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ea:	a3 04 70 86 00       	mov    %eax,0x867004
	return nsipc(NSREQ_LISTEN);
  8028ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8028f4:	e8 6a fe ff ff       	call   802763 <nsipc>
}
  8028f9:	c9                   	leave  
  8028fa:	c3                   	ret    

008028fb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8028fb:	55                   	push   %ebp
  8028fc:	89 e5                	mov    %esp,%ebp
  8028fe:	56                   	push   %esi
  8028ff:	53                   	push   %ebx
  802900:	83 ec 10             	sub    $0x10,%esp
  802903:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802906:	8b 45 08             	mov    0x8(%ebp),%eax
  802909:	a3 00 70 86 00       	mov    %eax,0x867000
	nsipcbuf.recv.req_len = len;
  80290e:	89 35 04 70 86 00    	mov    %esi,0x867004
	nsipcbuf.recv.req_flags = flags;
  802914:	8b 45 14             	mov    0x14(%ebp),%eax
  802917:	a3 08 70 86 00       	mov    %eax,0x867008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80291c:	b8 07 00 00 00       	mov    $0x7,%eax
  802921:	e8 3d fe ff ff       	call   802763 <nsipc>
  802926:	89 c3                	mov    %eax,%ebx
  802928:	85 c0                	test   %eax,%eax
  80292a:	78 46                	js     802972 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80292c:	39 f0                	cmp    %esi,%eax
  80292e:	7f 07                	jg     802937 <nsipc_recv+0x3c>
  802930:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802935:	7e 24                	jle    80295b <nsipc_recv+0x60>
  802937:	c7 44 24 0c 0b 3a 80 	movl   $0x803a0b,0xc(%esp)
  80293e:	00 
  80293f:	c7 44 24 08 d3 39 80 	movl   $0x8039d3,0x8(%esp)
  802946:	00 
  802947:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80294e:	00 
  80294f:	c7 04 24 20 3a 80 00 	movl   $0x803a20,(%esp)
  802956:	e8 6d e0 ff ff       	call   8009c8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80295b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80295f:	c7 44 24 04 00 70 86 	movl   $0x867000,0x4(%esp)
  802966:	00 
  802967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80296a:	89 04 24             	mov    %eax,(%esp)
  80296d:	e8 12 e9 ff ff       	call   801284 <memmove>
	}

	return r;
}
  802972:	89 d8                	mov    %ebx,%eax
  802974:	83 c4 10             	add    $0x10,%esp
  802977:	5b                   	pop    %ebx
  802978:	5e                   	pop    %esi
  802979:	5d                   	pop    %ebp
  80297a:	c3                   	ret    

0080297b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80297b:	55                   	push   %ebp
  80297c:	89 e5                	mov    %esp,%ebp
  80297e:	53                   	push   %ebx
  80297f:	83 ec 14             	sub    $0x14,%esp
  802982:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	a3 00 70 86 00       	mov    %eax,0x867000
	assert(size < 1600);
  80298d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802993:	7e 24                	jle    8029b9 <nsipc_send+0x3e>
  802995:	c7 44 24 0c 2c 3a 80 	movl   $0x803a2c,0xc(%esp)
  80299c:	00 
  80299d:	c7 44 24 08 d3 39 80 	movl   $0x8039d3,0x8(%esp)
  8029a4:	00 
  8029a5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8029ac:	00 
  8029ad:	c7 04 24 20 3a 80 00 	movl   $0x803a20,(%esp)
  8029b4:	e8 0f e0 ff ff       	call   8009c8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8029b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c4:	c7 04 24 0c 70 86 00 	movl   $0x86700c,(%esp)
  8029cb:	e8 b4 e8 ff ff       	call   801284 <memmove>
	nsipcbuf.send.req_size = size;
  8029d0:	89 1d 04 70 86 00    	mov    %ebx,0x867004
	nsipcbuf.send.req_flags = flags;
  8029d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8029d9:	a3 08 70 86 00       	mov    %eax,0x867008
	return nsipc(NSREQ_SEND);
  8029de:	b8 08 00 00 00       	mov    $0x8,%eax
  8029e3:	e8 7b fd ff ff       	call   802763 <nsipc>
}
  8029e8:	83 c4 14             	add    $0x14,%esp
  8029eb:	5b                   	pop    %ebx
  8029ec:	5d                   	pop    %ebp
  8029ed:	c3                   	ret    

008029ee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8029ee:	55                   	push   %ebp
  8029ef:	89 e5                	mov    %esp,%ebp
  8029f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	a3 00 70 86 00       	mov    %eax,0x867000
	nsipcbuf.socket.req_type = type;
  8029fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ff:	a3 04 70 86 00       	mov    %eax,0x867004
	nsipcbuf.socket.req_protocol = protocol;
  802a04:	8b 45 10             	mov    0x10(%ebp),%eax
  802a07:	a3 08 70 86 00       	mov    %eax,0x867008
	return nsipc(NSREQ_SOCKET);
  802a0c:	b8 09 00 00 00       	mov    $0x9,%eax
  802a11:	e8 4d fd ff ff       	call   802763 <nsipc>
}
  802a16:	c9                   	leave  
  802a17:	c3                   	ret    

00802a18 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802a18:	55                   	push   %ebp
  802a19:	89 e5                	mov    %esp,%ebp
  802a1b:	56                   	push   %esi
  802a1c:	53                   	push   %ebx
  802a1d:	83 ec 10             	sub    $0x10,%esp
  802a20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802a23:	8b 45 08             	mov    0x8(%ebp),%eax
  802a26:	89 04 24             	mov    %eax,(%esp)
  802a29:	e8 72 f2 ff ff       	call   801ca0 <fd2data>
  802a2e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802a30:	c7 44 24 04 38 3a 80 	movl   $0x803a38,0x4(%esp)
  802a37:	00 
  802a38:	89 1c 24             	mov    %ebx,(%esp)
  802a3b:	e8 a7 e6 ff ff       	call   8010e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802a40:	8b 46 04             	mov    0x4(%esi),%eax
  802a43:	2b 06                	sub    (%esi),%eax
  802a45:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802a4b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802a52:	00 00 00 
	stat->st_dev = &devpipe;
  802a55:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802a5c:	40 80 00 
	return 0;
}
  802a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a64:	83 c4 10             	add    $0x10,%esp
  802a67:	5b                   	pop    %ebx
  802a68:	5e                   	pop    %esi
  802a69:	5d                   	pop    %ebp
  802a6a:	c3                   	ret    

00802a6b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802a6b:	55                   	push   %ebp
  802a6c:	89 e5                	mov    %esp,%ebp
  802a6e:	53                   	push   %ebx
  802a6f:	83 ec 14             	sub    $0x14,%esp
  802a72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802a75:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a80:	e8 25 eb ff ff       	call   8015aa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802a85:	89 1c 24             	mov    %ebx,(%esp)
  802a88:	e8 13 f2 ff ff       	call   801ca0 <fd2data>
  802a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a98:	e8 0d eb ff ff       	call   8015aa <sys_page_unmap>
}
  802a9d:	83 c4 14             	add    $0x14,%esp
  802aa0:	5b                   	pop    %ebx
  802aa1:	5d                   	pop    %ebp
  802aa2:	c3                   	ret    

00802aa3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802aa3:	55                   	push   %ebp
  802aa4:	89 e5                	mov    %esp,%ebp
  802aa6:	57                   	push   %edi
  802aa7:	56                   	push   %esi
  802aa8:	53                   	push   %ebx
  802aa9:	83 ec 2c             	sub    $0x2c,%esp
  802aac:	89 c6                	mov    %eax,%esi
  802aae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802ab1:	a1 40 50 86 00       	mov    0x865040,%eax
  802ab6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802ab9:	89 34 24             	mov    %esi,(%esp)
  802abc:	e8 1d 05 00 00       	call   802fde <pageref>
  802ac1:	89 c7                	mov    %eax,%edi
  802ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac6:	89 04 24             	mov    %eax,(%esp)
  802ac9:	e8 10 05 00 00       	call   802fde <pageref>
  802ace:	39 c7                	cmp    %eax,%edi
  802ad0:	0f 94 c2             	sete   %dl
  802ad3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802ad6:	8b 0d 40 50 86 00    	mov    0x865040,%ecx
  802adc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802adf:	39 fb                	cmp    %edi,%ebx
  802ae1:	74 21                	je     802b04 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802ae3:	84 d2                	test   %dl,%dl
  802ae5:	74 ca                	je     802ab1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802ae7:	8b 51 58             	mov    0x58(%ecx),%edx
  802aea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802aee:	89 54 24 08          	mov    %edx,0x8(%esp)
  802af2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802af6:	c7 04 24 3f 3a 80 00 	movl   $0x803a3f,(%esp)
  802afd:	e8 bf df ff ff       	call   800ac1 <cprintf>
  802b02:	eb ad                	jmp    802ab1 <_pipeisclosed+0xe>
	}
}
  802b04:	83 c4 2c             	add    $0x2c,%esp
  802b07:	5b                   	pop    %ebx
  802b08:	5e                   	pop    %esi
  802b09:	5f                   	pop    %edi
  802b0a:	5d                   	pop    %ebp
  802b0b:	c3                   	ret    

00802b0c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
  802b0f:	57                   	push   %edi
  802b10:	56                   	push   %esi
  802b11:	53                   	push   %ebx
  802b12:	83 ec 1c             	sub    $0x1c,%esp
  802b15:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802b18:	89 34 24             	mov    %esi,(%esp)
  802b1b:	e8 80 f1 ff ff       	call   801ca0 <fd2data>
  802b20:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802b22:	bf 00 00 00 00       	mov    $0x0,%edi
  802b27:	eb 45                	jmp    802b6e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802b29:	89 da                	mov    %ebx,%edx
  802b2b:	89 f0                	mov    %esi,%eax
  802b2d:	e8 71 ff ff ff       	call   802aa3 <_pipeisclosed>
  802b32:	85 c0                	test   %eax,%eax
  802b34:	75 41                	jne    802b77 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802b36:	e8 a9 e9 ff ff       	call   8014e4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802b3b:	8b 43 04             	mov    0x4(%ebx),%eax
  802b3e:	8b 0b                	mov    (%ebx),%ecx
  802b40:	8d 51 20             	lea    0x20(%ecx),%edx
  802b43:	39 d0                	cmp    %edx,%eax
  802b45:	73 e2                	jae    802b29 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802b47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b4a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802b4e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802b51:	99                   	cltd   
  802b52:	c1 ea 1b             	shr    $0x1b,%edx
  802b55:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802b58:	83 e1 1f             	and    $0x1f,%ecx
  802b5b:	29 d1                	sub    %edx,%ecx
  802b5d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802b61:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802b65:	83 c0 01             	add    $0x1,%eax
  802b68:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802b6b:	83 c7 01             	add    $0x1,%edi
  802b6e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802b71:	75 c8                	jne    802b3b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802b73:	89 f8                	mov    %edi,%eax
  802b75:	eb 05                	jmp    802b7c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802b77:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802b7c:	83 c4 1c             	add    $0x1c,%esp
  802b7f:	5b                   	pop    %ebx
  802b80:	5e                   	pop    %esi
  802b81:	5f                   	pop    %edi
  802b82:	5d                   	pop    %ebp
  802b83:	c3                   	ret    

00802b84 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802b84:	55                   	push   %ebp
  802b85:	89 e5                	mov    %esp,%ebp
  802b87:	57                   	push   %edi
  802b88:	56                   	push   %esi
  802b89:	53                   	push   %ebx
  802b8a:	83 ec 1c             	sub    $0x1c,%esp
  802b8d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802b90:	89 3c 24             	mov    %edi,(%esp)
  802b93:	e8 08 f1 ff ff       	call   801ca0 <fd2data>
  802b98:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802b9a:	be 00 00 00 00       	mov    $0x0,%esi
  802b9f:	eb 3d                	jmp    802bde <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802ba1:	85 f6                	test   %esi,%esi
  802ba3:	74 04                	je     802ba9 <devpipe_read+0x25>
				return i;
  802ba5:	89 f0                	mov    %esi,%eax
  802ba7:	eb 43                	jmp    802bec <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802ba9:	89 da                	mov    %ebx,%edx
  802bab:	89 f8                	mov    %edi,%eax
  802bad:	e8 f1 fe ff ff       	call   802aa3 <_pipeisclosed>
  802bb2:	85 c0                	test   %eax,%eax
  802bb4:	75 31                	jne    802be7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802bb6:	e8 29 e9 ff ff       	call   8014e4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802bbb:	8b 03                	mov    (%ebx),%eax
  802bbd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802bc0:	74 df                	je     802ba1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802bc2:	99                   	cltd   
  802bc3:	c1 ea 1b             	shr    $0x1b,%edx
  802bc6:	01 d0                	add    %edx,%eax
  802bc8:	83 e0 1f             	and    $0x1f,%eax
  802bcb:	29 d0                	sub    %edx,%eax
  802bcd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802bd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802bd5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802bd8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802bdb:	83 c6 01             	add    $0x1,%esi
  802bde:	3b 75 10             	cmp    0x10(%ebp),%esi
  802be1:	75 d8                	jne    802bbb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802be3:	89 f0                	mov    %esi,%eax
  802be5:	eb 05                	jmp    802bec <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802be7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802bec:	83 c4 1c             	add    $0x1c,%esp
  802bef:	5b                   	pop    %ebx
  802bf0:	5e                   	pop    %esi
  802bf1:	5f                   	pop    %edi
  802bf2:	5d                   	pop    %ebp
  802bf3:	c3                   	ret    

00802bf4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802bf4:	55                   	push   %ebp
  802bf5:	89 e5                	mov    %esp,%ebp
  802bf7:	56                   	push   %esi
  802bf8:	53                   	push   %ebx
  802bf9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802bfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bff:	89 04 24             	mov    %eax,(%esp)
  802c02:	e8 b0 f0 ff ff       	call   801cb7 <fd_alloc>
  802c07:	89 c2                	mov    %eax,%edx
  802c09:	85 d2                	test   %edx,%edx
  802c0b:	0f 88 4d 01 00 00    	js     802d5e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c11:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802c18:	00 
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c27:	e8 d7 e8 ff ff       	call   801503 <sys_page_alloc>
  802c2c:	89 c2                	mov    %eax,%edx
  802c2e:	85 d2                	test   %edx,%edx
  802c30:	0f 88 28 01 00 00    	js     802d5e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802c36:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802c39:	89 04 24             	mov    %eax,(%esp)
  802c3c:	e8 76 f0 ff ff       	call   801cb7 <fd_alloc>
  802c41:	89 c3                	mov    %eax,%ebx
  802c43:	85 c0                	test   %eax,%eax
  802c45:	0f 88 fe 00 00 00    	js     802d49 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c4b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802c52:	00 
  802c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c61:	e8 9d e8 ff ff       	call   801503 <sys_page_alloc>
  802c66:	89 c3                	mov    %eax,%ebx
  802c68:	85 c0                	test   %eax,%eax
  802c6a:	0f 88 d9 00 00 00    	js     802d49 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	89 04 24             	mov    %eax,(%esp)
  802c76:	e8 25 f0 ff ff       	call   801ca0 <fd2data>
  802c7b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c7d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802c84:	00 
  802c85:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c90:	e8 6e e8 ff ff       	call   801503 <sys_page_alloc>
  802c95:	89 c3                	mov    %eax,%ebx
  802c97:	85 c0                	test   %eax,%eax
  802c99:	0f 88 97 00 00 00    	js     802d36 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca2:	89 04 24             	mov    %eax,(%esp)
  802ca5:	e8 f6 ef ff ff       	call   801ca0 <fd2data>
  802caa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802cb1:	00 
  802cb2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802cb6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802cbd:	00 
  802cbe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802cc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cc9:	e8 89 e8 ff ff       	call   801557 <sys_page_map>
  802cce:	89 c3                	mov    %eax,%ebx
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	78 52                	js     802d26 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802cd4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802ce9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	89 04 24             	mov    %eax,(%esp)
  802d04:	e8 87 ef ff ff       	call   801c90 <fd2num>
  802d09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d0c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d11:	89 04 24             	mov    %eax,(%esp)
  802d14:	e8 77 ef ff ff       	call   801c90 <fd2num>
  802d19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d1c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d24:	eb 38                	jmp    802d5e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802d26:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d31:	e8 74 e8 ff ff       	call   8015aa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d44:	e8 61 e8 ff ff       	call   8015aa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d57:	e8 4e e8 ff ff       	call   8015aa <sys_page_unmap>
  802d5c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802d5e:	83 c4 30             	add    $0x30,%esp
  802d61:	5b                   	pop    %ebx
  802d62:	5e                   	pop    %esi
  802d63:	5d                   	pop    %ebp
  802d64:	c3                   	ret    

00802d65 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802d65:	55                   	push   %ebp
  802d66:	89 e5                	mov    %esp,%ebp
  802d68:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	89 04 24             	mov    %eax,(%esp)
  802d78:	e8 89 ef ff ff       	call   801d06 <fd_lookup>
  802d7d:	89 c2                	mov    %eax,%edx
  802d7f:	85 d2                	test   %edx,%edx
  802d81:	78 15                	js     802d98 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	89 04 24             	mov    %eax,(%esp)
  802d89:	e8 12 ef ff ff       	call   801ca0 <fd2data>
	return _pipeisclosed(fd, p);
  802d8e:	89 c2                	mov    %eax,%edx
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	e8 0b fd ff ff       	call   802aa3 <_pipeisclosed>
}
  802d98:	c9                   	leave  
  802d99:	c3                   	ret    
  802d9a:	66 90                	xchg   %ax,%ax
  802d9c:	66 90                	xchg   %ax,%ax
  802d9e:	66 90                	xchg   %ax,%ax

00802da0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802da3:	b8 00 00 00 00       	mov    $0x0,%eax
  802da8:	5d                   	pop    %ebp
  802da9:	c3                   	ret    

00802daa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802daa:	55                   	push   %ebp
  802dab:	89 e5                	mov    %esp,%ebp
  802dad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802db0:	c7 44 24 04 57 3a 80 	movl   $0x803a57,0x4(%esp)
  802db7:	00 
  802db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dbb:	89 04 24             	mov    %eax,(%esp)
  802dbe:	e8 24 e3 ff ff       	call   8010e7 <strcpy>
	return 0;
}
  802dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc8:	c9                   	leave  
  802dc9:	c3                   	ret    

00802dca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802dca:	55                   	push   %ebp
  802dcb:	89 e5                	mov    %esp,%ebp
  802dcd:	57                   	push   %edi
  802dce:	56                   	push   %esi
  802dcf:	53                   	push   %ebx
  802dd0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802dd6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802ddb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802de1:	eb 31                	jmp    802e14 <devcons_write+0x4a>
		m = n - tot;
  802de3:	8b 75 10             	mov    0x10(%ebp),%esi
  802de6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802de8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802deb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802df0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802df3:	89 74 24 08          	mov    %esi,0x8(%esp)
  802df7:	03 45 0c             	add    0xc(%ebp),%eax
  802dfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dfe:	89 3c 24             	mov    %edi,(%esp)
  802e01:	e8 7e e4 ff ff       	call   801284 <memmove>
		sys_cputs(buf, m);
  802e06:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e0a:	89 3c 24             	mov    %edi,(%esp)
  802e0d:	e8 24 e6 ff ff       	call   801436 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802e12:	01 f3                	add    %esi,%ebx
  802e14:	89 d8                	mov    %ebx,%eax
  802e16:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802e19:	72 c8                	jb     802de3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802e1b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802e21:	5b                   	pop    %ebx
  802e22:	5e                   	pop    %esi
  802e23:	5f                   	pop    %edi
  802e24:	5d                   	pop    %ebp
  802e25:	c3                   	ret    

00802e26 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802e26:	55                   	push   %ebp
  802e27:	89 e5                	mov    %esp,%ebp
  802e29:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802e2c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802e31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802e35:	75 07                	jne    802e3e <devcons_read+0x18>
  802e37:	eb 2a                	jmp    802e63 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802e39:	e8 a6 e6 ff ff       	call   8014e4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802e3e:	66 90                	xchg   %ax,%ax
  802e40:	e8 0f e6 ff ff       	call   801454 <sys_cgetc>
  802e45:	85 c0                	test   %eax,%eax
  802e47:	74 f0                	je     802e39 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	78 16                	js     802e63 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802e4d:	83 f8 04             	cmp    $0x4,%eax
  802e50:	74 0c                	je     802e5e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e55:	88 02                	mov    %al,(%edx)
	return 1;
  802e57:	b8 01 00 00 00       	mov    $0x1,%eax
  802e5c:	eb 05                	jmp    802e63 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802e5e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802e63:	c9                   	leave  
  802e64:	c3                   	ret    

00802e65 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802e65:	55                   	push   %ebp
  802e66:	89 e5                	mov    %esp,%ebp
  802e68:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802e71:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802e78:	00 
  802e79:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802e7c:	89 04 24             	mov    %eax,(%esp)
  802e7f:	e8 b2 e5 ff ff       	call   801436 <sys_cputs>
}
  802e84:	c9                   	leave  
  802e85:	c3                   	ret    

00802e86 <getchar>:

int
getchar(void)
{
  802e86:	55                   	push   %ebp
  802e87:	89 e5                	mov    %esp,%ebp
  802e89:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802e8c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802e93:	00 
  802e94:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802e97:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ea2:	e8 f3 f0 ff ff       	call   801f9a <read>
	if (r < 0)
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	78 0f                	js     802eba <getchar+0x34>
		return r;
	if (r < 1)
  802eab:	85 c0                	test   %eax,%eax
  802ead:	7e 06                	jle    802eb5 <getchar+0x2f>
		return -E_EOF;
	return c;
  802eaf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802eb3:	eb 05                	jmp    802eba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802eb5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802eba:	c9                   	leave  
  802ebb:	c3                   	ret    

00802ebc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802ebc:	55                   	push   %ebp
  802ebd:	89 e5                	mov    %esp,%ebp
  802ebf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ec2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ec5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	89 04 24             	mov    %eax,(%esp)
  802ecf:	e8 32 ee ff ff       	call   801d06 <fd_lookup>
  802ed4:	85 c0                	test   %eax,%eax
  802ed6:	78 11                	js     802ee9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802ee1:	39 10                	cmp    %edx,(%eax)
  802ee3:	0f 94 c0             	sete   %al
  802ee6:	0f b6 c0             	movzbl %al,%eax
}
  802ee9:	c9                   	leave  
  802eea:	c3                   	ret    

00802eeb <opencons>:

int
opencons(void)
{
  802eeb:	55                   	push   %ebp
  802eec:	89 e5                	mov    %esp,%ebp
  802eee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802ef1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ef4:	89 04 24             	mov    %eax,(%esp)
  802ef7:	e8 bb ed ff ff       	call   801cb7 <fd_alloc>
		return r;
  802efc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802efe:	85 c0                	test   %eax,%eax
  802f00:	78 40                	js     802f42 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802f02:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802f09:	00 
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f18:	e8 e6 e5 ff ff       	call   801503 <sys_page_alloc>
		return r;
  802f1d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802f1f:	85 c0                	test   %eax,%eax
  802f21:	78 1f                	js     802f42 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802f23:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802f38:	89 04 24             	mov    %eax,(%esp)
  802f3b:	e8 50 ed ff ff       	call   801c90 <fd2num>
  802f40:	89 c2                	mov    %eax,%edx
}
  802f42:	89 d0                	mov    %edx,%eax
  802f44:	c9                   	leave  
  802f45:	c3                   	ret    

00802f46 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802f46:	55                   	push   %ebp
  802f47:	89 e5                	mov    %esp,%ebp
  802f49:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802f4c:	83 3d 00 80 86 00 00 	cmpl   $0x0,0x868000
  802f53:	75 58                	jne    802fad <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  802f55:	a1 40 50 86 00       	mov    0x865040,%eax
  802f5a:	8b 40 48             	mov    0x48(%eax),%eax
  802f5d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802f64:	00 
  802f65:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802f6c:	ee 
  802f6d:	89 04 24             	mov    %eax,(%esp)
  802f70:	e8 8e e5 ff ff       	call   801503 <sys_page_alloc>
		if(return_code!=0)
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 1c                	je     802f95 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802f79:	c7 44 24 08 64 3a 80 	movl   $0x803a64,0x8(%esp)
  802f80:	00 
  802f81:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802f88:	00 
  802f89:	c7 04 24 c0 3a 80 00 	movl   $0x803ac0,(%esp)
  802f90:	e8 33 da ff ff       	call   8009c8 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  802f95:	a1 40 50 86 00       	mov    0x865040,%eax
  802f9a:	8b 40 48             	mov    0x48(%eax),%eax
  802f9d:	c7 44 24 04 b7 2f 80 	movl   $0x802fb7,0x4(%esp)
  802fa4:	00 
  802fa5:	89 04 24             	mov    %eax,(%esp)
  802fa8:	e8 f6 e6 ff ff       	call   8016a3 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	a3 00 80 86 00       	mov    %eax,0x868000
}
  802fb5:	c9                   	leave  
  802fb6:	c3                   	ret    

00802fb7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802fb7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802fb8:	a1 00 80 86 00       	mov    0x868000,%eax
	call *%eax
  802fbd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802fbf:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  802fc2:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  802fc4:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  802fc8:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  802fcc:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  802fcd:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  802fcf:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  802fd1:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  802fd5:	58                   	pop    %eax
	popl %eax;
  802fd6:	58                   	pop    %eax
	popal;
  802fd7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  802fd8:	83 c4 04             	add    $0x4,%esp
	popfl;
  802fdb:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802fdc:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  802fdd:	c3                   	ret    

00802fde <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802fde:	55                   	push   %ebp
  802fdf:	89 e5                	mov    %esp,%ebp
  802fe1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802fe4:	89 d0                	mov    %edx,%eax
  802fe6:	c1 e8 16             	shr    $0x16,%eax
  802fe9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ff0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ff5:	f6 c1 01             	test   $0x1,%cl
  802ff8:	74 1d                	je     803017 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802ffa:	c1 ea 0c             	shr    $0xc,%edx
  802ffd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803004:	f6 c2 01             	test   $0x1,%dl
  803007:	74 0e                	je     803017 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803009:	c1 ea 0c             	shr    $0xc,%edx
  80300c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803013:	ef 
  803014:	0f b7 c0             	movzwl %ax,%eax
}
  803017:	5d                   	pop    %ebp
  803018:	c3                   	ret    
  803019:	66 90                	xchg   %ax,%ax
  80301b:	66 90                	xchg   %ax,%ax
  80301d:	66 90                	xchg   %ax,%ax
  80301f:	90                   	nop

00803020 <__udivdi3>:
  803020:	55                   	push   %ebp
  803021:	57                   	push   %edi
  803022:	56                   	push   %esi
  803023:	83 ec 0c             	sub    $0xc,%esp
  803026:	8b 44 24 28          	mov    0x28(%esp),%eax
  80302a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80302e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803032:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803036:	85 c0                	test   %eax,%eax
  803038:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80303c:	89 ea                	mov    %ebp,%edx
  80303e:	89 0c 24             	mov    %ecx,(%esp)
  803041:	75 2d                	jne    803070 <__udivdi3+0x50>
  803043:	39 e9                	cmp    %ebp,%ecx
  803045:	77 61                	ja     8030a8 <__udivdi3+0x88>
  803047:	85 c9                	test   %ecx,%ecx
  803049:	89 ce                	mov    %ecx,%esi
  80304b:	75 0b                	jne    803058 <__udivdi3+0x38>
  80304d:	b8 01 00 00 00       	mov    $0x1,%eax
  803052:	31 d2                	xor    %edx,%edx
  803054:	f7 f1                	div    %ecx
  803056:	89 c6                	mov    %eax,%esi
  803058:	31 d2                	xor    %edx,%edx
  80305a:	89 e8                	mov    %ebp,%eax
  80305c:	f7 f6                	div    %esi
  80305e:	89 c5                	mov    %eax,%ebp
  803060:	89 f8                	mov    %edi,%eax
  803062:	f7 f6                	div    %esi
  803064:	89 ea                	mov    %ebp,%edx
  803066:	83 c4 0c             	add    $0xc,%esp
  803069:	5e                   	pop    %esi
  80306a:	5f                   	pop    %edi
  80306b:	5d                   	pop    %ebp
  80306c:	c3                   	ret    
  80306d:	8d 76 00             	lea    0x0(%esi),%esi
  803070:	39 e8                	cmp    %ebp,%eax
  803072:	77 24                	ja     803098 <__udivdi3+0x78>
  803074:	0f bd e8             	bsr    %eax,%ebp
  803077:	83 f5 1f             	xor    $0x1f,%ebp
  80307a:	75 3c                	jne    8030b8 <__udivdi3+0x98>
  80307c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803080:	39 34 24             	cmp    %esi,(%esp)
  803083:	0f 86 9f 00 00 00    	jbe    803128 <__udivdi3+0x108>
  803089:	39 d0                	cmp    %edx,%eax
  80308b:	0f 82 97 00 00 00    	jb     803128 <__udivdi3+0x108>
  803091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803098:	31 d2                	xor    %edx,%edx
  80309a:	31 c0                	xor    %eax,%eax
  80309c:	83 c4 0c             	add    $0xc,%esp
  80309f:	5e                   	pop    %esi
  8030a0:	5f                   	pop    %edi
  8030a1:	5d                   	pop    %ebp
  8030a2:	c3                   	ret    
  8030a3:	90                   	nop
  8030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8030a8:	89 f8                	mov    %edi,%eax
  8030aa:	f7 f1                	div    %ecx
  8030ac:	31 d2                	xor    %edx,%edx
  8030ae:	83 c4 0c             	add    $0xc,%esp
  8030b1:	5e                   	pop    %esi
  8030b2:	5f                   	pop    %edi
  8030b3:	5d                   	pop    %ebp
  8030b4:	c3                   	ret    
  8030b5:	8d 76 00             	lea    0x0(%esi),%esi
  8030b8:	89 e9                	mov    %ebp,%ecx
  8030ba:	8b 3c 24             	mov    (%esp),%edi
  8030bd:	d3 e0                	shl    %cl,%eax
  8030bf:	89 c6                	mov    %eax,%esi
  8030c1:	b8 20 00 00 00       	mov    $0x20,%eax
  8030c6:	29 e8                	sub    %ebp,%eax
  8030c8:	89 c1                	mov    %eax,%ecx
  8030ca:	d3 ef                	shr    %cl,%edi
  8030cc:	89 e9                	mov    %ebp,%ecx
  8030ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8030d2:	8b 3c 24             	mov    (%esp),%edi
  8030d5:	09 74 24 08          	or     %esi,0x8(%esp)
  8030d9:	89 d6                	mov    %edx,%esi
  8030db:	d3 e7                	shl    %cl,%edi
  8030dd:	89 c1                	mov    %eax,%ecx
  8030df:	89 3c 24             	mov    %edi,(%esp)
  8030e2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8030e6:	d3 ee                	shr    %cl,%esi
  8030e8:	89 e9                	mov    %ebp,%ecx
  8030ea:	d3 e2                	shl    %cl,%edx
  8030ec:	89 c1                	mov    %eax,%ecx
  8030ee:	d3 ef                	shr    %cl,%edi
  8030f0:	09 d7                	or     %edx,%edi
  8030f2:	89 f2                	mov    %esi,%edx
  8030f4:	89 f8                	mov    %edi,%eax
  8030f6:	f7 74 24 08          	divl   0x8(%esp)
  8030fa:	89 d6                	mov    %edx,%esi
  8030fc:	89 c7                	mov    %eax,%edi
  8030fe:	f7 24 24             	mull   (%esp)
  803101:	39 d6                	cmp    %edx,%esi
  803103:	89 14 24             	mov    %edx,(%esp)
  803106:	72 30                	jb     803138 <__udivdi3+0x118>
  803108:	8b 54 24 04          	mov    0x4(%esp),%edx
  80310c:	89 e9                	mov    %ebp,%ecx
  80310e:	d3 e2                	shl    %cl,%edx
  803110:	39 c2                	cmp    %eax,%edx
  803112:	73 05                	jae    803119 <__udivdi3+0xf9>
  803114:	3b 34 24             	cmp    (%esp),%esi
  803117:	74 1f                	je     803138 <__udivdi3+0x118>
  803119:	89 f8                	mov    %edi,%eax
  80311b:	31 d2                	xor    %edx,%edx
  80311d:	e9 7a ff ff ff       	jmp    80309c <__udivdi3+0x7c>
  803122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803128:	31 d2                	xor    %edx,%edx
  80312a:	b8 01 00 00 00       	mov    $0x1,%eax
  80312f:	e9 68 ff ff ff       	jmp    80309c <__udivdi3+0x7c>
  803134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803138:	8d 47 ff             	lea    -0x1(%edi),%eax
  80313b:	31 d2                	xor    %edx,%edx
  80313d:	83 c4 0c             	add    $0xc,%esp
  803140:	5e                   	pop    %esi
  803141:	5f                   	pop    %edi
  803142:	5d                   	pop    %ebp
  803143:	c3                   	ret    
  803144:	66 90                	xchg   %ax,%ax
  803146:	66 90                	xchg   %ax,%ax
  803148:	66 90                	xchg   %ax,%ax
  80314a:	66 90                	xchg   %ax,%ax
  80314c:	66 90                	xchg   %ax,%ax
  80314e:	66 90                	xchg   %ax,%ax

00803150 <__umoddi3>:
  803150:	55                   	push   %ebp
  803151:	57                   	push   %edi
  803152:	56                   	push   %esi
  803153:	83 ec 14             	sub    $0x14,%esp
  803156:	8b 44 24 28          	mov    0x28(%esp),%eax
  80315a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80315e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803162:	89 c7                	mov    %eax,%edi
  803164:	89 44 24 04          	mov    %eax,0x4(%esp)
  803168:	8b 44 24 30          	mov    0x30(%esp),%eax
  80316c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803170:	89 34 24             	mov    %esi,(%esp)
  803173:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803177:	85 c0                	test   %eax,%eax
  803179:	89 c2                	mov    %eax,%edx
  80317b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80317f:	75 17                	jne    803198 <__umoddi3+0x48>
  803181:	39 fe                	cmp    %edi,%esi
  803183:	76 4b                	jbe    8031d0 <__umoddi3+0x80>
  803185:	89 c8                	mov    %ecx,%eax
  803187:	89 fa                	mov    %edi,%edx
  803189:	f7 f6                	div    %esi
  80318b:	89 d0                	mov    %edx,%eax
  80318d:	31 d2                	xor    %edx,%edx
  80318f:	83 c4 14             	add    $0x14,%esp
  803192:	5e                   	pop    %esi
  803193:	5f                   	pop    %edi
  803194:	5d                   	pop    %ebp
  803195:	c3                   	ret    
  803196:	66 90                	xchg   %ax,%ax
  803198:	39 f8                	cmp    %edi,%eax
  80319a:	77 54                	ja     8031f0 <__umoddi3+0xa0>
  80319c:	0f bd e8             	bsr    %eax,%ebp
  80319f:	83 f5 1f             	xor    $0x1f,%ebp
  8031a2:	75 5c                	jne    803200 <__umoddi3+0xb0>
  8031a4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8031a8:	39 3c 24             	cmp    %edi,(%esp)
  8031ab:	0f 87 e7 00 00 00    	ja     803298 <__umoddi3+0x148>
  8031b1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8031b5:	29 f1                	sub    %esi,%ecx
  8031b7:	19 c7                	sbb    %eax,%edi
  8031b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031c1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031c5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8031c9:	83 c4 14             	add    $0x14,%esp
  8031cc:	5e                   	pop    %esi
  8031cd:	5f                   	pop    %edi
  8031ce:	5d                   	pop    %ebp
  8031cf:	c3                   	ret    
  8031d0:	85 f6                	test   %esi,%esi
  8031d2:	89 f5                	mov    %esi,%ebp
  8031d4:	75 0b                	jne    8031e1 <__umoddi3+0x91>
  8031d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031db:	31 d2                	xor    %edx,%edx
  8031dd:	f7 f6                	div    %esi
  8031df:	89 c5                	mov    %eax,%ebp
  8031e1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031e5:	31 d2                	xor    %edx,%edx
  8031e7:	f7 f5                	div    %ebp
  8031e9:	89 c8                	mov    %ecx,%eax
  8031eb:	f7 f5                	div    %ebp
  8031ed:	eb 9c                	jmp    80318b <__umoddi3+0x3b>
  8031ef:	90                   	nop
  8031f0:	89 c8                	mov    %ecx,%eax
  8031f2:	89 fa                	mov    %edi,%edx
  8031f4:	83 c4 14             	add    $0x14,%esp
  8031f7:	5e                   	pop    %esi
  8031f8:	5f                   	pop    %edi
  8031f9:	5d                   	pop    %ebp
  8031fa:	c3                   	ret    
  8031fb:	90                   	nop
  8031fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803200:	8b 04 24             	mov    (%esp),%eax
  803203:	be 20 00 00 00       	mov    $0x20,%esi
  803208:	89 e9                	mov    %ebp,%ecx
  80320a:	29 ee                	sub    %ebp,%esi
  80320c:	d3 e2                	shl    %cl,%edx
  80320e:	89 f1                	mov    %esi,%ecx
  803210:	d3 e8                	shr    %cl,%eax
  803212:	89 e9                	mov    %ebp,%ecx
  803214:	89 44 24 04          	mov    %eax,0x4(%esp)
  803218:	8b 04 24             	mov    (%esp),%eax
  80321b:	09 54 24 04          	or     %edx,0x4(%esp)
  80321f:	89 fa                	mov    %edi,%edx
  803221:	d3 e0                	shl    %cl,%eax
  803223:	89 f1                	mov    %esi,%ecx
  803225:	89 44 24 08          	mov    %eax,0x8(%esp)
  803229:	8b 44 24 10          	mov    0x10(%esp),%eax
  80322d:	d3 ea                	shr    %cl,%edx
  80322f:	89 e9                	mov    %ebp,%ecx
  803231:	d3 e7                	shl    %cl,%edi
  803233:	89 f1                	mov    %esi,%ecx
  803235:	d3 e8                	shr    %cl,%eax
  803237:	89 e9                	mov    %ebp,%ecx
  803239:	09 f8                	or     %edi,%eax
  80323b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80323f:	f7 74 24 04          	divl   0x4(%esp)
  803243:	d3 e7                	shl    %cl,%edi
  803245:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803249:	89 d7                	mov    %edx,%edi
  80324b:	f7 64 24 08          	mull   0x8(%esp)
  80324f:	39 d7                	cmp    %edx,%edi
  803251:	89 c1                	mov    %eax,%ecx
  803253:	89 14 24             	mov    %edx,(%esp)
  803256:	72 2c                	jb     803284 <__umoddi3+0x134>
  803258:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80325c:	72 22                	jb     803280 <__umoddi3+0x130>
  80325e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803262:	29 c8                	sub    %ecx,%eax
  803264:	19 d7                	sbb    %edx,%edi
  803266:	89 e9                	mov    %ebp,%ecx
  803268:	89 fa                	mov    %edi,%edx
  80326a:	d3 e8                	shr    %cl,%eax
  80326c:	89 f1                	mov    %esi,%ecx
  80326e:	d3 e2                	shl    %cl,%edx
  803270:	89 e9                	mov    %ebp,%ecx
  803272:	d3 ef                	shr    %cl,%edi
  803274:	09 d0                	or     %edx,%eax
  803276:	89 fa                	mov    %edi,%edx
  803278:	83 c4 14             	add    $0x14,%esp
  80327b:	5e                   	pop    %esi
  80327c:	5f                   	pop    %edi
  80327d:	5d                   	pop    %ebp
  80327e:	c3                   	ret    
  80327f:	90                   	nop
  803280:	39 d7                	cmp    %edx,%edi
  803282:	75 da                	jne    80325e <__umoddi3+0x10e>
  803284:	8b 14 24             	mov    (%esp),%edx
  803287:	89 c1                	mov    %eax,%ecx
  803289:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80328d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803291:	eb cb                	jmp    80325e <__umoddi3+0x10e>
  803293:	90                   	nop
  803294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803298:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80329c:	0f 82 0f ff ff ff    	jb     8031b1 <__umoddi3+0x61>
  8032a2:	e9 1a ff ff ff       	jmp    8031c1 <__umoddi3+0x71>
