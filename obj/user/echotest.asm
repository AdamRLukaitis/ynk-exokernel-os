
obj/user/echotest.debug:     file format elf32-i386


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
  80002c:	e8 dc 04 00 00       	call   80050d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003d:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  800044:	e8 d2 05 00 00       	call   80061b <cprintf>
	exit();
  800049:	e8 11 05 00 00       	call   80055f <exit>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <umain>:

void umain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	57                   	push   %edi
  800054:	56                   	push   %esi
  800055:	53                   	push   %ebx
  800056:	83 ec 5c             	sub    $0x5c,%esp
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	cprintf("Connecting to:\n");
  800059:	c7 04 24 84 2a 80 00 	movl   $0x802a84,(%esp)
  800060:	e8 b6 05 00 00       	call   80061b <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800065:	c7 04 24 94 2a 80 00 	movl   $0x802a94,(%esp)
  80006c:	e8 64 04 00 00       	call   8004d5 <inet_addr>
  800071:	89 44 24 08          	mov    %eax,0x8(%esp)
  800075:	c7 44 24 04 94 2a 80 	movl   $0x802a94,0x4(%esp)
  80007c:	00 
  80007d:	c7 04 24 9e 2a 80 00 	movl   $0x802a9e,(%esp)
  800084:	e8 92 05 00 00       	call   80061b <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800089:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800090:	00 
  800091:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800098:	00 
  800099:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8000a0:	e8 92 1d 00 00       	call   801e37 <socket>
  8000a5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000a8:	85 c0                	test   %eax,%eax
  8000aa:	79 0a                	jns    8000b6 <umain+0x66>
		die("Failed to create socket");
  8000ac:	b8 b3 2a 80 00       	mov    $0x802ab3,%eax
  8000b1:	e8 7d ff ff ff       	call   800033 <die>

	cprintf("opened socket\n");
  8000b6:	c7 04 24 cb 2a 80 00 	movl   $0x802acb,(%esp)
  8000bd:	e8 59 05 00 00       	call   80061b <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000c2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8000c9:	00 
  8000ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000d1:	00 
  8000d2:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000d5:	89 1c 24             	mov    %ebx,(%esp)
  8000d8:	e8 ba 0c 00 00       	call   800d97 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000dd:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000e1:	c7 04 24 94 2a 80 00 	movl   $0x802a94,(%esp)
  8000e8:	e8 e8 03 00 00       	call   8004d5 <inet_addr>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000f0:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000f7:	e8 aa 01 00 00       	call   8002a6 <htons>
  8000fc:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  800100:	c7 04 24 da 2a 80 00 	movl   $0x802ada,(%esp)
  800107:	e8 0f 05 00 00       	call   80061b <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  80010c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800113:	00 
  800114:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800118:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80011b:	89 04 24             	mov    %eax,(%esp)
  80011e:	e8 c3 1c 00 00       	call   801de6 <connect>
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0a                	jns    800131 <umain+0xe1>
		die("Failed to connect with server");
  800127:	b8 f7 2a 80 00       	mov    $0x802af7,%eax
  80012c:	e8 02 ff ff ff       	call   800033 <die>

	cprintf("connected to server\n");
  800131:	c7 04 24 15 2b 80 00 	movl   $0x802b15,(%esp)
  800138:	e8 de 04 00 00       	call   80061b <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80013d:	a1 00 40 80 00       	mov    0x804000,%eax
  800142:	89 04 24             	mov    %eax,(%esp)
  800145:	e8 c6 0a 00 00       	call   800c10 <strlen>
  80014a:	89 c7                	mov    %eax,%edi
  80014c:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  80014f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800153:	a1 00 40 80 00       	mov    0x804000,%eax
  800158:	89 44 24 04          	mov    %eax,0x4(%esp)
  80015c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80015f:	89 04 24             	mov    %eax,(%esp)
  800162:	e8 10 16 00 00       	call   801777 <write>
  800167:	39 f8                	cmp    %edi,%eax
  800169:	74 0a                	je     800175 <umain+0x125>
		die("Mismatch in number of sent bytes");
  80016b:	b8 44 2b 80 00       	mov    $0x802b44,%eax
  800170:	e8 be fe ff ff       	call   800033 <die>

	// Receive the word back from the server
	cprintf("Received: \n");
  800175:	c7 04 24 2a 2b 80 00 	movl   $0x802b2a,(%esp)
  80017c:	e8 9a 04 00 00       	call   80061b <cprintf>
{
	int sock;
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  800181:	be 00 00 00 00       	mov    $0x0,%esi

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800186:	8d 7d b8             	lea    -0x48(%ebp),%edi
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  800189:	eb 36                	jmp    8001c1 <umain+0x171>
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018b:	c7 44 24 08 1f 00 00 	movl   $0x1f,0x8(%esp)
  800192:	00 
  800193:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800197:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80019a:	89 04 24             	mov    %eax,(%esp)
  80019d:	e8 f8 14 00 00       	call   80169a <read>
  8001a2:	89 c3                	mov    %eax,%ebx
  8001a4:	85 c0                	test   %eax,%eax
  8001a6:	7f 0a                	jg     8001b2 <umain+0x162>
			die("Failed to receive bytes from server");
  8001a8:	b8 68 2b 80 00       	mov    $0x802b68,%eax
  8001ad:	e8 81 fe ff ff       	call   800033 <die>
		}
		received += bytes;
  8001b2:	01 de                	add    %ebx,%esi
		buffer[bytes] = '\0';        // Assure null terminated string
  8001b4:	c6 44 1d b8 00       	movb   $0x0,-0x48(%ebp,%ebx,1)
		cprintf(buffer);
  8001b9:	89 3c 24             	mov    %edi,(%esp)
  8001bc:	e8 5a 04 00 00       	call   80061b <cprintf>
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  8001c1:	39 75 b0             	cmp    %esi,-0x50(%ebp)
  8001c4:	77 c5                	ja     80018b <umain+0x13b>
		}
		received += bytes;
		buffer[bytes] = '\0';        // Assure null terminated string
		cprintf(buffer);
	}
	cprintf("\n");
  8001c6:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  8001cd:	e8 49 04 00 00       	call   80061b <cprintf>

	close(sock);
  8001d2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	e8 5a 13 00 00       	call   801537 <close>
}
  8001dd:	83 c4 5c             	add    $0x5c,%esp
  8001e0:	5b                   	pop    %ebx
  8001e1:	5e                   	pop    %esi
  8001e2:	5f                   	pop    %edi
  8001e3:	5d                   	pop    %ebp
  8001e4:	c3                   	ret    
  8001e5:	66 90                	xchg   %ax,%ax
  8001e7:	66 90                	xchg   %ax,%ax
  8001e9:	66 90                	xchg   %ax,%ax
  8001eb:	66 90                	xchg   %ax,%ax
  8001ed:	66 90                	xchg   %ax,%ax
  8001ef:	90                   	nop

008001f0 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8001ff:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800203:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800206:	c7 45 dc 00 50 80 00 	movl   $0x805000,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80020d:	be 00 00 00 00       	mov    $0x0,%esi
  800212:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800215:	eb 02                	jmp    800219 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800217:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800219:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80021c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80021f:	0f b6 c2             	movzbl %dl,%eax
  800222:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  800225:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  800228:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80022b:	66 c1 e8 0b          	shr    $0xb,%ax
  80022f:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800231:	8d 4e 01             	lea    0x1(%esi),%ecx
  800234:	89 f3                	mov    %esi,%ebx
  800236:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800239:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  80023c:	01 ff                	add    %edi,%edi
  80023e:	89 fb                	mov    %edi,%ebx
  800240:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  800242:	83 c2 30             	add    $0x30,%edx
  800245:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  800249:	84 c0                	test   %al,%al
  80024b:	75 ca                	jne    800217 <inet_ntoa+0x27>
  80024d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800250:	89 c8                	mov    %ecx,%eax
  800252:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800255:	89 cf                	mov    %ecx,%edi
  800257:	eb 0d                	jmp    800266 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  800259:	0f b6 f0             	movzbl %al,%esi
  80025c:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  800261:	88 0a                	mov    %cl,(%edx)
  800263:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  800266:	83 e8 01             	sub    $0x1,%eax
  800269:	3c ff                	cmp    $0xff,%al
  80026b:	75 ec                	jne    800259 <inet_ntoa+0x69>
  80026d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800270:	89 f9                	mov    %edi,%ecx
  800272:	0f b6 c9             	movzbl %cl,%ecx
  800275:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  800278:	8d 41 01             	lea    0x1(%ecx),%eax
  80027b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  80027e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800282:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  800286:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  80028a:	77 0a                	ja     800296 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  80028c:	c6 01 2e             	movb   $0x2e,(%ecx)
  80028f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800294:	eb 81                	jmp    800217 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  800296:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  800299:	b8 00 50 80 00       	mov    $0x805000,%eax
  80029e:	83 c4 19             	add    $0x19,%esp
  8002a1:	5b                   	pop    %ebx
  8002a2:	5e                   	pop    %esi
  8002a3:	5f                   	pop    %edi
  8002a4:	5d                   	pop    %ebp
  8002a5:	c3                   	ret    

008002a6 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002a9:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002ad:	66 c1 c0 08          	rol    $0x8,%ax
}
  8002b1:	5d                   	pop    %ebp
  8002b2:	c3                   	ret    

008002b3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002b6:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002ba:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002c6:	89 d1                	mov    %edx,%ecx
  8002c8:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8002cb:	89 d0                	mov    %edx,%eax
  8002cd:	c1 e0 18             	shl    $0x18,%eax
  8002d0:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002d2:	89 d1                	mov    %edx,%ecx
  8002d4:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8002da:	c1 e1 08             	shl    $0x8,%ecx
  8002dd:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  8002df:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  8002e5:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8002e8:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8002ea:	5d                   	pop    %ebp
  8002eb:	c3                   	ret    

008002ec <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	57                   	push   %edi
  8002f0:	56                   	push   %esi
  8002f1:	53                   	push   %ebx
  8002f2:	83 ec 20             	sub    $0x20,%esp
  8002f5:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  8002f8:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  8002fb:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8002fe:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800301:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800304:	80 f9 09             	cmp    $0x9,%cl
  800307:	0f 87 a6 01 00 00    	ja     8004b3 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80030d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800314:	83 fa 30             	cmp    $0x30,%edx
  800317:	75 2b                	jne    800344 <inet_aton+0x58>
      c = *++cp;
  800319:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80031d:	89 d1                	mov    %edx,%ecx
  80031f:	83 e1 df             	and    $0xffffffdf,%ecx
  800322:	80 f9 58             	cmp    $0x58,%cl
  800325:	74 0f                	je     800336 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  800327:	83 c0 01             	add    $0x1,%eax
  80032a:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  80032d:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800334:	eb 0e                	jmp    800344 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  800336:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80033a:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80033d:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800344:	83 c0 01             	add    $0x1,%eax
  800347:	bf 00 00 00 00       	mov    $0x0,%edi
  80034c:	eb 03                	jmp    800351 <inet_aton+0x65>
  80034e:	83 c0 01             	add    $0x1,%eax
  800351:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800354:	89 d3                	mov    %edx,%ebx
  800356:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800359:	80 f9 09             	cmp    $0x9,%cl
  80035c:	77 0d                	ja     80036b <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  80035e:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  800362:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800366:	0f be 10             	movsbl (%eax),%edx
  800369:	eb e3                	jmp    80034e <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  80036b:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80036f:	75 30                	jne    8003a1 <inet_aton+0xb5>
  800371:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  800374:	88 4d df             	mov    %cl,-0x21(%ebp)
  800377:	89 d1                	mov    %edx,%ecx
  800379:	83 e1 df             	and    $0xffffffdf,%ecx
  80037c:	83 e9 41             	sub    $0x41,%ecx
  80037f:	80 f9 05             	cmp    $0x5,%cl
  800382:	77 23                	ja     8003a7 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800384:	89 fb                	mov    %edi,%ebx
  800386:	c1 e3 04             	shl    $0x4,%ebx
  800389:	8d 7a 0a             	lea    0xa(%edx),%edi
  80038c:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  800390:	19 c9                	sbb    %ecx,%ecx
  800392:	83 e1 20             	and    $0x20,%ecx
  800395:	83 c1 41             	add    $0x41,%ecx
  800398:	29 cf                	sub    %ecx,%edi
  80039a:	09 df                	or     %ebx,%edi
        c = *++cp;
  80039c:	0f be 10             	movsbl (%eax),%edx
  80039f:	eb ad                	jmp    80034e <inet_aton+0x62>
  8003a1:	89 d0                	mov    %edx,%eax
  8003a3:	89 f9                	mov    %edi,%ecx
  8003a5:	eb 04                	jmp    8003ab <inet_aton+0xbf>
  8003a7:	89 d0                	mov    %edx,%eax
  8003a9:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  8003ab:	83 f8 2e             	cmp    $0x2e,%eax
  8003ae:	75 22                	jne    8003d2 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8003b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8003b3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8003b6:	0f 84 fe 00 00 00    	je     8004ba <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  8003bc:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  8003c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c3:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  8003c6:	8d 46 01             	lea    0x1(%esi),%eax
  8003c9:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  8003cd:	e9 2f ff ff ff       	jmp    800301 <inet_aton+0x15>
  8003d2:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003d4:	85 d2                	test   %edx,%edx
  8003d6:	74 27                	je     8003ff <inet_aton+0x113>
    return (0);
  8003d8:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003dd:	80 fb 1f             	cmp    $0x1f,%bl
  8003e0:	0f 86 e7 00 00 00    	jbe    8004cd <inet_aton+0x1e1>
  8003e6:	84 d2                	test   %dl,%dl
  8003e8:	0f 88 d3 00 00 00    	js     8004c1 <inet_aton+0x1d5>
  8003ee:	83 fa 20             	cmp    $0x20,%edx
  8003f1:	74 0c                	je     8003ff <inet_aton+0x113>
  8003f3:	83 ea 09             	sub    $0x9,%edx
  8003f6:	83 fa 04             	cmp    $0x4,%edx
  8003f9:	0f 87 ce 00 00 00    	ja     8004cd <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  8003ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800402:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800405:	29 c2                	sub    %eax,%edx
  800407:	c1 fa 02             	sar    $0x2,%edx
  80040a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80040d:	83 fa 02             	cmp    $0x2,%edx
  800410:	74 22                	je     800434 <inet_aton+0x148>
  800412:	83 fa 02             	cmp    $0x2,%edx
  800415:	7f 0f                	jg     800426 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800417:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80041c:	85 d2                	test   %edx,%edx
  80041e:	0f 84 a9 00 00 00    	je     8004cd <inet_aton+0x1e1>
  800424:	eb 73                	jmp    800499 <inet_aton+0x1ad>
  800426:	83 fa 03             	cmp    $0x3,%edx
  800429:	74 26                	je     800451 <inet_aton+0x165>
  80042b:	83 fa 04             	cmp    $0x4,%edx
  80042e:	66 90                	xchg   %ax,%ax
  800430:	74 40                	je     800472 <inet_aton+0x186>
  800432:	eb 65                	jmp    800499 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  800434:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800439:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  80043f:	0f 87 88 00 00 00    	ja     8004cd <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  800445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800448:	c1 e0 18             	shl    $0x18,%eax
  80044b:	89 cf                	mov    %ecx,%edi
  80044d:	09 c7                	or     %eax,%edi
    break;
  80044f:	eb 48                	jmp    800499 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  800451:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800456:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  80045c:	77 6f                	ja     8004cd <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80045e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800461:	c1 e2 10             	shl    $0x10,%edx
  800464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800467:	c1 e0 18             	shl    $0x18,%eax
  80046a:	09 d0                	or     %edx,%eax
  80046c:	09 c8                	or     %ecx,%eax
  80046e:	89 c7                	mov    %eax,%edi
    break;
  800470:	eb 27                	jmp    800499 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  800477:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  80047d:	77 4e                	ja     8004cd <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80047f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800482:	c1 e2 10             	shl    $0x10,%edx
  800485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800488:	c1 e0 18             	shl    $0x18,%eax
  80048b:	09 c2                	or     %eax,%edx
  80048d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800490:	c1 e0 08             	shl    $0x8,%eax
  800493:	09 d0                	or     %edx,%eax
  800495:	09 c8                	or     %ecx,%eax
  800497:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  800499:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80049d:	74 29                	je     8004c8 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  80049f:	89 3c 24             	mov    %edi,(%esp)
  8004a2:	e8 19 fe ff ff       	call   8002c0 <htonl>
  8004a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004aa:	89 06                	mov    %eax,(%esi)
  return (1);
  8004ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8004b1:	eb 1a                	jmp    8004cd <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  8004b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b8:	eb 13                	jmp    8004cd <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  8004ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bf:	eb 0c                	jmp    8004cd <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  8004c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c6:	eb 05                	jmp    8004cd <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8004c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8004cd:	83 c4 20             	add    $0x20,%esp
  8004d0:	5b                   	pop    %ebx
  8004d1:	5e                   	pop    %esi
  8004d2:	5f                   	pop    %edi
  8004d3:	5d                   	pop    %ebp
  8004d4:	c3                   	ret    

008004d5 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8004db:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8004de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	89 04 24             	mov    %eax,(%esp)
  8004e8:	e8 ff fd ff ff       	call   8002ec <inet_aton>
  8004ed:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  8004ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004f4:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	89 04 24             	mov    %eax,(%esp)
  800506:	e8 b5 fd ff ff       	call   8002c0 <htonl>
}
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    

0080050d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	56                   	push   %esi
  800511:	53                   	push   %ebx
  800512:	83 ec 10             	sub    $0x10,%esp
  800515:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800518:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80051b:	c7 05 18 50 80 00 00 	movl   $0x0,0x805018
  800522:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800525:	e8 fb 0a 00 00       	call   801025 <sys_getenvid>
  80052a:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80052f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800532:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800537:	a3 18 50 80 00       	mov    %eax,0x805018


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80053c:	85 db                	test   %ebx,%ebx
  80053e:	7e 07                	jle    800547 <libmain+0x3a>
		binaryname = argv[0];
  800540:	8b 06                	mov    (%esi),%eax
  800542:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  800547:	89 74 24 04          	mov    %esi,0x4(%esp)
  80054b:	89 1c 24             	mov    %ebx,(%esp)
  80054e:	e8 fd fa ff ff       	call   800050 <umain>

	// exit gracefully
	exit();
  800553:	e8 07 00 00 00       	call   80055f <exit>
}
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	5b                   	pop    %ebx
  80055c:	5e                   	pop    %esi
  80055d:	5d                   	pop    %ebp
  80055e:	c3                   	ret    

0080055f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800565:	e8 00 10 00 00       	call   80156a <close_all>
	sys_env_destroy(0);
  80056a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800571:	e8 5d 0a 00 00       	call   800fd3 <sys_env_destroy>
}
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	53                   	push   %ebx
  80057c:	83 ec 14             	sub    $0x14,%esp
  80057f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800582:	8b 13                	mov    (%ebx),%edx
  800584:	8d 42 01             	lea    0x1(%edx),%eax
  800587:	89 03                	mov    %eax,(%ebx)
  800589:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80058c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800590:	3d ff 00 00 00       	cmp    $0xff,%eax
  800595:	75 19                	jne    8005b0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800597:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80059e:	00 
  80059f:	8d 43 08             	lea    0x8(%ebx),%eax
  8005a2:	89 04 24             	mov    %eax,(%esp)
  8005a5:	e8 ec 09 00 00       	call   800f96 <sys_cputs>
		b->idx = 0;
  8005aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8005b0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005b4:	83 c4 14             	add    $0x14,%esp
  8005b7:	5b                   	pop    %ebx
  8005b8:	5d                   	pop    %ebp
  8005b9:	c3                   	ret    

008005ba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005ba:	55                   	push   %ebp
  8005bb:	89 e5                	mov    %esp,%ebp
  8005bd:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8005c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005ca:	00 00 00 
	b.cnt = 0;
  8005cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005d4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005e5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ef:	c7 04 24 78 05 80 00 	movl   $0x800578,(%esp)
  8005f6:	e8 b3 01 00 00       	call   8007ae <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005fb:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800601:	89 44 24 04          	mov    %eax,0x4(%esp)
  800605:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80060b:	89 04 24             	mov    %eax,(%esp)
  80060e:	e8 83 09 00 00       	call   800f96 <sys_cputs>

	return b.cnt;
}
  800613:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800619:	c9                   	leave  
  80061a:	c3                   	ret    

0080061b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80061b:	55                   	push   %ebp
  80061c:	89 e5                	mov    %esp,%ebp
  80061e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800624:	89 44 24 04          	mov    %eax,0x4(%esp)
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	89 04 24             	mov    %eax,(%esp)
  80062e:	e8 87 ff ff ff       	call   8005ba <vcprintf>
	va_end(ap);

	return cnt;
}
  800633:	c9                   	leave  
  800634:	c3                   	ret    
  800635:	66 90                	xchg   %ax,%ax
  800637:	66 90                	xchg   %ax,%ax
  800639:	66 90                	xchg   %ax,%ax
  80063b:	66 90                	xchg   %ax,%ax
  80063d:	66 90                	xchg   %ax,%ax
  80063f:	90                   	nop

00800640 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800640:	55                   	push   %ebp
  800641:	89 e5                	mov    %esp,%ebp
  800643:	57                   	push   %edi
  800644:	56                   	push   %esi
  800645:	53                   	push   %ebx
  800646:	83 ec 3c             	sub    $0x3c,%esp
  800649:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064c:	89 d7                	mov    %edx,%edi
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800654:	8b 45 0c             	mov    0xc(%ebp),%eax
  800657:	89 c3                	mov    %eax,%ebx
  800659:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80065c:	8b 45 10             	mov    0x10(%ebp),%eax
  80065f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800662:	b9 00 00 00 00       	mov    $0x0,%ecx
  800667:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80066d:	39 d9                	cmp    %ebx,%ecx
  80066f:	72 05                	jb     800676 <printnum+0x36>
  800671:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800674:	77 69                	ja     8006df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800676:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800679:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80067d:	83 ee 01             	sub    $0x1,%esi
  800680:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800684:	89 44 24 08          	mov    %eax,0x8(%esp)
  800688:	8b 44 24 08          	mov    0x8(%esp),%eax
  80068c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800690:	89 c3                	mov    %eax,%ebx
  800692:	89 d6                	mov    %edx,%esi
  800694:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800697:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80069a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80069e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8006a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a5:	89 04 24             	mov    %eax,(%esp)
  8006a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006af:	e8 2c 21 00 00       	call   8027e0 <__udivdi3>
  8006b4:	89 d9                	mov    %ebx,%ecx
  8006b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006be:	89 04 24             	mov    %eax,(%esp)
  8006c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006c5:	89 fa                	mov    %edi,%edx
  8006c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ca:	e8 71 ff ff ff       	call   800640 <printnum>
  8006cf:	eb 1b                	jmp    8006ec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d8:	89 04 24             	mov    %eax,(%esp)
  8006db:	ff d3                	call   *%ebx
  8006dd:	eb 03                	jmp    8006e2 <printnum+0xa2>
  8006df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e2:	83 ee 01             	sub    $0x1,%esi
  8006e5:	85 f6                	test   %esi,%esi
  8006e7:	7f e8                	jg     8006d1 <printnum+0x91>
  8006e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8006f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800702:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800705:	89 04 24             	mov    %eax,(%esp)
  800708:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80070b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80070f:	e8 fc 21 00 00       	call   802910 <__umoddi3>
  800714:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800718:	0f be 80 96 2b 80 00 	movsbl 0x802b96(%eax),%eax
  80071f:	89 04 24             	mov    %eax,(%esp)
  800722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800725:	ff d0                	call   *%eax
}
  800727:	83 c4 3c             	add    $0x3c,%esp
  80072a:	5b                   	pop    %ebx
  80072b:	5e                   	pop    %esi
  80072c:	5f                   	pop    %edi
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800732:	83 fa 01             	cmp    $0x1,%edx
  800735:	7e 0e                	jle    800745 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800737:	8b 10                	mov    (%eax),%edx
  800739:	8d 4a 08             	lea    0x8(%edx),%ecx
  80073c:	89 08                	mov    %ecx,(%eax)
  80073e:	8b 02                	mov    (%edx),%eax
  800740:	8b 52 04             	mov    0x4(%edx),%edx
  800743:	eb 22                	jmp    800767 <getuint+0x38>
	else if (lflag)
  800745:	85 d2                	test   %edx,%edx
  800747:	74 10                	je     800759 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800749:	8b 10                	mov    (%eax),%edx
  80074b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80074e:	89 08                	mov    %ecx,(%eax)
  800750:	8b 02                	mov    (%edx),%eax
  800752:	ba 00 00 00 00       	mov    $0x0,%edx
  800757:	eb 0e                	jmp    800767 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800759:	8b 10                	mov    (%eax),%edx
  80075b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80075e:	89 08                	mov    %ecx,(%eax)
  800760:	8b 02                	mov    (%edx),%eax
  800762:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800767:	5d                   	pop    %ebp
  800768:	c3                   	ret    

00800769 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80076f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800773:	8b 10                	mov    (%eax),%edx
  800775:	3b 50 04             	cmp    0x4(%eax),%edx
  800778:	73 0a                	jae    800784 <sprintputch+0x1b>
		*b->buf++ = ch;
  80077a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80077d:	89 08                	mov    %ecx,(%eax)
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	88 02                	mov    %al,(%edx)
}
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80078c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80078f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800793:	8b 45 10             	mov    0x10(%ebp),%eax
  800796:	89 44 24 08          	mov    %eax,0x8(%esp)
  80079a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	89 04 24             	mov    %eax,(%esp)
  8007a7:	e8 02 00 00 00       	call   8007ae <vprintfmt>
	va_end(ap);
}
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	57                   	push   %edi
  8007b2:	56                   	push   %esi
  8007b3:	53                   	push   %ebx
  8007b4:	83 ec 3c             	sub    $0x3c,%esp
  8007b7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007bd:	eb 14                	jmp    8007d3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	0f 84 b3 03 00 00    	je     800b7a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8007c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007cb:	89 04 24             	mov    %eax,(%esp)
  8007ce:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d1:	89 f3                	mov    %esi,%ebx
  8007d3:	8d 73 01             	lea    0x1(%ebx),%esi
  8007d6:	0f b6 03             	movzbl (%ebx),%eax
  8007d9:	83 f8 25             	cmp    $0x25,%eax
  8007dc:	75 e1                	jne    8007bf <vprintfmt+0x11>
  8007de:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8007e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8007e9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8007f0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fc:	eb 1d                	jmp    80081b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007fe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800800:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800804:	eb 15                	jmp    80081b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800806:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800808:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80080c:	eb 0d                	jmp    80081b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80080e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800811:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800814:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80081b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80081e:	0f b6 0e             	movzbl (%esi),%ecx
  800821:	0f b6 c1             	movzbl %cl,%eax
  800824:	83 e9 23             	sub    $0x23,%ecx
  800827:	80 f9 55             	cmp    $0x55,%cl
  80082a:	0f 87 2a 03 00 00    	ja     800b5a <vprintfmt+0x3ac>
  800830:	0f b6 c9             	movzbl %cl,%ecx
  800833:	ff 24 8d e0 2c 80 00 	jmp    *0x802ce0(,%ecx,4)
  80083a:	89 de                	mov    %ebx,%esi
  80083c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800841:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800844:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800848:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80084b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80084e:	83 fb 09             	cmp    $0x9,%ebx
  800851:	77 36                	ja     800889 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800853:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800856:	eb e9                	jmp    800841 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8d 48 04             	lea    0x4(%eax),%ecx
  80085e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800861:	8b 00                	mov    (%eax),%eax
  800863:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800866:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800868:	eb 22                	jmp    80088c <vprintfmt+0xde>
  80086a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80086d:	85 c9                	test   %ecx,%ecx
  80086f:	b8 00 00 00 00       	mov    $0x0,%eax
  800874:	0f 49 c1             	cmovns %ecx,%eax
  800877:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087a:	89 de                	mov    %ebx,%esi
  80087c:	eb 9d                	jmp    80081b <vprintfmt+0x6d>
  80087e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800880:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800887:	eb 92                	jmp    80081b <vprintfmt+0x6d>
  800889:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80088c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800890:	79 89                	jns    80081b <vprintfmt+0x6d>
  800892:	e9 77 ff ff ff       	jmp    80080e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800897:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80089c:	e9 7a ff ff ff       	jmp    80081b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8d 50 04             	lea    0x4(%eax),%edx
  8008a7:	89 55 14             	mov    %edx,0x14(%ebp)
  8008aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	89 04 24             	mov    %eax,(%esp)
  8008b3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008b6:	e9 18 ff ff ff       	jmp    8007d3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	8d 50 04             	lea    0x4(%eax),%edx
  8008c1:	89 55 14             	mov    %edx,0x14(%ebp)
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	99                   	cltd   
  8008c7:	31 d0                	xor    %edx,%eax
  8008c9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008cb:	83 f8 0f             	cmp    $0xf,%eax
  8008ce:	7f 0b                	jg     8008db <vprintfmt+0x12d>
  8008d0:	8b 14 85 40 2e 80 00 	mov    0x802e40(,%eax,4),%edx
  8008d7:	85 d2                	test   %edx,%edx
  8008d9:	75 20                	jne    8008fb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8008db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008df:	c7 44 24 08 ae 2b 80 	movl   $0x802bae,0x8(%esp)
  8008e6:	00 
  8008e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 04 24             	mov    %eax,(%esp)
  8008f1:	e8 90 fe ff ff       	call   800786 <printfmt>
  8008f6:	e9 d8 fe ff ff       	jmp    8007d3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8008fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008ff:	c7 44 24 08 75 2f 80 	movl   $0x802f75,0x8(%esp)
  800906:	00 
  800907:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 04 24             	mov    %eax,(%esp)
  800911:	e8 70 fe ff ff       	call   800786 <printfmt>
  800916:	e9 b8 fe ff ff       	jmp    8007d3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80091b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80091e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800921:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	8d 50 04             	lea    0x4(%eax),%edx
  80092a:	89 55 14             	mov    %edx,0x14(%ebp)
  80092d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80092f:	85 f6                	test   %esi,%esi
  800931:	b8 a7 2b 80 00       	mov    $0x802ba7,%eax
  800936:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800939:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80093d:	0f 84 97 00 00 00    	je     8009da <vprintfmt+0x22c>
  800943:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800947:	0f 8e 9b 00 00 00    	jle    8009e8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80094d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800951:	89 34 24             	mov    %esi,(%esp)
  800954:	e8 cf 02 00 00       	call   800c28 <strnlen>
  800959:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80095c:	29 c2                	sub    %eax,%edx
  80095e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800961:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800965:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800968:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80096b:	8b 75 08             	mov    0x8(%ebp),%esi
  80096e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800971:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800973:	eb 0f                	jmp    800984 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800975:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800979:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80097c:	89 04 24             	mov    %eax,(%esp)
  80097f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800981:	83 eb 01             	sub    $0x1,%ebx
  800984:	85 db                	test   %ebx,%ebx
  800986:	7f ed                	jg     800975 <vprintfmt+0x1c7>
  800988:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80098b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80098e:	85 d2                	test   %edx,%edx
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
  800995:	0f 49 c2             	cmovns %edx,%eax
  800998:	29 c2                	sub    %eax,%edx
  80099a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80099d:	89 d7                	mov    %edx,%edi
  80099f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009a2:	eb 50                	jmp    8009f4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a8:	74 1e                	je     8009c8 <vprintfmt+0x21a>
  8009aa:	0f be d2             	movsbl %dl,%edx
  8009ad:	83 ea 20             	sub    $0x20,%edx
  8009b0:	83 fa 5e             	cmp    $0x5e,%edx
  8009b3:	76 13                	jbe    8009c8 <vprintfmt+0x21a>
					putch('?', putdat);
  8009b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009bc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009c3:	ff 55 08             	call   *0x8(%ebp)
  8009c6:	eb 0d                	jmp    8009d5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8009c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009cf:	89 04 24             	mov    %eax,(%esp)
  8009d2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d5:	83 ef 01             	sub    $0x1,%edi
  8009d8:	eb 1a                	jmp    8009f4 <vprintfmt+0x246>
  8009da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009dd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8009e0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009e3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009e6:	eb 0c                	jmp    8009f4 <vprintfmt+0x246>
  8009e8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009eb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8009ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009f1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009f4:	83 c6 01             	add    $0x1,%esi
  8009f7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8009fb:	0f be c2             	movsbl %dl,%eax
  8009fe:	85 c0                	test   %eax,%eax
  800a00:	74 27                	je     800a29 <vprintfmt+0x27b>
  800a02:	85 db                	test   %ebx,%ebx
  800a04:	78 9e                	js     8009a4 <vprintfmt+0x1f6>
  800a06:	83 eb 01             	sub    $0x1,%ebx
  800a09:	79 99                	jns    8009a4 <vprintfmt+0x1f6>
  800a0b:	89 f8                	mov    %edi,%eax
  800a0d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a10:	8b 75 08             	mov    0x8(%ebp),%esi
  800a13:	89 c3                	mov    %eax,%ebx
  800a15:	eb 1a                	jmp    800a31 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a17:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a1b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a22:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a24:	83 eb 01             	sub    $0x1,%ebx
  800a27:	eb 08                	jmp    800a31 <vprintfmt+0x283>
  800a29:	89 fb                	mov    %edi,%ebx
  800a2b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a2e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a31:	85 db                	test   %ebx,%ebx
  800a33:	7f e2                	jg     800a17 <vprintfmt+0x269>
  800a35:	89 75 08             	mov    %esi,0x8(%ebp)
  800a38:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a3b:	e9 93 fd ff ff       	jmp    8007d3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a40:	83 fa 01             	cmp    $0x1,%edx
  800a43:	7e 16                	jle    800a5b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800a45:	8b 45 14             	mov    0x14(%ebp),%eax
  800a48:	8d 50 08             	lea    0x8(%eax),%edx
  800a4b:	89 55 14             	mov    %edx,0x14(%ebp)
  800a4e:	8b 50 04             	mov    0x4(%eax),%edx
  800a51:	8b 00                	mov    (%eax),%eax
  800a53:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a56:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a59:	eb 32                	jmp    800a8d <vprintfmt+0x2df>
	else if (lflag)
  800a5b:	85 d2                	test   %edx,%edx
  800a5d:	74 18                	je     800a77 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a62:	8d 50 04             	lea    0x4(%eax),%edx
  800a65:	89 55 14             	mov    %edx,0x14(%ebp)
  800a68:	8b 30                	mov    (%eax),%esi
  800a6a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800a6d:	89 f0                	mov    %esi,%eax
  800a6f:	c1 f8 1f             	sar    $0x1f,%eax
  800a72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a75:	eb 16                	jmp    800a8d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	8d 50 04             	lea    0x4(%eax),%edx
  800a7d:	89 55 14             	mov    %edx,0x14(%ebp)
  800a80:	8b 30                	mov    (%eax),%esi
  800a82:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800a85:	89 f0                	mov    %esi,%eax
  800a87:	c1 f8 1f             	sar    $0x1f,%eax
  800a8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800a93:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800a98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9c:	0f 89 80 00 00 00    	jns    800b22 <vprintfmt+0x374>
				putch('-', putdat);
  800aa2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aa6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800aad:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800ab0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ab6:	f7 d8                	neg    %eax
  800ab8:	83 d2 00             	adc    $0x0,%edx
  800abb:	f7 da                	neg    %edx
			}
			base = 10;
  800abd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ac2:	eb 5e                	jmp    800b22 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac7:	e8 63 fc ff ff       	call   80072f <getuint>
			base = 10;
  800acc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800ad1:	eb 4f                	jmp    800b22 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800ad3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad6:	e8 54 fc ff ff       	call   80072f <getuint>
			base =8;
  800adb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800ae0:	eb 40                	jmp    800b22 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800ae2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ae6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800aed:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800af0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800af4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800afb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800afe:	8b 45 14             	mov    0x14(%ebp),%eax
  800b01:	8d 50 04             	lea    0x4(%eax),%edx
  800b04:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b0e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800b13:	eb 0d                	jmp    800b22 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b15:	8d 45 14             	lea    0x14(%ebp),%eax
  800b18:	e8 12 fc ff ff       	call   80072f <getuint>
			base = 16;
  800b1d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b22:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800b26:	89 74 24 10          	mov    %esi,0x10(%esp)
  800b2a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800b2d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b31:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b35:	89 04 24             	mov    %eax,(%esp)
  800b38:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b3c:	89 fa                	mov    %edi,%edx
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	e8 fa fa ff ff       	call   800640 <printnum>
			break;
  800b46:	e9 88 fc ff ff       	jmp    8007d3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b4b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b4f:	89 04 24             	mov    %eax,(%esp)
  800b52:	ff 55 08             	call   *0x8(%ebp)
			break;
  800b55:	e9 79 fc ff ff       	jmp    8007d3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b5e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800b65:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b68:	89 f3                	mov    %esi,%ebx
  800b6a:	eb 03                	jmp    800b6f <vprintfmt+0x3c1>
  800b6c:	83 eb 01             	sub    $0x1,%ebx
  800b6f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800b73:	75 f7                	jne    800b6c <vprintfmt+0x3be>
  800b75:	e9 59 fc ff ff       	jmp    8007d3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800b7a:	83 c4 3c             	add    $0x3c,%esp
  800b7d:	5b                   	pop    %ebx
  800b7e:	5e                   	pop    %esi
  800b7f:	5f                   	pop    %edi
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 28             	sub    $0x28,%esp
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b91:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b95:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9f:	85 c0                	test   %eax,%eax
  800ba1:	74 30                	je     800bd3 <vsnprintf+0x51>
  800ba3:	85 d2                	test   %edx,%edx
  800ba5:	7e 2c                	jle    800bd3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba7:	8b 45 14             	mov    0x14(%ebp),%eax
  800baa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bae:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bb5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bbc:	c7 04 24 69 07 80 00 	movl   $0x800769,(%esp)
  800bc3:	e8 e6 fb ff ff       	call   8007ae <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bcb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bd1:	eb 05                	jmp    800bd8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800bd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800bd8:	c9                   	leave  
  800bd9:	c3                   	ret    

00800bda <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800be3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	89 04 24             	mov    %eax,(%esp)
  800bfb:	e8 82 ff ff ff       	call   800b82 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    
  800c02:	66 90                	xchg   %ax,%ax
  800c04:	66 90                	xchg   %ax,%ax
  800c06:	66 90                	xchg   %ax,%ax
  800c08:	66 90                	xchg   %ax,%ax
  800c0a:	66 90                	xchg   %ax,%ax
  800c0c:	66 90                	xchg   %ax,%ax
  800c0e:	66 90                	xchg   %ax,%ax

00800c10 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c16:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1b:	eb 03                	jmp    800c20 <strlen+0x10>
		n++;
  800c1d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c20:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c24:	75 f7                	jne    800c1d <strlen+0xd>
		n++;
	return n;
}
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    

00800c28 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c31:	b8 00 00 00 00       	mov    $0x0,%eax
  800c36:	eb 03                	jmp    800c3b <strnlen+0x13>
		n++;
  800c38:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3b:	39 d0                	cmp    %edx,%eax
  800c3d:	74 06                	je     800c45 <strnlen+0x1d>
  800c3f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c43:	75 f3                	jne    800c38 <strnlen+0x10>
		n++;
	return n;
}
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	53                   	push   %ebx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c51:	89 c2                	mov    %eax,%edx
  800c53:	83 c2 01             	add    $0x1,%edx
  800c56:	83 c1 01             	add    $0x1,%ecx
  800c59:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c5d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c60:	84 db                	test   %bl,%bl
  800c62:	75 ef                	jne    800c53 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c64:	5b                   	pop    %ebx
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	53                   	push   %ebx
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c71:	89 1c 24             	mov    %ebx,(%esp)
  800c74:	e8 97 ff ff ff       	call   800c10 <strlen>
	strcpy(dst + len, src);
  800c79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c80:	01 d8                	add    %ebx,%eax
  800c82:	89 04 24             	mov    %eax,(%esp)
  800c85:	e8 bd ff ff ff       	call   800c47 <strcpy>
	return dst;
}
  800c8a:	89 d8                	mov    %ebx,%eax
  800c8c:	83 c4 08             	add    $0x8,%esp
  800c8f:	5b                   	pop    %ebx
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    

00800c92 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
  800c97:	8b 75 08             	mov    0x8(%ebp),%esi
  800c9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9d:	89 f3                	mov    %esi,%ebx
  800c9f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca2:	89 f2                	mov    %esi,%edx
  800ca4:	eb 0f                	jmp    800cb5 <strncpy+0x23>
		*dst++ = *src;
  800ca6:	83 c2 01             	add    $0x1,%edx
  800ca9:	0f b6 01             	movzbl (%ecx),%eax
  800cac:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800caf:	80 39 01             	cmpb   $0x1,(%ecx)
  800cb2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb5:	39 da                	cmp    %ebx,%edx
  800cb7:	75 ed                	jne    800ca6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800cb9:	89 f0                	mov    %esi,%eax
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
  800cc4:	8b 75 08             	mov    0x8(%ebp),%esi
  800cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ccd:	89 f0                	mov    %esi,%eax
  800ccf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cd3:	85 c9                	test   %ecx,%ecx
  800cd5:	75 0b                	jne    800ce2 <strlcpy+0x23>
  800cd7:	eb 1d                	jmp    800cf6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800cd9:	83 c0 01             	add    $0x1,%eax
  800cdc:	83 c2 01             	add    $0x1,%edx
  800cdf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce2:	39 d8                	cmp    %ebx,%eax
  800ce4:	74 0b                	je     800cf1 <strlcpy+0x32>
  800ce6:	0f b6 0a             	movzbl (%edx),%ecx
  800ce9:	84 c9                	test   %cl,%cl
  800ceb:	75 ec                	jne    800cd9 <strlcpy+0x1a>
  800ced:	89 c2                	mov    %eax,%edx
  800cef:	eb 02                	jmp    800cf3 <strlcpy+0x34>
  800cf1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800cf3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800cf6:	29 f0                	sub    %esi,%eax
}
  800cf8:	5b                   	pop    %ebx
  800cf9:	5e                   	pop    %esi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d02:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d05:	eb 06                	jmp    800d0d <strcmp+0x11>
		p++, q++;
  800d07:	83 c1 01             	add    $0x1,%ecx
  800d0a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d0d:	0f b6 01             	movzbl (%ecx),%eax
  800d10:	84 c0                	test   %al,%al
  800d12:	74 04                	je     800d18 <strcmp+0x1c>
  800d14:	3a 02                	cmp    (%edx),%al
  800d16:	74 ef                	je     800d07 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d18:	0f b6 c0             	movzbl %al,%eax
  800d1b:	0f b6 12             	movzbl (%edx),%edx
  800d1e:	29 d0                	sub    %edx,%eax
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	53                   	push   %ebx
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2c:	89 c3                	mov    %eax,%ebx
  800d2e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d31:	eb 06                	jmp    800d39 <strncmp+0x17>
		n--, p++, q++;
  800d33:	83 c0 01             	add    $0x1,%eax
  800d36:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d39:	39 d8                	cmp    %ebx,%eax
  800d3b:	74 15                	je     800d52 <strncmp+0x30>
  800d3d:	0f b6 08             	movzbl (%eax),%ecx
  800d40:	84 c9                	test   %cl,%cl
  800d42:	74 04                	je     800d48 <strncmp+0x26>
  800d44:	3a 0a                	cmp    (%edx),%cl
  800d46:	74 eb                	je     800d33 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d48:	0f b6 00             	movzbl (%eax),%eax
  800d4b:	0f b6 12             	movzbl (%edx),%edx
  800d4e:	29 d0                	sub    %edx,%eax
  800d50:	eb 05                	jmp    800d57 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800d52:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800d57:	5b                   	pop    %ebx
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d64:	eb 07                	jmp    800d6d <strchr+0x13>
		if (*s == c)
  800d66:	38 ca                	cmp    %cl,%dl
  800d68:	74 0f                	je     800d79 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d6a:	83 c0 01             	add    $0x1,%eax
  800d6d:	0f b6 10             	movzbl (%eax),%edx
  800d70:	84 d2                	test   %dl,%dl
  800d72:	75 f2                	jne    800d66 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800d74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d85:	eb 07                	jmp    800d8e <strfind+0x13>
		if (*s == c)
  800d87:	38 ca                	cmp    %cl,%dl
  800d89:	74 0a                	je     800d95 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8b:	83 c0 01             	add    $0x1,%eax
  800d8e:	0f b6 10             	movzbl (%eax),%edx
  800d91:	84 d2                	test   %dl,%dl
  800d93:	75 f2                	jne    800d87 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800da0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800da3:	85 c9                	test   %ecx,%ecx
  800da5:	74 36                	je     800ddd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800da7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dad:	75 28                	jne    800dd7 <memset+0x40>
  800daf:	f6 c1 03             	test   $0x3,%cl
  800db2:	75 23                	jne    800dd7 <memset+0x40>
		c &= 0xFF;
  800db4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800db8:	89 d3                	mov    %edx,%ebx
  800dba:	c1 e3 08             	shl    $0x8,%ebx
  800dbd:	89 d6                	mov    %edx,%esi
  800dbf:	c1 e6 18             	shl    $0x18,%esi
  800dc2:	89 d0                	mov    %edx,%eax
  800dc4:	c1 e0 10             	shl    $0x10,%eax
  800dc7:	09 f0                	or     %esi,%eax
  800dc9:	09 c2                	or     %eax,%edx
  800dcb:	89 d0                	mov    %edx,%eax
  800dcd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800dcf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800dd2:	fc                   	cld    
  800dd3:	f3 ab                	rep stos %eax,%es:(%edi)
  800dd5:	eb 06                	jmp    800ddd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	fc                   	cld    
  800ddb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ddd:	89 f8                	mov    %edi,%eax
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	57                   	push   %edi
  800de8:	56                   	push   %esi
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800def:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800df2:	39 c6                	cmp    %eax,%esi
  800df4:	73 35                	jae    800e2b <memmove+0x47>
  800df6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800df9:	39 d0                	cmp    %edx,%eax
  800dfb:	73 2e                	jae    800e2b <memmove+0x47>
		s += n;
		d += n;
  800dfd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800e00:	89 d6                	mov    %edx,%esi
  800e02:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e0a:	75 13                	jne    800e1f <memmove+0x3b>
  800e0c:	f6 c1 03             	test   $0x3,%cl
  800e0f:	75 0e                	jne    800e1f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e11:	83 ef 04             	sub    $0x4,%edi
  800e14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e17:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800e1a:	fd                   	std    
  800e1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e1d:	eb 09                	jmp    800e28 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e1f:	83 ef 01             	sub    $0x1,%edi
  800e22:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e25:	fd                   	std    
  800e26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e28:	fc                   	cld    
  800e29:	eb 1d                	jmp    800e48 <memmove+0x64>
  800e2b:	89 f2                	mov    %esi,%edx
  800e2d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e2f:	f6 c2 03             	test   $0x3,%dl
  800e32:	75 0f                	jne    800e43 <memmove+0x5f>
  800e34:	f6 c1 03             	test   $0x3,%cl
  800e37:	75 0a                	jne    800e43 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e39:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800e3c:	89 c7                	mov    %eax,%edi
  800e3e:	fc                   	cld    
  800e3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e41:	eb 05                	jmp    800e48 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e43:	89 c7                	mov    %eax,%edi
  800e45:	fc                   	cld    
  800e46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e52:	8b 45 10             	mov    0x10(%ebp),%eax
  800e55:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	89 04 24             	mov    %eax,(%esp)
  800e66:	e8 79 ff ff ff       	call   800de4 <memmove>
}
  800e6b:	c9                   	leave  
  800e6c:	c3                   	ret    

00800e6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	56                   	push   %esi
  800e71:	53                   	push   %ebx
  800e72:	8b 55 08             	mov    0x8(%ebp),%edx
  800e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e78:	89 d6                	mov    %edx,%esi
  800e7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e7d:	eb 1a                	jmp    800e99 <memcmp+0x2c>
		if (*s1 != *s2)
  800e7f:	0f b6 02             	movzbl (%edx),%eax
  800e82:	0f b6 19             	movzbl (%ecx),%ebx
  800e85:	38 d8                	cmp    %bl,%al
  800e87:	74 0a                	je     800e93 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800e89:	0f b6 c0             	movzbl %al,%eax
  800e8c:	0f b6 db             	movzbl %bl,%ebx
  800e8f:	29 d8                	sub    %ebx,%eax
  800e91:	eb 0f                	jmp    800ea2 <memcmp+0x35>
		s1++, s2++;
  800e93:	83 c2 01             	add    $0x1,%edx
  800e96:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e99:	39 f2                	cmp    %esi,%edx
  800e9b:	75 e2                	jne    800e7f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea2:	5b                   	pop    %ebx
  800ea3:	5e                   	pop    %esi
  800ea4:	5d                   	pop    %ebp
  800ea5:	c3                   	ret    

00800ea6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800eaf:	89 c2                	mov    %eax,%edx
  800eb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800eb4:	eb 07                	jmp    800ebd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eb6:	38 08                	cmp    %cl,(%eax)
  800eb8:	74 07                	je     800ec1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eba:	83 c0 01             	add    $0x1,%eax
  800ebd:	39 d0                	cmp    %edx,%eax
  800ebf:	72 f5                	jb     800eb6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	57                   	push   %edi
  800ec7:	56                   	push   %esi
  800ec8:	53                   	push   %ebx
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ecf:	eb 03                	jmp    800ed4 <strtol+0x11>
		s++;
  800ed1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed4:	0f b6 0a             	movzbl (%edx),%ecx
  800ed7:	80 f9 09             	cmp    $0x9,%cl
  800eda:	74 f5                	je     800ed1 <strtol+0xe>
  800edc:	80 f9 20             	cmp    $0x20,%cl
  800edf:	74 f0                	je     800ed1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ee1:	80 f9 2b             	cmp    $0x2b,%cl
  800ee4:	75 0a                	jne    800ef0 <strtol+0x2d>
		s++;
  800ee6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ee9:	bf 00 00 00 00       	mov    $0x0,%edi
  800eee:	eb 11                	jmp    800f01 <strtol+0x3e>
  800ef0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ef5:	80 f9 2d             	cmp    $0x2d,%cl
  800ef8:	75 07                	jne    800f01 <strtol+0x3e>
		s++, neg = 1;
  800efa:	8d 52 01             	lea    0x1(%edx),%edx
  800efd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f01:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800f06:	75 15                	jne    800f1d <strtol+0x5a>
  800f08:	80 3a 30             	cmpb   $0x30,(%edx)
  800f0b:	75 10                	jne    800f1d <strtol+0x5a>
  800f0d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f11:	75 0a                	jne    800f1d <strtol+0x5a>
		s += 2, base = 16;
  800f13:	83 c2 02             	add    $0x2,%edx
  800f16:	b8 10 00 00 00       	mov    $0x10,%eax
  800f1b:	eb 10                	jmp    800f2d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	75 0c                	jne    800f2d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f21:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f23:	80 3a 30             	cmpb   $0x30,(%edx)
  800f26:	75 05                	jne    800f2d <strtol+0x6a>
		s++, base = 8;
  800f28:	83 c2 01             	add    $0x1,%edx
  800f2b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800f2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f32:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f35:	0f b6 0a             	movzbl (%edx),%ecx
  800f38:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800f3b:	89 f0                	mov    %esi,%eax
  800f3d:	3c 09                	cmp    $0x9,%al
  800f3f:	77 08                	ja     800f49 <strtol+0x86>
			dig = *s - '0';
  800f41:	0f be c9             	movsbl %cl,%ecx
  800f44:	83 e9 30             	sub    $0x30,%ecx
  800f47:	eb 20                	jmp    800f69 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800f49:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800f4c:	89 f0                	mov    %esi,%eax
  800f4e:	3c 19                	cmp    $0x19,%al
  800f50:	77 08                	ja     800f5a <strtol+0x97>
			dig = *s - 'a' + 10;
  800f52:	0f be c9             	movsbl %cl,%ecx
  800f55:	83 e9 57             	sub    $0x57,%ecx
  800f58:	eb 0f                	jmp    800f69 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800f5a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800f5d:	89 f0                	mov    %esi,%eax
  800f5f:	3c 19                	cmp    $0x19,%al
  800f61:	77 16                	ja     800f79 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800f63:	0f be c9             	movsbl %cl,%ecx
  800f66:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f69:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800f6c:	7d 0f                	jge    800f7d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800f6e:	83 c2 01             	add    $0x1,%edx
  800f71:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800f75:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800f77:	eb bc                	jmp    800f35 <strtol+0x72>
  800f79:	89 d8                	mov    %ebx,%eax
  800f7b:	eb 02                	jmp    800f7f <strtol+0xbc>
  800f7d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800f7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f83:	74 05                	je     800f8a <strtol+0xc7>
		*endptr = (char *) s;
  800f85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f88:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800f8a:	f7 d8                	neg    %eax
  800f8c:	85 ff                	test   %edi,%edi
  800f8e:	0f 44 c3             	cmove  %ebx,%eax
}
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	57                   	push   %edi
  800f9a:	56                   	push   %esi
  800f9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa7:	89 c3                	mov    %eax,%ebx
  800fa9:	89 c7                	mov    %eax,%edi
  800fab:	89 c6                	mov    %eax,%esi
  800fad:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800faf:	5b                   	pop    %ebx
  800fb0:	5e                   	pop    %esi
  800fb1:	5f                   	pop    %edi
  800fb2:	5d                   	pop    %ebp
  800fb3:	c3                   	ret    

00800fb4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	57                   	push   %edi
  800fb8:	56                   	push   %esi
  800fb9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fba:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbf:	b8 01 00 00 00       	mov    $0x1,%eax
  800fc4:	89 d1                	mov    %edx,%ecx
  800fc6:	89 d3                	mov    %edx,%ebx
  800fc8:	89 d7                	mov    %edx,%edi
  800fca:	89 d6                	mov    %edx,%esi
  800fcc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fce:	5b                   	pop    %ebx
  800fcf:	5e                   	pop    %esi
  800fd0:	5f                   	pop    %edi
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    

00800fd3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	57                   	push   %edi
  800fd7:	56                   	push   %esi
  800fd8:	53                   	push   %ebx
  800fd9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fdc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe1:	b8 03 00 00 00       	mov    $0x3,%eax
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	89 cb                	mov    %ecx,%ebx
  800feb:	89 cf                	mov    %ecx,%edi
  800fed:	89 ce                	mov    %ecx,%esi
  800fef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	7e 28                	jle    80101d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801000:	00 
  801001:	c7 44 24 08 9f 2e 80 	movl   $0x802e9f,0x8(%esp)
  801008:	00 
  801009:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801010:	00 
  801011:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  801018:	e8 29 16 00 00       	call   802646 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80101d:	83 c4 2c             	add    $0x2c,%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	57                   	push   %edi
  801029:	56                   	push   %esi
  80102a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102b:	ba 00 00 00 00       	mov    $0x0,%edx
  801030:	b8 02 00 00 00       	mov    $0x2,%eax
  801035:	89 d1                	mov    %edx,%ecx
  801037:	89 d3                	mov    %edx,%ebx
  801039:	89 d7                	mov    %edx,%edi
  80103b:	89 d6                	mov    %edx,%esi
  80103d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80103f:	5b                   	pop    %ebx
  801040:	5e                   	pop    %esi
  801041:	5f                   	pop    %edi
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    

00801044 <sys_yield>:

void
sys_yield(void)
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
  80104f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801054:	89 d1                	mov    %edx,%ecx
  801056:	89 d3                	mov    %edx,%ebx
  801058:	89 d7                	mov    %edx,%edi
  80105a:	89 d6                	mov    %edx,%esi
  80105c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80105e:	5b                   	pop    %ebx
  80105f:	5e                   	pop    %esi
  801060:	5f                   	pop    %edi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    

00801063 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  80106c:	be 00 00 00 00       	mov    $0x0,%esi
  801071:	b8 04 00 00 00       	mov    $0x4,%eax
  801076:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80107f:	89 f7                	mov    %esi,%edi
  801081:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801083:	85 c0                	test   %eax,%eax
  801085:	7e 28                	jle    8010af <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801087:	89 44 24 10          	mov    %eax,0x10(%esp)
  80108b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801092:	00 
  801093:	c7 44 24 08 9f 2e 80 	movl   $0x802e9f,0x8(%esp)
  80109a:	00 
  80109b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a2:	00 
  8010a3:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  8010aa:	e8 97 15 00 00       	call   802646 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010af:	83 c4 2c             	add    $0x2c,%esp
  8010b2:	5b                   	pop    %ebx
  8010b3:	5e                   	pop    %esi
  8010b4:	5f                   	pop    %edi
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	57                   	push   %edi
  8010bb:	56                   	push   %esi
  8010bc:	53                   	push   %ebx
  8010bd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c0:	b8 05 00 00 00       	mov    $0x5,%eax
  8010c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ce:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010d1:	8b 75 18             	mov    0x18(%ebp),%esi
  8010d4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	7e 28                	jle    801102 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010da:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010de:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010e5:	00 
  8010e6:	c7 44 24 08 9f 2e 80 	movl   $0x802e9f,0x8(%esp)
  8010ed:	00 
  8010ee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f5:	00 
  8010f6:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  8010fd:	e8 44 15 00 00       	call   802646 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801102:	83 c4 2c             	add    $0x2c,%esp
  801105:	5b                   	pop    %ebx
  801106:	5e                   	pop    %esi
  801107:	5f                   	pop    %edi
  801108:	5d                   	pop    %ebp
  801109:	c3                   	ret    

0080110a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	57                   	push   %edi
  80110e:	56                   	push   %esi
  80110f:	53                   	push   %ebx
  801110:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801113:	bb 00 00 00 00       	mov    $0x0,%ebx
  801118:	b8 06 00 00 00       	mov    $0x6,%eax
  80111d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801120:	8b 55 08             	mov    0x8(%ebp),%edx
  801123:	89 df                	mov    %ebx,%edi
  801125:	89 de                	mov    %ebx,%esi
  801127:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801129:	85 c0                	test   %eax,%eax
  80112b:	7e 28                	jle    801155 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80112d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801131:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801138:	00 
  801139:	c7 44 24 08 9f 2e 80 	movl   $0x802e9f,0x8(%esp)
  801140:	00 
  801141:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801148:	00 
  801149:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  801150:	e8 f1 14 00 00       	call   802646 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801155:	83 c4 2c             	add    $0x2c,%esp
  801158:	5b                   	pop    %ebx
  801159:	5e                   	pop    %esi
  80115a:	5f                   	pop    %edi
  80115b:	5d                   	pop    %ebp
  80115c:	c3                   	ret    

0080115d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	57                   	push   %edi
  801161:	56                   	push   %esi
  801162:	53                   	push   %ebx
  801163:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801166:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116b:	b8 08 00 00 00       	mov    $0x8,%eax
  801170:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801173:	8b 55 08             	mov    0x8(%ebp),%edx
  801176:	89 df                	mov    %ebx,%edi
  801178:	89 de                	mov    %ebx,%esi
  80117a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80117c:	85 c0                	test   %eax,%eax
  80117e:	7e 28                	jle    8011a8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801180:	89 44 24 10          	mov    %eax,0x10(%esp)
  801184:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80118b:	00 
  80118c:	c7 44 24 08 9f 2e 80 	movl   $0x802e9f,0x8(%esp)
  801193:	00 
  801194:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80119b:	00 
  80119c:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  8011a3:	e8 9e 14 00 00       	call   802646 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011a8:	83 c4 2c             	add    $0x2c,%esp
  8011ab:	5b                   	pop    %ebx
  8011ac:	5e                   	pop    %esi
  8011ad:	5f                   	pop    %edi
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	57                   	push   %edi
  8011b4:	56                   	push   %esi
  8011b5:	53                   	push   %ebx
  8011b6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011be:	b8 09 00 00 00       	mov    $0x9,%eax
  8011c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c9:	89 df                	mov    %ebx,%edi
  8011cb:	89 de                	mov    %ebx,%esi
  8011cd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	7e 28                	jle    8011fb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8011de:	00 
  8011df:	c7 44 24 08 9f 2e 80 	movl   $0x802e9f,0x8(%esp)
  8011e6:	00 
  8011e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ee:	00 
  8011ef:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  8011f6:	e8 4b 14 00 00       	call   802646 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011fb:	83 c4 2c             	add    $0x2c,%esp
  8011fe:	5b                   	pop    %ebx
  8011ff:	5e                   	pop    %esi
  801200:	5f                   	pop    %edi
  801201:	5d                   	pop    %ebp
  801202:	c3                   	ret    

00801203 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	57                   	push   %edi
  801207:	56                   	push   %esi
  801208:	53                   	push   %ebx
  801209:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80120c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801211:	b8 0a 00 00 00       	mov    $0xa,%eax
  801216:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801219:	8b 55 08             	mov    0x8(%ebp),%edx
  80121c:	89 df                	mov    %ebx,%edi
  80121e:	89 de                	mov    %ebx,%esi
  801220:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801222:	85 c0                	test   %eax,%eax
  801224:	7e 28                	jle    80124e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801226:	89 44 24 10          	mov    %eax,0x10(%esp)
  80122a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801231:	00 
  801232:	c7 44 24 08 9f 2e 80 	movl   $0x802e9f,0x8(%esp)
  801239:	00 
  80123a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801241:	00 
  801242:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  801249:	e8 f8 13 00 00       	call   802646 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80124e:	83 c4 2c             	add    $0x2c,%esp
  801251:	5b                   	pop    %ebx
  801252:	5e                   	pop    %esi
  801253:	5f                   	pop    %edi
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	57                   	push   %edi
  80125a:	56                   	push   %esi
  80125b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80125c:	be 00 00 00 00       	mov    $0x0,%esi
  801261:	b8 0c 00 00 00       	mov    $0xc,%eax
  801266:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801269:	8b 55 08             	mov    0x8(%ebp),%edx
  80126c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80126f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801272:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801274:	5b                   	pop    %ebx
  801275:	5e                   	pop    %esi
  801276:	5f                   	pop    %edi
  801277:	5d                   	pop    %ebp
  801278:	c3                   	ret    

00801279 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	57                   	push   %edi
  80127d:	56                   	push   %esi
  80127e:	53                   	push   %ebx
  80127f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801282:	b9 00 00 00 00       	mov    $0x0,%ecx
  801287:	b8 0d 00 00 00       	mov    $0xd,%eax
  80128c:	8b 55 08             	mov    0x8(%ebp),%edx
  80128f:	89 cb                	mov    %ecx,%ebx
  801291:	89 cf                	mov    %ecx,%edi
  801293:	89 ce                	mov    %ecx,%esi
  801295:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801297:	85 c0                	test   %eax,%eax
  801299:	7e 28                	jle    8012c3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80129b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80129f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8012a6:	00 
  8012a7:	c7 44 24 08 9f 2e 80 	movl   $0x802e9f,0x8(%esp)
  8012ae:	00 
  8012af:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012b6:	00 
  8012b7:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  8012be:	e8 83 13 00 00       	call   802646 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012c3:	83 c4 2c             	add    $0x2c,%esp
  8012c6:	5b                   	pop    %ebx
  8012c7:	5e                   	pop    %esi
  8012c8:	5f                   	pop    %edi
  8012c9:	5d                   	pop    %ebp
  8012ca:	c3                   	ret    

008012cb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	57                   	push   %edi
  8012cf:	56                   	push   %esi
  8012d0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012db:	89 d1                	mov    %edx,%ecx
  8012dd:	89 d3                	mov    %edx,%ebx
  8012df:	89 d7                	mov    %edx,%edi
  8012e1:	89 d6                	mov    %edx,%esi
  8012e3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	57                   	push   %edi
  8012ee:	56                   	push   %esi
  8012ef:	53                   	push   %ebx
  8012f0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8012fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801300:	8b 55 08             	mov    0x8(%ebp),%edx
  801303:	89 df                	mov    %ebx,%edi
  801305:	89 de                	mov    %ebx,%esi
  801307:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801309:	85 c0                	test   %eax,%eax
  80130b:	7e 28                	jle    801335 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80130d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801311:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801318:	00 
  801319:	c7 44 24 08 9f 2e 80 	movl   $0x802e9f,0x8(%esp)
  801320:	00 
  801321:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801328:	00 
  801329:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  801330:	e8 11 13 00 00       	call   802646 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801335:	83 c4 2c             	add    $0x2c,%esp
  801338:	5b                   	pop    %ebx
  801339:	5e                   	pop    %esi
  80133a:	5f                   	pop    %edi
  80133b:	5d                   	pop    %ebp
  80133c:	c3                   	ret    

0080133d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	57                   	push   %edi
  801341:	56                   	push   %esi
  801342:	53                   	push   %ebx
  801343:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801346:	bb 00 00 00 00       	mov    $0x0,%ebx
  80134b:	b8 10 00 00 00       	mov    $0x10,%eax
  801350:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801353:	8b 55 08             	mov    0x8(%ebp),%edx
  801356:	89 df                	mov    %ebx,%edi
  801358:	89 de                	mov    %ebx,%esi
  80135a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80135c:	85 c0                	test   %eax,%eax
  80135e:	7e 28                	jle    801388 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801360:	89 44 24 10          	mov    %eax,0x10(%esp)
  801364:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80136b:	00 
  80136c:	c7 44 24 08 9f 2e 80 	movl   $0x802e9f,0x8(%esp)
  801373:	00 
  801374:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80137b:	00 
  80137c:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  801383:	e8 be 12 00 00       	call   802646 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801388:	83 c4 2c             	add    $0x2c,%esp
  80138b:	5b                   	pop    %ebx
  80138c:	5e                   	pop    %esi
  80138d:	5f                   	pop    %edi
  80138e:	5d                   	pop    %ebp
  80138f:	c3                   	ret    

00801390 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	05 00 00 00 30       	add    $0x30000000,%eax
  80139b:	c1 e8 0c             	shr    $0xc,%eax
}
  80139e:	5d                   	pop    %ebp
  80139f:	c3                   	ret    

008013a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8013ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013b5:	5d                   	pop    %ebp
  8013b6:	c3                   	ret    

008013b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013c2:	89 c2                	mov    %eax,%edx
  8013c4:	c1 ea 16             	shr    $0x16,%edx
  8013c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013ce:	f6 c2 01             	test   $0x1,%dl
  8013d1:	74 11                	je     8013e4 <fd_alloc+0x2d>
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	c1 ea 0c             	shr    $0xc,%edx
  8013d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013df:	f6 c2 01             	test   $0x1,%dl
  8013e2:	75 09                	jne    8013ed <fd_alloc+0x36>
			*fd_store = fd;
  8013e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013eb:	eb 17                	jmp    801404 <fd_alloc+0x4d>
  8013ed:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013f2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013f7:	75 c9                	jne    8013c2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013f9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801404:	5d                   	pop    %ebp
  801405:	c3                   	ret    

00801406 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80140c:	83 f8 1f             	cmp    $0x1f,%eax
  80140f:	77 36                	ja     801447 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801411:	c1 e0 0c             	shl    $0xc,%eax
  801414:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801419:	89 c2                	mov    %eax,%edx
  80141b:	c1 ea 16             	shr    $0x16,%edx
  80141e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801425:	f6 c2 01             	test   $0x1,%dl
  801428:	74 24                	je     80144e <fd_lookup+0x48>
  80142a:	89 c2                	mov    %eax,%edx
  80142c:	c1 ea 0c             	shr    $0xc,%edx
  80142f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801436:	f6 c2 01             	test   $0x1,%dl
  801439:	74 1a                	je     801455 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80143b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143e:	89 02                	mov    %eax,(%edx)
	return 0;
  801440:	b8 00 00 00 00       	mov    $0x0,%eax
  801445:	eb 13                	jmp    80145a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801447:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144c:	eb 0c                	jmp    80145a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80144e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801453:	eb 05                	jmp    80145a <fd_lookup+0x54>
  801455:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80145a:	5d                   	pop    %ebp
  80145b:	c3                   	ret    

0080145c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 18             	sub    $0x18,%esp
  801462:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801465:	ba 00 00 00 00       	mov    $0x0,%edx
  80146a:	eb 13                	jmp    80147f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80146c:	39 08                	cmp    %ecx,(%eax)
  80146e:	75 0c                	jne    80147c <dev_lookup+0x20>
			*dev = devtab[i];
  801470:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801473:	89 01                	mov    %eax,(%ecx)
			return 0;
  801475:	b8 00 00 00 00       	mov    $0x0,%eax
  80147a:	eb 38                	jmp    8014b4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80147c:	83 c2 01             	add    $0x1,%edx
  80147f:	8b 04 95 48 2f 80 00 	mov    0x802f48(,%edx,4),%eax
  801486:	85 c0                	test   %eax,%eax
  801488:	75 e2                	jne    80146c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80148a:	a1 18 50 80 00       	mov    0x805018,%eax
  80148f:	8b 40 48             	mov    0x48(%eax),%eax
  801492:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149a:	c7 04 24 cc 2e 80 00 	movl   $0x802ecc,(%esp)
  8014a1:	e8 75 f1 ff ff       	call   80061b <cprintf>
	*dev = 0;
  8014a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	56                   	push   %esi
  8014ba:	53                   	push   %ebx
  8014bb:	83 ec 20             	sub    $0x20,%esp
  8014be:	8b 75 08             	mov    0x8(%ebp),%esi
  8014c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014cb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014d1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d4:	89 04 24             	mov    %eax,(%esp)
  8014d7:	e8 2a ff ff ff       	call   801406 <fd_lookup>
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 05                	js     8014e5 <fd_close+0x2f>
	    || fd != fd2)
  8014e0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014e3:	74 0c                	je     8014f1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8014e5:	84 db                	test   %bl,%bl
  8014e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ec:	0f 44 c2             	cmove  %edx,%eax
  8014ef:	eb 3f                	jmp    801530 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f8:	8b 06                	mov    (%esi),%eax
  8014fa:	89 04 24             	mov    %eax,(%esp)
  8014fd:	e8 5a ff ff ff       	call   80145c <dev_lookup>
  801502:	89 c3                	mov    %eax,%ebx
  801504:	85 c0                	test   %eax,%eax
  801506:	78 16                	js     80151e <fd_close+0x68>
		if (dev->dev_close)
  801508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80150e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801513:	85 c0                	test   %eax,%eax
  801515:	74 07                	je     80151e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801517:	89 34 24             	mov    %esi,(%esp)
  80151a:	ff d0                	call   *%eax
  80151c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80151e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801522:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801529:	e8 dc fb ff ff       	call   80110a <sys_page_unmap>
	return r;
  80152e:	89 d8                	mov    %ebx,%eax
}
  801530:	83 c4 20             	add    $0x20,%esp
  801533:	5b                   	pop    %ebx
  801534:	5e                   	pop    %esi
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    

00801537 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80153d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801540:	89 44 24 04          	mov    %eax,0x4(%esp)
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	89 04 24             	mov    %eax,(%esp)
  80154a:	e8 b7 fe ff ff       	call   801406 <fd_lookup>
  80154f:	89 c2                	mov    %eax,%edx
  801551:	85 d2                	test   %edx,%edx
  801553:	78 13                	js     801568 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801555:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80155c:	00 
  80155d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801560:	89 04 24             	mov    %eax,(%esp)
  801563:	e8 4e ff ff ff       	call   8014b6 <fd_close>
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <close_all>:

void
close_all(void)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	53                   	push   %ebx
  80156e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801571:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801576:	89 1c 24             	mov    %ebx,(%esp)
  801579:	e8 b9 ff ff ff       	call   801537 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80157e:	83 c3 01             	add    $0x1,%ebx
  801581:	83 fb 20             	cmp    $0x20,%ebx
  801584:	75 f0                	jne    801576 <close_all+0xc>
		close(i);
}
  801586:	83 c4 14             	add    $0x14,%esp
  801589:	5b                   	pop    %ebx
  80158a:	5d                   	pop    %ebp
  80158b:	c3                   	ret    

0080158c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	57                   	push   %edi
  801590:	56                   	push   %esi
  801591:	53                   	push   %ebx
  801592:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801595:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801598:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	89 04 24             	mov    %eax,(%esp)
  8015a2:	e8 5f fe ff ff       	call   801406 <fd_lookup>
  8015a7:	89 c2                	mov    %eax,%edx
  8015a9:	85 d2                	test   %edx,%edx
  8015ab:	0f 88 e1 00 00 00    	js     801692 <dup+0x106>
		return r;
	close(newfdnum);
  8015b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b4:	89 04 24             	mov    %eax,(%esp)
  8015b7:	e8 7b ff ff ff       	call   801537 <close>

	newfd = INDEX2FD(newfdnum);
  8015bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015bf:	c1 e3 0c             	shl    $0xc,%ebx
  8015c2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8015c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015cb:	89 04 24             	mov    %eax,(%esp)
  8015ce:	e8 cd fd ff ff       	call   8013a0 <fd2data>
  8015d3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8015d5:	89 1c 24             	mov    %ebx,(%esp)
  8015d8:	e8 c3 fd ff ff       	call   8013a0 <fd2data>
  8015dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015df:	89 f0                	mov    %esi,%eax
  8015e1:	c1 e8 16             	shr    $0x16,%eax
  8015e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015eb:	a8 01                	test   $0x1,%al
  8015ed:	74 43                	je     801632 <dup+0xa6>
  8015ef:	89 f0                	mov    %esi,%eax
  8015f1:	c1 e8 0c             	shr    $0xc,%eax
  8015f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015fb:	f6 c2 01             	test   $0x1,%dl
  8015fe:	74 32                	je     801632 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801600:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801607:	25 07 0e 00 00       	and    $0xe07,%eax
  80160c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801610:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801614:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80161b:	00 
  80161c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801620:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801627:	e8 8b fa ff ff       	call   8010b7 <sys_page_map>
  80162c:	89 c6                	mov    %eax,%esi
  80162e:	85 c0                	test   %eax,%eax
  801630:	78 3e                	js     801670 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801635:	89 c2                	mov    %eax,%edx
  801637:	c1 ea 0c             	shr    $0xc,%edx
  80163a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801641:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801647:	89 54 24 10          	mov    %edx,0x10(%esp)
  80164b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80164f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801656:	00 
  801657:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801662:	e8 50 fa ff ff       	call   8010b7 <sys_page_map>
  801667:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80166c:	85 f6                	test   %esi,%esi
  80166e:	79 22                	jns    801692 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801670:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801674:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80167b:	e8 8a fa ff ff       	call   80110a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801680:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801684:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168b:	e8 7a fa ff ff       	call   80110a <sys_page_unmap>
	return r;
  801690:	89 f0                	mov    %esi,%eax
}
  801692:	83 c4 3c             	add    $0x3c,%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5f                   	pop    %edi
  801698:	5d                   	pop    %ebp
  801699:	c3                   	ret    

0080169a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	53                   	push   %ebx
  80169e:	83 ec 24             	sub    $0x24,%esp
  8016a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ab:	89 1c 24             	mov    %ebx,(%esp)
  8016ae:	e8 53 fd ff ff       	call   801406 <fd_lookup>
  8016b3:	89 c2                	mov    %eax,%edx
  8016b5:	85 d2                	test   %edx,%edx
  8016b7:	78 6d                	js     801726 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c3:	8b 00                	mov    (%eax),%eax
  8016c5:	89 04 24             	mov    %eax,(%esp)
  8016c8:	e8 8f fd ff ff       	call   80145c <dev_lookup>
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 55                	js     801726 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d4:	8b 50 08             	mov    0x8(%eax),%edx
  8016d7:	83 e2 03             	and    $0x3,%edx
  8016da:	83 fa 01             	cmp    $0x1,%edx
  8016dd:	75 23                	jne    801702 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016df:	a1 18 50 80 00       	mov    0x805018,%eax
  8016e4:	8b 40 48             	mov    0x48(%eax),%eax
  8016e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ef:	c7 04 24 0d 2f 80 00 	movl   $0x802f0d,(%esp)
  8016f6:	e8 20 ef ff ff       	call   80061b <cprintf>
		return -E_INVAL;
  8016fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801700:	eb 24                	jmp    801726 <read+0x8c>
	}
	if (!dev->dev_read)
  801702:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801705:	8b 52 08             	mov    0x8(%edx),%edx
  801708:	85 d2                	test   %edx,%edx
  80170a:	74 15                	je     801721 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80170c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80170f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801713:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801716:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80171a:	89 04 24             	mov    %eax,(%esp)
  80171d:	ff d2                	call   *%edx
  80171f:	eb 05                	jmp    801726 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801721:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801726:	83 c4 24             	add    $0x24,%esp
  801729:	5b                   	pop    %ebx
  80172a:	5d                   	pop    %ebp
  80172b:	c3                   	ret    

0080172c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	57                   	push   %edi
  801730:	56                   	push   %esi
  801731:	53                   	push   %ebx
  801732:	83 ec 1c             	sub    $0x1c,%esp
  801735:	8b 7d 08             	mov    0x8(%ebp),%edi
  801738:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80173b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801740:	eb 23                	jmp    801765 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801742:	89 f0                	mov    %esi,%eax
  801744:	29 d8                	sub    %ebx,%eax
  801746:	89 44 24 08          	mov    %eax,0x8(%esp)
  80174a:	89 d8                	mov    %ebx,%eax
  80174c:	03 45 0c             	add    0xc(%ebp),%eax
  80174f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801753:	89 3c 24             	mov    %edi,(%esp)
  801756:	e8 3f ff ff ff       	call   80169a <read>
		if (m < 0)
  80175b:	85 c0                	test   %eax,%eax
  80175d:	78 10                	js     80176f <readn+0x43>
			return m;
		if (m == 0)
  80175f:	85 c0                	test   %eax,%eax
  801761:	74 0a                	je     80176d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801763:	01 c3                	add    %eax,%ebx
  801765:	39 f3                	cmp    %esi,%ebx
  801767:	72 d9                	jb     801742 <readn+0x16>
  801769:	89 d8                	mov    %ebx,%eax
  80176b:	eb 02                	jmp    80176f <readn+0x43>
  80176d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80176f:	83 c4 1c             	add    $0x1c,%esp
  801772:	5b                   	pop    %ebx
  801773:	5e                   	pop    %esi
  801774:	5f                   	pop    %edi
  801775:	5d                   	pop    %ebp
  801776:	c3                   	ret    

00801777 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	53                   	push   %ebx
  80177b:	83 ec 24             	sub    $0x24,%esp
  80177e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801781:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801784:	89 44 24 04          	mov    %eax,0x4(%esp)
  801788:	89 1c 24             	mov    %ebx,(%esp)
  80178b:	e8 76 fc ff ff       	call   801406 <fd_lookup>
  801790:	89 c2                	mov    %eax,%edx
  801792:	85 d2                	test   %edx,%edx
  801794:	78 68                	js     8017fe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801796:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801799:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a0:	8b 00                	mov    (%eax),%eax
  8017a2:	89 04 24             	mov    %eax,(%esp)
  8017a5:	e8 b2 fc ff ff       	call   80145c <dev_lookup>
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	78 50                	js     8017fe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017b5:	75 23                	jne    8017da <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017b7:	a1 18 50 80 00       	mov    0x805018,%eax
  8017bc:	8b 40 48             	mov    0x48(%eax),%eax
  8017bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c7:	c7 04 24 29 2f 80 00 	movl   $0x802f29,(%esp)
  8017ce:	e8 48 ee ff ff       	call   80061b <cprintf>
		return -E_INVAL;
  8017d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d8:	eb 24                	jmp    8017fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017dd:	8b 52 0c             	mov    0xc(%edx),%edx
  8017e0:	85 d2                	test   %edx,%edx
  8017e2:	74 15                	je     8017f9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017f2:	89 04 24             	mov    %eax,(%esp)
  8017f5:	ff d2                	call   *%edx
  8017f7:	eb 05                	jmp    8017fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8017fe:	83 c4 24             	add    $0x24,%esp
  801801:	5b                   	pop    %ebx
  801802:	5d                   	pop    %ebp
  801803:	c3                   	ret    

00801804 <seek>:

int
seek(int fdnum, off_t offset)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80180a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80180d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	89 04 24             	mov    %eax,(%esp)
  801817:	e8 ea fb ff ff       	call   801406 <fd_lookup>
  80181c:	85 c0                	test   %eax,%eax
  80181e:	78 0e                	js     80182e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801820:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801829:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	53                   	push   %ebx
  801834:	83 ec 24             	sub    $0x24,%esp
  801837:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80183a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80183d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801841:	89 1c 24             	mov    %ebx,(%esp)
  801844:	e8 bd fb ff ff       	call   801406 <fd_lookup>
  801849:	89 c2                	mov    %eax,%edx
  80184b:	85 d2                	test   %edx,%edx
  80184d:	78 61                	js     8018b0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80184f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801852:	89 44 24 04          	mov    %eax,0x4(%esp)
  801856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801859:	8b 00                	mov    (%eax),%eax
  80185b:	89 04 24             	mov    %eax,(%esp)
  80185e:	e8 f9 fb ff ff       	call   80145c <dev_lookup>
  801863:	85 c0                	test   %eax,%eax
  801865:	78 49                	js     8018b0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80186e:	75 23                	jne    801893 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801870:	a1 18 50 80 00       	mov    0x805018,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801875:	8b 40 48             	mov    0x48(%eax),%eax
  801878:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80187c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801880:	c7 04 24 ec 2e 80 00 	movl   $0x802eec,(%esp)
  801887:	e8 8f ed ff ff       	call   80061b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80188c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801891:	eb 1d                	jmp    8018b0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801896:	8b 52 18             	mov    0x18(%edx),%edx
  801899:	85 d2                	test   %edx,%edx
  80189b:	74 0e                	je     8018ab <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80189d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018a4:	89 04 24             	mov    %eax,(%esp)
  8018a7:	ff d2                	call   *%edx
  8018a9:	eb 05                	jmp    8018b0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018b0:	83 c4 24             	add    $0x24,%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	53                   	push   %ebx
  8018ba:	83 ec 24             	sub    $0x24,%esp
  8018bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	89 04 24             	mov    %eax,(%esp)
  8018cd:	e8 34 fb ff ff       	call   801406 <fd_lookup>
  8018d2:	89 c2                	mov    %eax,%edx
  8018d4:	85 d2                	test   %edx,%edx
  8018d6:	78 52                	js     80192a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e2:	8b 00                	mov    (%eax),%eax
  8018e4:	89 04 24             	mov    %eax,(%esp)
  8018e7:	e8 70 fb ff ff       	call   80145c <dev_lookup>
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 3a                	js     80192a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8018f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018f7:	74 2c                	je     801925 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018f9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018fc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801903:	00 00 00 
	stat->st_isdir = 0;
  801906:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80190d:	00 00 00 
	stat->st_dev = dev;
  801910:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801916:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80191a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80191d:	89 14 24             	mov    %edx,(%esp)
  801920:	ff 50 14             	call   *0x14(%eax)
  801923:	eb 05                	jmp    80192a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801925:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80192a:	83 c4 24             	add    $0x24,%esp
  80192d:	5b                   	pop    %ebx
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    

00801930 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	56                   	push   %esi
  801934:	53                   	push   %ebx
  801935:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801938:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80193f:	00 
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	89 04 24             	mov    %eax,(%esp)
  801946:	e8 28 02 00 00       	call   801b73 <open>
  80194b:	89 c3                	mov    %eax,%ebx
  80194d:	85 db                	test   %ebx,%ebx
  80194f:	78 1b                	js     80196c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	89 44 24 04          	mov    %eax,0x4(%esp)
  801958:	89 1c 24             	mov    %ebx,(%esp)
  80195b:	e8 56 ff ff ff       	call   8018b6 <fstat>
  801960:	89 c6                	mov    %eax,%esi
	close(fd);
  801962:	89 1c 24             	mov    %ebx,(%esp)
  801965:	e8 cd fb ff ff       	call   801537 <close>
	return r;
  80196a:	89 f0                	mov    %esi,%eax
}
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	5b                   	pop    %ebx
  801970:	5e                   	pop    %esi
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    

00801973 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	83 ec 10             	sub    $0x10,%esp
  80197b:	89 c6                	mov    %eax,%esi
  80197d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80197f:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801986:	75 11                	jne    801999 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801988:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80198f:	e8 d0 0d 00 00       	call   802764 <ipc_find_env>
  801994:	a3 10 50 80 00       	mov    %eax,0x805010
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801999:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019a0:	00 
  8019a1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8019a8:	00 
  8019a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019ad:	a1 10 50 80 00       	mov    0x805010,%eax
  8019b2:	89 04 24             	mov    %eax,(%esp)
  8019b5:	e8 4c 0d 00 00       	call   802706 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019c1:	00 
  8019c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019cd:	e8 ca 0c 00 00       	call   80269c <ipc_recv>
}
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	5b                   	pop    %ebx
  8019d6:	5e                   	pop    %esi
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    

008019d9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8019ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ed:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8019fc:	e8 72 ff ff ff       	call   801973 <fsipc>
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a0f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a14:	ba 00 00 00 00       	mov    $0x0,%edx
  801a19:	b8 06 00 00 00       	mov    $0x6,%eax
  801a1e:	e8 50 ff ff ff       	call   801973 <fsipc>
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	53                   	push   %ebx
  801a29:	83 ec 14             	sub    $0x14,%esp
  801a2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8b 40 0c             	mov    0xc(%eax),%eax
  801a35:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a44:	e8 2a ff ff ff       	call   801973 <fsipc>
  801a49:	89 c2                	mov    %eax,%edx
  801a4b:	85 d2                	test   %edx,%edx
  801a4d:	78 2b                	js     801a7a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a4f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a56:	00 
  801a57:	89 1c 24             	mov    %ebx,(%esp)
  801a5a:	e8 e8 f1 ff ff       	call   800c47 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a5f:	a1 80 60 80 00       	mov    0x806080,%eax
  801a64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a6a:	a1 84 60 80 00       	mov    0x806084,%eax
  801a6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7a:	83 c4 14             	add    $0x14,%esp
  801a7d:	5b                   	pop    %ebx
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    

00801a80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 18             	sub    $0x18,%esp
  801a86:	8b 45 10             	mov    0x10(%ebp),%eax
  801a89:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a8e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a93:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801a96:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a9b:	8b 55 08             	mov    0x8(%ebp),%edx
  801a9e:	8b 52 0c             	mov    0xc(%edx),%edx
  801aa1:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801aa7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab2:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801ab9:	e8 26 f3 ff ff       	call   800de4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801abe:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac3:	b8 04 00 00 00       	mov    $0x4,%eax
  801ac8:	e8 a6 fe ff ff       	call   801973 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 10             	sub    $0x10,%esp
  801ad7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ae5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  801af0:	b8 03 00 00 00       	mov    $0x3,%eax
  801af5:	e8 79 fe ff ff       	call   801973 <fsipc>
  801afa:	89 c3                	mov    %eax,%ebx
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 6a                	js     801b6a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b00:	39 c6                	cmp    %eax,%esi
  801b02:	73 24                	jae    801b28 <devfile_read+0x59>
  801b04:	c7 44 24 0c 5c 2f 80 	movl   $0x802f5c,0xc(%esp)
  801b0b:	00 
  801b0c:	c7 44 24 08 63 2f 80 	movl   $0x802f63,0x8(%esp)
  801b13:	00 
  801b14:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801b1b:	00 
  801b1c:	c7 04 24 78 2f 80 00 	movl   $0x802f78,(%esp)
  801b23:	e8 1e 0b 00 00       	call   802646 <_panic>
	assert(r <= PGSIZE);
  801b28:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b2d:	7e 24                	jle    801b53 <devfile_read+0x84>
  801b2f:	c7 44 24 0c 83 2f 80 	movl   $0x802f83,0xc(%esp)
  801b36:	00 
  801b37:	c7 44 24 08 63 2f 80 	movl   $0x802f63,0x8(%esp)
  801b3e:	00 
  801b3f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801b46:	00 
  801b47:	c7 04 24 78 2f 80 00 	movl   $0x802f78,(%esp)
  801b4e:	e8 f3 0a 00 00       	call   802646 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b53:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b57:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b5e:	00 
  801b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b62:	89 04 24             	mov    %eax,(%esp)
  801b65:	e8 7a f2 ff ff       	call   800de4 <memmove>
	return r;
}
  801b6a:	89 d8                	mov    %ebx,%eax
  801b6c:	83 c4 10             	add    $0x10,%esp
  801b6f:	5b                   	pop    %ebx
  801b70:	5e                   	pop    %esi
  801b71:	5d                   	pop    %ebp
  801b72:	c3                   	ret    

00801b73 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	53                   	push   %ebx
  801b77:	83 ec 24             	sub    $0x24,%esp
  801b7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b7d:	89 1c 24             	mov    %ebx,(%esp)
  801b80:	e8 8b f0 ff ff       	call   800c10 <strlen>
  801b85:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b8a:	7f 60                	jg     801bec <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8f:	89 04 24             	mov    %eax,(%esp)
  801b92:	e8 20 f8 ff ff       	call   8013b7 <fd_alloc>
  801b97:	89 c2                	mov    %eax,%edx
  801b99:	85 d2                	test   %edx,%edx
  801b9b:	78 54                	js     801bf1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b9d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ba1:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801ba8:	e8 9a f0 ff ff       	call   800c47 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb0:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbd:	e8 b1 fd ff ff       	call   801973 <fsipc>
  801bc2:	89 c3                	mov    %eax,%ebx
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	79 17                	jns    801bdf <open+0x6c>
		fd_close(fd, 0);
  801bc8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bcf:	00 
  801bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd3:	89 04 24             	mov    %eax,(%esp)
  801bd6:	e8 db f8 ff ff       	call   8014b6 <fd_close>
		return r;
  801bdb:	89 d8                	mov    %ebx,%eax
  801bdd:	eb 12                	jmp    801bf1 <open+0x7e>
	}

	return fd2num(fd);
  801bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be2:	89 04 24             	mov    %eax,(%esp)
  801be5:	e8 a6 f7 ff ff       	call   801390 <fd2num>
  801bea:	eb 05                	jmp    801bf1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801bec:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801bf1:	83 c4 24             	add    $0x24,%esp
  801bf4:	5b                   	pop    %ebx
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    

00801bf7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bfd:	ba 00 00 00 00       	mov    $0x0,%edx
  801c02:	b8 08 00 00 00       	mov    $0x8,%eax
  801c07:	e8 67 fd ff ff       	call   801973 <fsipc>
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    
  801c0e:	66 90                	xchg   %ax,%ax

00801c10 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c16:	c7 44 24 04 8f 2f 80 	movl   $0x802f8f,0x4(%esp)
  801c1d:	00 
  801c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c21:	89 04 24             	mov    %eax,(%esp)
  801c24:	e8 1e f0 ff ff       	call   800c47 <strcpy>
	return 0;
}
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	53                   	push   %ebx
  801c34:	83 ec 14             	sub    $0x14,%esp
  801c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c3a:	89 1c 24             	mov    %ebx,(%esp)
  801c3d:	e8 5a 0b 00 00       	call   80279c <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801c42:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801c47:	83 f8 01             	cmp    $0x1,%eax
  801c4a:	75 0d                	jne    801c59 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801c4c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801c4f:	89 04 24             	mov    %eax,(%esp)
  801c52:	e8 29 03 00 00       	call   801f80 <nsipc_close>
  801c57:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801c59:	89 d0                	mov    %edx,%eax
  801c5b:	83 c4 14             	add    $0x14,%esp
  801c5e:	5b                   	pop    %ebx
  801c5f:	5d                   	pop    %ebp
  801c60:	c3                   	ret    

00801c61 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c67:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c6e:	00 
  801c6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c72:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	8b 40 0c             	mov    0xc(%eax),%eax
  801c83:	89 04 24             	mov    %eax,(%esp)
  801c86:	e8 f0 03 00 00       	call   80207b <nsipc_send>
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c93:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c9a:	00 
  801c9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	8b 40 0c             	mov    0xc(%eax),%eax
  801caf:	89 04 24             	mov    %eax,(%esp)
  801cb2:	e8 44 03 00 00       	call   801ffb <nsipc_recv>
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801cbf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801cc2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cc6:	89 04 24             	mov    %eax,(%esp)
  801cc9:	e8 38 f7 ff ff       	call   801406 <fd_lookup>
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	78 17                	js     801ce9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd5:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  801cdb:	39 08                	cmp    %ecx,(%eax)
  801cdd:	75 05                	jne    801ce4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801cdf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce2:	eb 05                	jmp    801ce9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ce4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	56                   	push   %esi
  801cef:	53                   	push   %ebx
  801cf0:	83 ec 20             	sub    $0x20,%esp
  801cf3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801cf5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf8:	89 04 24             	mov    %eax,(%esp)
  801cfb:	e8 b7 f6 ff ff       	call   8013b7 <fd_alloc>
  801d00:	89 c3                	mov    %eax,%ebx
  801d02:	85 c0                	test   %eax,%eax
  801d04:	78 21                	js     801d27 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d06:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d0d:	00 
  801d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d1c:	e8 42 f3 ff ff       	call   801063 <sys_page_alloc>
  801d21:	89 c3                	mov    %eax,%ebx
  801d23:	85 c0                	test   %eax,%eax
  801d25:	79 0c                	jns    801d33 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801d27:	89 34 24             	mov    %esi,(%esp)
  801d2a:	e8 51 02 00 00       	call   801f80 <nsipc_close>
		return r;
  801d2f:	89 d8                	mov    %ebx,%eax
  801d31:	eb 20                	jmp    801d53 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d33:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d41:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801d48:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801d4b:	89 14 24             	mov    %edx,(%esp)
  801d4e:	e8 3d f6 ff ff       	call   801390 <fd2num>
}
  801d53:	83 c4 20             	add    $0x20,%esp
  801d56:	5b                   	pop    %ebx
  801d57:	5e                   	pop    %esi
  801d58:	5d                   	pop    %ebp
  801d59:	c3                   	ret    

00801d5a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	e8 51 ff ff ff       	call   801cb9 <fd2sockid>
		return r;
  801d68:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	78 23                	js     801d91 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d6e:	8b 55 10             	mov    0x10(%ebp),%edx
  801d71:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d78:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d7c:	89 04 24             	mov    %eax,(%esp)
  801d7f:	e8 45 01 00 00       	call   801ec9 <nsipc_accept>
		return r;
  801d84:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d86:	85 c0                	test   %eax,%eax
  801d88:	78 07                	js     801d91 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801d8a:	e8 5c ff ff ff       	call   801ceb <alloc_sockfd>
  801d8f:	89 c1                	mov    %eax,%ecx
}
  801d91:	89 c8                	mov    %ecx,%eax
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	e8 16 ff ff ff       	call   801cb9 <fd2sockid>
  801da3:	89 c2                	mov    %eax,%edx
  801da5:	85 d2                	test   %edx,%edx
  801da7:	78 16                	js     801dbf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801da9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dac:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db7:	89 14 24             	mov    %edx,(%esp)
  801dba:	e8 60 01 00 00       	call   801f1f <nsipc_bind>
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <shutdown>:

int
shutdown(int s, int how)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	e8 ea fe ff ff       	call   801cb9 <fd2sockid>
  801dcf:	89 c2                	mov    %eax,%edx
  801dd1:	85 d2                	test   %edx,%edx
  801dd3:	78 0f                	js     801de4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddc:	89 14 24             	mov    %edx,(%esp)
  801ddf:	e8 7a 01 00 00       	call   801f5e <nsipc_shutdown>
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	e8 c5 fe ff ff       	call   801cb9 <fd2sockid>
  801df4:	89 c2                	mov    %eax,%edx
  801df6:	85 d2                	test   %edx,%edx
  801df8:	78 16                	js     801e10 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801dfa:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e08:	89 14 24             	mov    %edx,(%esp)
  801e0b:	e8 8a 01 00 00       	call   801f9a <nsipc_connect>
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <listen>:

int
listen(int s, int backlog)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	e8 99 fe ff ff       	call   801cb9 <fd2sockid>
  801e20:	89 c2                	mov    %eax,%edx
  801e22:	85 d2                	test   %edx,%edx
  801e24:	78 0f                	js     801e35 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2d:	89 14 24             	mov    %edx,(%esp)
  801e30:	e8 a4 01 00 00       	call   801fd9 <nsipc_listen>
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e40:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	89 04 24             	mov    %eax,(%esp)
  801e51:	e8 98 02 00 00       	call   8020ee <nsipc_socket>
  801e56:	89 c2                	mov    %eax,%edx
  801e58:	85 d2                	test   %edx,%edx
  801e5a:	78 05                	js     801e61 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801e5c:	e8 8a fe ff ff       	call   801ceb <alloc_sockfd>
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	53                   	push   %ebx
  801e67:	83 ec 14             	sub    $0x14,%esp
  801e6a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e6c:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801e73:	75 11                	jne    801e86 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e75:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801e7c:	e8 e3 08 00 00       	call   802764 <ipc_find_env>
  801e81:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e86:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e8d:	00 
  801e8e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801e95:	00 
  801e96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e9a:	a1 14 50 80 00       	mov    0x805014,%eax
  801e9f:	89 04 24             	mov    %eax,(%esp)
  801ea2:	e8 5f 08 00 00       	call   802706 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ea7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801eae:	00 
  801eaf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801eb6:	00 
  801eb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ebe:	e8 d9 07 00 00       	call   80269c <ipc_recv>
}
  801ec3:	83 c4 14             	add    $0x14,%esp
  801ec6:	5b                   	pop    %ebx
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    

00801ec9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	56                   	push   %esi
  801ecd:	53                   	push   %ebx
  801ece:	83 ec 10             	sub    $0x10,%esp
  801ed1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801edc:	8b 06                	mov    (%esi),%eax
  801ede:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ee3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee8:	e8 76 ff ff ff       	call   801e63 <nsipc>
  801eed:	89 c3                	mov    %eax,%ebx
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	78 23                	js     801f16 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ef3:	a1 10 70 80 00       	mov    0x807010,%eax
  801ef8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801efc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801f03:	00 
  801f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f07:	89 04 24             	mov    %eax,(%esp)
  801f0a:	e8 d5 ee ff ff       	call   800de4 <memmove>
		*addrlen = ret->ret_addrlen;
  801f0f:	a1 10 70 80 00       	mov    0x807010,%eax
  801f14:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801f16:	89 d8                	mov    %ebx,%eax
  801f18:	83 c4 10             	add    $0x10,%esp
  801f1b:	5b                   	pop    %ebx
  801f1c:	5e                   	pop    %esi
  801f1d:	5d                   	pop    %ebp
  801f1e:	c3                   	ret    

00801f1f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	53                   	push   %ebx
  801f23:	83 ec 14             	sub    $0x14,%esp
  801f26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f31:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801f43:	e8 9c ee ff ff       	call   800de4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f48:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f4e:	b8 02 00 00 00       	mov    $0x2,%eax
  801f53:	e8 0b ff ff ff       	call   801e63 <nsipc>
}
  801f58:	83 c4 14             	add    $0x14,%esp
  801f5b:	5b                   	pop    %ebx
  801f5c:	5d                   	pop    %ebp
  801f5d:	c3                   	ret    

00801f5e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801f74:	b8 03 00 00 00       	mov    $0x3,%eax
  801f79:	e8 e5 fe ff ff       	call   801e63 <nsipc>
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <nsipc_close>:

int
nsipc_close(int s)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801f8e:	b8 04 00 00 00       	mov    $0x4,%eax
  801f93:	e8 cb fe ff ff       	call   801e63 <nsipc>
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	53                   	push   %ebx
  801f9e:	83 ec 14             	sub    $0x14,%esp
  801fa1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801fbe:	e8 21 ee ff ff       	call   800de4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801fc3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801fc9:	b8 05 00 00 00       	mov    $0x5,%eax
  801fce:	e8 90 fe ff ff       	call   801e63 <nsipc>
}
  801fd3:	83 c4 14             	add    $0x14,%esp
  801fd6:	5b                   	pop    %ebx
  801fd7:	5d                   	pop    %ebp
  801fd8:	c3                   	ret    

00801fd9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fea:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801fef:	b8 06 00 00 00       	mov    $0x6,%eax
  801ff4:	e8 6a fe ff ff       	call   801e63 <nsipc>
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	56                   	push   %esi
  801fff:	53                   	push   %ebx
  802000:	83 ec 10             	sub    $0x10,%esp
  802003:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80200e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802014:	8b 45 14             	mov    0x14(%ebp),%eax
  802017:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80201c:	b8 07 00 00 00       	mov    $0x7,%eax
  802021:	e8 3d fe ff ff       	call   801e63 <nsipc>
  802026:	89 c3                	mov    %eax,%ebx
  802028:	85 c0                	test   %eax,%eax
  80202a:	78 46                	js     802072 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80202c:	39 f0                	cmp    %esi,%eax
  80202e:	7f 07                	jg     802037 <nsipc_recv+0x3c>
  802030:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802035:	7e 24                	jle    80205b <nsipc_recv+0x60>
  802037:	c7 44 24 0c 9b 2f 80 	movl   $0x802f9b,0xc(%esp)
  80203e:	00 
  80203f:	c7 44 24 08 63 2f 80 	movl   $0x802f63,0x8(%esp)
  802046:	00 
  802047:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80204e:	00 
  80204f:	c7 04 24 b0 2f 80 00 	movl   $0x802fb0,(%esp)
  802056:	e8 eb 05 00 00       	call   802646 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80205b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80205f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802066:	00 
  802067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206a:	89 04 24             	mov    %eax,(%esp)
  80206d:	e8 72 ed ff ff       	call   800de4 <memmove>
	}

	return r;
}
  802072:	89 d8                	mov    %ebx,%eax
  802074:	83 c4 10             	add    $0x10,%esp
  802077:	5b                   	pop    %ebx
  802078:	5e                   	pop    %esi
  802079:	5d                   	pop    %ebp
  80207a:	c3                   	ret    

0080207b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	53                   	push   %ebx
  80207f:	83 ec 14             	sub    $0x14,%esp
  802082:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80208d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802093:	7e 24                	jle    8020b9 <nsipc_send+0x3e>
  802095:	c7 44 24 0c bc 2f 80 	movl   $0x802fbc,0xc(%esp)
  80209c:	00 
  80209d:	c7 44 24 08 63 2f 80 	movl   $0x802f63,0x8(%esp)
  8020a4:	00 
  8020a5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8020ac:	00 
  8020ad:	c7 04 24 b0 2f 80 00 	movl   $0x802fb0,(%esp)
  8020b4:	e8 8d 05 00 00       	call   802646 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8020cb:	e8 14 ed ff ff       	call   800de4 <memmove>
	nsipcbuf.send.req_size = size;
  8020d0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8020d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8020de:	b8 08 00 00 00       	mov    $0x8,%eax
  8020e3:	e8 7b fd ff ff       	call   801e63 <nsipc>
}
  8020e8:	83 c4 14             	add    $0x14,%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5d                   	pop    %ebp
  8020ed:	c3                   	ret    

008020ee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8020fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ff:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802104:	8b 45 10             	mov    0x10(%ebp),%eax
  802107:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80210c:	b8 09 00 00 00       	mov    $0x9,%eax
  802111:	e8 4d fd ff ff       	call   801e63 <nsipc>
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	56                   	push   %esi
  80211c:	53                   	push   %ebx
  80211d:	83 ec 10             	sub    $0x10,%esp
  802120:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	89 04 24             	mov    %eax,(%esp)
  802129:	e8 72 f2 ff ff       	call   8013a0 <fd2data>
  80212e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802130:	c7 44 24 04 c8 2f 80 	movl   $0x802fc8,0x4(%esp)
  802137:	00 
  802138:	89 1c 24             	mov    %ebx,(%esp)
  80213b:	e8 07 eb ff ff       	call   800c47 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802140:	8b 46 04             	mov    0x4(%esi),%eax
  802143:	2b 06                	sub    (%esi),%eax
  802145:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80214b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802152:	00 00 00 
	stat->st_dev = &devpipe;
  802155:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80215c:	40 80 00 
	return 0;
}
  80215f:	b8 00 00 00 00       	mov    $0x0,%eax
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	5b                   	pop    %ebx
  802168:	5e                   	pop    %esi
  802169:	5d                   	pop    %ebp
  80216a:	c3                   	ret    

0080216b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	53                   	push   %ebx
  80216f:	83 ec 14             	sub    $0x14,%esp
  802172:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802175:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802179:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802180:	e8 85 ef ff ff       	call   80110a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802185:	89 1c 24             	mov    %ebx,(%esp)
  802188:	e8 13 f2 ff ff       	call   8013a0 <fd2data>
  80218d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802191:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802198:	e8 6d ef ff ff       	call   80110a <sys_page_unmap>
}
  80219d:	83 c4 14             	add    $0x14,%esp
  8021a0:	5b                   	pop    %ebx
  8021a1:	5d                   	pop    %ebp
  8021a2:	c3                   	ret    

008021a3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	57                   	push   %edi
  8021a7:	56                   	push   %esi
  8021a8:	53                   	push   %ebx
  8021a9:	83 ec 2c             	sub    $0x2c,%esp
  8021ac:	89 c6                	mov    %eax,%esi
  8021ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8021b1:	a1 18 50 80 00       	mov    0x805018,%eax
  8021b6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021b9:	89 34 24             	mov    %esi,(%esp)
  8021bc:	e8 db 05 00 00       	call   80279c <pageref>
  8021c1:	89 c7                	mov    %eax,%edi
  8021c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021c6:	89 04 24             	mov    %eax,(%esp)
  8021c9:	e8 ce 05 00 00       	call   80279c <pageref>
  8021ce:	39 c7                	cmp    %eax,%edi
  8021d0:	0f 94 c2             	sete   %dl
  8021d3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8021d6:	8b 0d 18 50 80 00    	mov    0x805018,%ecx
  8021dc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8021df:	39 fb                	cmp    %edi,%ebx
  8021e1:	74 21                	je     802204 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8021e3:	84 d2                	test   %dl,%dl
  8021e5:	74 ca                	je     8021b1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021e7:	8b 51 58             	mov    0x58(%ecx),%edx
  8021ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021ee:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021f6:	c7 04 24 cf 2f 80 00 	movl   $0x802fcf,(%esp)
  8021fd:	e8 19 e4 ff ff       	call   80061b <cprintf>
  802202:	eb ad                	jmp    8021b1 <_pipeisclosed+0xe>
	}
}
  802204:	83 c4 2c             	add    $0x2c,%esp
  802207:	5b                   	pop    %ebx
  802208:	5e                   	pop    %esi
  802209:	5f                   	pop    %edi
  80220a:	5d                   	pop    %ebp
  80220b:	c3                   	ret    

0080220c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	57                   	push   %edi
  802210:	56                   	push   %esi
  802211:	53                   	push   %ebx
  802212:	83 ec 1c             	sub    $0x1c,%esp
  802215:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802218:	89 34 24             	mov    %esi,(%esp)
  80221b:	e8 80 f1 ff ff       	call   8013a0 <fd2data>
  802220:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802222:	bf 00 00 00 00       	mov    $0x0,%edi
  802227:	eb 45                	jmp    80226e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802229:	89 da                	mov    %ebx,%edx
  80222b:	89 f0                	mov    %esi,%eax
  80222d:	e8 71 ff ff ff       	call   8021a3 <_pipeisclosed>
  802232:	85 c0                	test   %eax,%eax
  802234:	75 41                	jne    802277 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802236:	e8 09 ee ff ff       	call   801044 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80223b:	8b 43 04             	mov    0x4(%ebx),%eax
  80223e:	8b 0b                	mov    (%ebx),%ecx
  802240:	8d 51 20             	lea    0x20(%ecx),%edx
  802243:	39 d0                	cmp    %edx,%eax
  802245:	73 e2                	jae    802229 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802247:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80224a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80224e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802251:	99                   	cltd   
  802252:	c1 ea 1b             	shr    $0x1b,%edx
  802255:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802258:	83 e1 1f             	and    $0x1f,%ecx
  80225b:	29 d1                	sub    %edx,%ecx
  80225d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802261:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802265:	83 c0 01             	add    $0x1,%eax
  802268:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80226b:	83 c7 01             	add    $0x1,%edi
  80226e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802271:	75 c8                	jne    80223b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802273:	89 f8                	mov    %edi,%eax
  802275:	eb 05                	jmp    80227c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802277:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80227c:	83 c4 1c             	add    $0x1c,%esp
  80227f:	5b                   	pop    %ebx
  802280:	5e                   	pop    %esi
  802281:	5f                   	pop    %edi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    

00802284 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	57                   	push   %edi
  802288:	56                   	push   %esi
  802289:	53                   	push   %ebx
  80228a:	83 ec 1c             	sub    $0x1c,%esp
  80228d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802290:	89 3c 24             	mov    %edi,(%esp)
  802293:	e8 08 f1 ff ff       	call   8013a0 <fd2data>
  802298:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80229a:	be 00 00 00 00       	mov    $0x0,%esi
  80229f:	eb 3d                	jmp    8022de <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8022a1:	85 f6                	test   %esi,%esi
  8022a3:	74 04                	je     8022a9 <devpipe_read+0x25>
				return i;
  8022a5:	89 f0                	mov    %esi,%eax
  8022a7:	eb 43                	jmp    8022ec <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8022a9:	89 da                	mov    %ebx,%edx
  8022ab:	89 f8                	mov    %edi,%eax
  8022ad:	e8 f1 fe ff ff       	call   8021a3 <_pipeisclosed>
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	75 31                	jne    8022e7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8022b6:	e8 89 ed ff ff       	call   801044 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8022bb:	8b 03                	mov    (%ebx),%eax
  8022bd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022c0:	74 df                	je     8022a1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022c2:	99                   	cltd   
  8022c3:	c1 ea 1b             	shr    $0x1b,%edx
  8022c6:	01 d0                	add    %edx,%eax
  8022c8:	83 e0 1f             	and    $0x1f,%eax
  8022cb:	29 d0                	sub    %edx,%eax
  8022cd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022d5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022d8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022db:	83 c6 01             	add    $0x1,%esi
  8022de:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022e1:	75 d8                	jne    8022bb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8022e3:	89 f0                	mov    %esi,%eax
  8022e5:	eb 05                	jmp    8022ec <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8022e7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8022ec:	83 c4 1c             	add    $0x1c,%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5e                   	pop    %esi
  8022f1:	5f                   	pop    %edi
  8022f2:	5d                   	pop    %ebp
  8022f3:	c3                   	ret    

008022f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	56                   	push   %esi
  8022f8:	53                   	push   %ebx
  8022f9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8022fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ff:	89 04 24             	mov    %eax,(%esp)
  802302:	e8 b0 f0 ff ff       	call   8013b7 <fd_alloc>
  802307:	89 c2                	mov    %eax,%edx
  802309:	85 d2                	test   %edx,%edx
  80230b:	0f 88 4d 01 00 00    	js     80245e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802311:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802318:	00 
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802320:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802327:	e8 37 ed ff ff       	call   801063 <sys_page_alloc>
  80232c:	89 c2                	mov    %eax,%edx
  80232e:	85 d2                	test   %edx,%edx
  802330:	0f 88 28 01 00 00    	js     80245e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802336:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802339:	89 04 24             	mov    %eax,(%esp)
  80233c:	e8 76 f0 ff ff       	call   8013b7 <fd_alloc>
  802341:	89 c3                	mov    %eax,%ebx
  802343:	85 c0                	test   %eax,%eax
  802345:	0f 88 fe 00 00 00    	js     802449 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80234b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802352:	00 
  802353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802356:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802361:	e8 fd ec ff ff       	call   801063 <sys_page_alloc>
  802366:	89 c3                	mov    %eax,%ebx
  802368:	85 c0                	test   %eax,%eax
  80236a:	0f 88 d9 00 00 00    	js     802449 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	89 04 24             	mov    %eax,(%esp)
  802376:	e8 25 f0 ff ff       	call   8013a0 <fd2data>
  80237b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80237d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802384:	00 
  802385:	89 44 24 04          	mov    %eax,0x4(%esp)
  802389:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802390:	e8 ce ec ff ff       	call   801063 <sys_page_alloc>
  802395:	89 c3                	mov    %eax,%ebx
  802397:	85 c0                	test   %eax,%eax
  802399:	0f 88 97 00 00 00    	js     802436 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80239f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a2:	89 04 24             	mov    %eax,(%esp)
  8023a5:	e8 f6 ef ff ff       	call   8013a0 <fd2data>
  8023aa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8023b1:	00 
  8023b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023bd:	00 
  8023be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023c9:	e8 e9 ec ff ff       	call   8010b7 <sys_page_map>
  8023ce:	89 c3                	mov    %eax,%ebx
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	78 52                	js     802426 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8023d4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8023e9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8023f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	89 04 24             	mov    %eax,(%esp)
  802404:	e8 87 ef ff ff       	call   801390 <fd2num>
  802409:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80240c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80240e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802411:	89 04 24             	mov    %eax,(%esp)
  802414:	e8 77 ef ff ff       	call   801390 <fd2num>
  802419:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80241c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
  802424:	eb 38                	jmp    80245e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802426:	89 74 24 04          	mov    %esi,0x4(%esp)
  80242a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802431:	e8 d4 ec ff ff       	call   80110a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802439:	89 44 24 04          	mov    %eax,0x4(%esp)
  80243d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802444:	e8 c1 ec ff ff       	call   80110a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802450:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802457:	e8 ae ec ff ff       	call   80110a <sys_page_unmap>
  80245c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80245e:	83 c4 30             	add    $0x30,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5d                   	pop    %ebp
  802464:	c3                   	ret    

00802465 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80246b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80246e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	89 04 24             	mov    %eax,(%esp)
  802478:	e8 89 ef ff ff       	call   801406 <fd_lookup>
  80247d:	89 c2                	mov    %eax,%edx
  80247f:	85 d2                	test   %edx,%edx
  802481:	78 15                	js     802498 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	89 04 24             	mov    %eax,(%esp)
  802489:	e8 12 ef ff ff       	call   8013a0 <fd2data>
	return _pipeisclosed(fd, p);
  80248e:	89 c2                	mov    %eax,%edx
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	e8 0b fd ff ff       	call   8021a3 <_pipeisclosed>
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    
  80249a:	66 90                	xchg   %ax,%ax
  80249c:	66 90                	xchg   %ax,%ax
  80249e:	66 90                	xchg   %ax,%ax

008024a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	5d                   	pop    %ebp
  8024a9:	c3                   	ret    

008024aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8024b0:	c7 44 24 04 e7 2f 80 	movl   $0x802fe7,0x4(%esp)
  8024b7:	00 
  8024b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bb:	89 04 24             	mov    %eax,(%esp)
  8024be:	e8 84 e7 ff ff       	call   800c47 <strcpy>
	return 0;
}
  8024c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	57                   	push   %edi
  8024ce:	56                   	push   %esi
  8024cf:	53                   	push   %ebx
  8024d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8024db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024e1:	eb 31                	jmp    802514 <devcons_write+0x4a>
		m = n - tot;
  8024e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8024e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8024e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8024eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8024f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8024f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8024f7:	03 45 0c             	add    0xc(%ebp),%eax
  8024fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024fe:	89 3c 24             	mov    %edi,(%esp)
  802501:	e8 de e8 ff ff       	call   800de4 <memmove>
		sys_cputs(buf, m);
  802506:	89 74 24 04          	mov    %esi,0x4(%esp)
  80250a:	89 3c 24             	mov    %edi,(%esp)
  80250d:	e8 84 ea ff ff       	call   800f96 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802512:	01 f3                	add    %esi,%ebx
  802514:	89 d8                	mov    %ebx,%eax
  802516:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802519:	72 c8                	jb     8024e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80251b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    

00802526 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80252c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802531:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802535:	75 07                	jne    80253e <devcons_read+0x18>
  802537:	eb 2a                	jmp    802563 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802539:	e8 06 eb ff ff       	call   801044 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80253e:	66 90                	xchg   %ax,%ax
  802540:	e8 6f ea ff ff       	call   800fb4 <sys_cgetc>
  802545:	85 c0                	test   %eax,%eax
  802547:	74 f0                	je     802539 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802549:	85 c0                	test   %eax,%eax
  80254b:	78 16                	js     802563 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80254d:	83 f8 04             	cmp    $0x4,%eax
  802550:	74 0c                	je     80255e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802552:	8b 55 0c             	mov    0xc(%ebp),%edx
  802555:	88 02                	mov    %al,(%edx)
	return 1;
  802557:	b8 01 00 00 00       	mov    $0x1,%eax
  80255c:	eb 05                	jmp    802563 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
  802568:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802571:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802578:	00 
  802579:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80257c:	89 04 24             	mov    %eax,(%esp)
  80257f:	e8 12 ea ff ff       	call   800f96 <sys_cputs>
}
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <getchar>:

int
getchar(void)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80258c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802593:	00 
  802594:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802597:	89 44 24 04          	mov    %eax,0x4(%esp)
  80259b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a2:	e8 f3 f0 ff ff       	call   80169a <read>
	if (r < 0)
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	78 0f                	js     8025ba <getchar+0x34>
		return r;
	if (r < 1)
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	7e 06                	jle    8025b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8025af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8025b3:	eb 05                	jmp    8025ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8025b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8025ba:	c9                   	leave  
  8025bb:	c3                   	ret    

008025bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8025bc:	55                   	push   %ebp
  8025bd:	89 e5                	mov    %esp,%ebp
  8025bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	89 04 24             	mov    %eax,(%esp)
  8025cf:	e8 32 ee ff ff       	call   801406 <fd_lookup>
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	78 11                	js     8025e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8025e1:	39 10                	cmp    %edx,(%eax)
  8025e3:	0f 94 c0             	sete   %al
  8025e6:	0f b6 c0             	movzbl %al,%eax
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <opencons>:

int
opencons(void)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8025f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025f4:	89 04 24             	mov    %eax,(%esp)
  8025f7:	e8 bb ed ff ff       	call   8013b7 <fd_alloc>
		return r;
  8025fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8025fe:	85 c0                	test   %eax,%eax
  802600:	78 40                	js     802642 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802602:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802609:	00 
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802611:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802618:	e8 46 ea ff ff       	call   801063 <sys_page_alloc>
		return r;
  80261d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80261f:	85 c0                	test   %eax,%eax
  802621:	78 1f                	js     802642 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802623:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802638:	89 04 24             	mov    %eax,(%esp)
  80263b:	e8 50 ed ff ff       	call   801390 <fd2num>
  802640:	89 c2                	mov    %eax,%edx
}
  802642:	89 d0                	mov    %edx,%eax
  802644:	c9                   	leave  
  802645:	c3                   	ret    

00802646 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	56                   	push   %esi
  80264a:	53                   	push   %ebx
  80264b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80264e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802651:	8b 35 04 40 80 00    	mov    0x804004,%esi
  802657:	e8 c9 e9 ff ff       	call   801025 <sys_getenvid>
  80265c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802663:	8b 55 08             	mov    0x8(%ebp),%edx
  802666:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80266a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80266e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802672:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  802679:	e8 9d df ff ff       	call   80061b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80267e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802682:	8b 45 10             	mov    0x10(%ebp),%eax
  802685:	89 04 24             	mov    %eax,(%esp)
  802688:	e8 2d df ff ff       	call   8005ba <vcprintf>
	cprintf("\n");
  80268d:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  802694:	e8 82 df ff ff       	call   80061b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802699:	cc                   	int3   
  80269a:	eb fd                	jmp    802699 <_panic+0x53>

0080269c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
  80269f:	56                   	push   %esi
  8026a0:	53                   	push   %ebx
  8026a1:	83 ec 10             	sub    $0x10,%esp
  8026a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8026a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026aa:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8026ad:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8026af:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8026b4:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8026b7:	89 04 24             	mov    %eax,(%esp)
  8026ba:	e8 ba eb ff ff       	call   801279 <sys_ipc_recv>
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	75 1e                	jne    8026e1 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  8026c3:	85 db                	test   %ebx,%ebx
  8026c5:	74 0a                	je     8026d1 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8026c7:	a1 18 50 80 00       	mov    0x805018,%eax
  8026cc:	8b 40 74             	mov    0x74(%eax),%eax
  8026cf:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8026d1:	85 f6                	test   %esi,%esi
  8026d3:	74 22                	je     8026f7 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8026d5:	a1 18 50 80 00       	mov    0x805018,%eax
  8026da:	8b 40 78             	mov    0x78(%eax),%eax
  8026dd:	89 06                	mov    %eax,(%esi)
  8026df:	eb 16                	jmp    8026f7 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  8026e1:	85 f6                	test   %esi,%esi
  8026e3:	74 06                	je     8026eb <ipc_recv+0x4f>
				*perm_store = 0;
  8026e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8026eb:	85 db                	test   %ebx,%ebx
  8026ed:	74 10                	je     8026ff <ipc_recv+0x63>
				*from_env_store=0;
  8026ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026f5:	eb 08                	jmp    8026ff <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8026f7:	a1 18 50 80 00       	mov    0x805018,%eax
  8026fc:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8026ff:	83 c4 10             	add    $0x10,%esp
  802702:	5b                   	pop    %ebx
  802703:	5e                   	pop    %esi
  802704:	5d                   	pop    %ebp
  802705:	c3                   	ret    

00802706 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	57                   	push   %edi
  80270a:	56                   	push   %esi
  80270b:	53                   	push   %ebx
  80270c:	83 ec 1c             	sub    $0x1c,%esp
  80270f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802712:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802715:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802718:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  80271a:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  80271f:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802722:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802726:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80272a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80272e:	8b 45 08             	mov    0x8(%ebp),%eax
  802731:	89 04 24             	mov    %eax,(%esp)
  802734:	e8 1d eb ff ff       	call   801256 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802739:	eb 1c                	jmp    802757 <ipc_send+0x51>
	{
		sys_yield();
  80273b:	e8 04 e9 ff ff       	call   801044 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802740:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802744:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802748:	89 74 24 04          	mov    %esi,0x4(%esp)
  80274c:	8b 45 08             	mov    0x8(%ebp),%eax
  80274f:	89 04 24             	mov    %eax,(%esp)
  802752:	e8 ff ea ff ff       	call   801256 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802757:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80275a:	74 df                	je     80273b <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  80275c:	83 c4 1c             	add    $0x1c,%esp
  80275f:	5b                   	pop    %ebx
  802760:	5e                   	pop    %esi
  802761:	5f                   	pop    %edi
  802762:	5d                   	pop    %ebp
  802763:	c3                   	ret    

00802764 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802764:	55                   	push   %ebp
  802765:	89 e5                	mov    %esp,%ebp
  802767:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80276a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80276f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802772:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802778:	8b 52 50             	mov    0x50(%edx),%edx
  80277b:	39 ca                	cmp    %ecx,%edx
  80277d:	75 0d                	jne    80278c <ipc_find_env+0x28>
			return envs[i].env_id;
  80277f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802782:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802787:	8b 40 40             	mov    0x40(%eax),%eax
  80278a:	eb 0e                	jmp    80279a <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80278c:	83 c0 01             	add    $0x1,%eax
  80278f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802794:	75 d9                	jne    80276f <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802796:	66 b8 00 00          	mov    $0x0,%ax
}
  80279a:	5d                   	pop    %ebp
  80279b:	c3                   	ret    

0080279c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
  80279f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027a2:	89 d0                	mov    %edx,%eax
  8027a4:	c1 e8 16             	shr    $0x16,%eax
  8027a7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027ae:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027b3:	f6 c1 01             	test   $0x1,%cl
  8027b6:	74 1d                	je     8027d5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8027b8:	c1 ea 0c             	shr    $0xc,%edx
  8027bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027c2:	f6 c2 01             	test   $0x1,%dl
  8027c5:	74 0e                	je     8027d5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027c7:	c1 ea 0c             	shr    $0xc,%edx
  8027ca:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027d1:	ef 
  8027d2:	0f b7 c0             	movzwl %ax,%eax
}
  8027d5:	5d                   	pop    %ebp
  8027d6:	c3                   	ret    
  8027d7:	66 90                	xchg   %ax,%ax
  8027d9:	66 90                	xchg   %ax,%ax
  8027db:	66 90                	xchg   %ax,%ax
  8027dd:	66 90                	xchg   %ax,%ax
  8027df:	90                   	nop

008027e0 <__udivdi3>:
  8027e0:	55                   	push   %ebp
  8027e1:	57                   	push   %edi
  8027e2:	56                   	push   %esi
  8027e3:	83 ec 0c             	sub    $0xc,%esp
  8027e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8027ea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8027ee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8027f2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8027fc:	89 ea                	mov    %ebp,%edx
  8027fe:	89 0c 24             	mov    %ecx,(%esp)
  802801:	75 2d                	jne    802830 <__udivdi3+0x50>
  802803:	39 e9                	cmp    %ebp,%ecx
  802805:	77 61                	ja     802868 <__udivdi3+0x88>
  802807:	85 c9                	test   %ecx,%ecx
  802809:	89 ce                	mov    %ecx,%esi
  80280b:	75 0b                	jne    802818 <__udivdi3+0x38>
  80280d:	b8 01 00 00 00       	mov    $0x1,%eax
  802812:	31 d2                	xor    %edx,%edx
  802814:	f7 f1                	div    %ecx
  802816:	89 c6                	mov    %eax,%esi
  802818:	31 d2                	xor    %edx,%edx
  80281a:	89 e8                	mov    %ebp,%eax
  80281c:	f7 f6                	div    %esi
  80281e:	89 c5                	mov    %eax,%ebp
  802820:	89 f8                	mov    %edi,%eax
  802822:	f7 f6                	div    %esi
  802824:	89 ea                	mov    %ebp,%edx
  802826:	83 c4 0c             	add    $0xc,%esp
  802829:	5e                   	pop    %esi
  80282a:	5f                   	pop    %edi
  80282b:	5d                   	pop    %ebp
  80282c:	c3                   	ret    
  80282d:	8d 76 00             	lea    0x0(%esi),%esi
  802830:	39 e8                	cmp    %ebp,%eax
  802832:	77 24                	ja     802858 <__udivdi3+0x78>
  802834:	0f bd e8             	bsr    %eax,%ebp
  802837:	83 f5 1f             	xor    $0x1f,%ebp
  80283a:	75 3c                	jne    802878 <__udivdi3+0x98>
  80283c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802840:	39 34 24             	cmp    %esi,(%esp)
  802843:	0f 86 9f 00 00 00    	jbe    8028e8 <__udivdi3+0x108>
  802849:	39 d0                	cmp    %edx,%eax
  80284b:	0f 82 97 00 00 00    	jb     8028e8 <__udivdi3+0x108>
  802851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802858:	31 d2                	xor    %edx,%edx
  80285a:	31 c0                	xor    %eax,%eax
  80285c:	83 c4 0c             	add    $0xc,%esp
  80285f:	5e                   	pop    %esi
  802860:	5f                   	pop    %edi
  802861:	5d                   	pop    %ebp
  802862:	c3                   	ret    
  802863:	90                   	nop
  802864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802868:	89 f8                	mov    %edi,%eax
  80286a:	f7 f1                	div    %ecx
  80286c:	31 d2                	xor    %edx,%edx
  80286e:	83 c4 0c             	add    $0xc,%esp
  802871:	5e                   	pop    %esi
  802872:	5f                   	pop    %edi
  802873:	5d                   	pop    %ebp
  802874:	c3                   	ret    
  802875:	8d 76 00             	lea    0x0(%esi),%esi
  802878:	89 e9                	mov    %ebp,%ecx
  80287a:	8b 3c 24             	mov    (%esp),%edi
  80287d:	d3 e0                	shl    %cl,%eax
  80287f:	89 c6                	mov    %eax,%esi
  802881:	b8 20 00 00 00       	mov    $0x20,%eax
  802886:	29 e8                	sub    %ebp,%eax
  802888:	89 c1                	mov    %eax,%ecx
  80288a:	d3 ef                	shr    %cl,%edi
  80288c:	89 e9                	mov    %ebp,%ecx
  80288e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802892:	8b 3c 24             	mov    (%esp),%edi
  802895:	09 74 24 08          	or     %esi,0x8(%esp)
  802899:	89 d6                	mov    %edx,%esi
  80289b:	d3 e7                	shl    %cl,%edi
  80289d:	89 c1                	mov    %eax,%ecx
  80289f:	89 3c 24             	mov    %edi,(%esp)
  8028a2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8028a6:	d3 ee                	shr    %cl,%esi
  8028a8:	89 e9                	mov    %ebp,%ecx
  8028aa:	d3 e2                	shl    %cl,%edx
  8028ac:	89 c1                	mov    %eax,%ecx
  8028ae:	d3 ef                	shr    %cl,%edi
  8028b0:	09 d7                	or     %edx,%edi
  8028b2:	89 f2                	mov    %esi,%edx
  8028b4:	89 f8                	mov    %edi,%eax
  8028b6:	f7 74 24 08          	divl   0x8(%esp)
  8028ba:	89 d6                	mov    %edx,%esi
  8028bc:	89 c7                	mov    %eax,%edi
  8028be:	f7 24 24             	mull   (%esp)
  8028c1:	39 d6                	cmp    %edx,%esi
  8028c3:	89 14 24             	mov    %edx,(%esp)
  8028c6:	72 30                	jb     8028f8 <__udivdi3+0x118>
  8028c8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028cc:	89 e9                	mov    %ebp,%ecx
  8028ce:	d3 e2                	shl    %cl,%edx
  8028d0:	39 c2                	cmp    %eax,%edx
  8028d2:	73 05                	jae    8028d9 <__udivdi3+0xf9>
  8028d4:	3b 34 24             	cmp    (%esp),%esi
  8028d7:	74 1f                	je     8028f8 <__udivdi3+0x118>
  8028d9:	89 f8                	mov    %edi,%eax
  8028db:	31 d2                	xor    %edx,%edx
  8028dd:	e9 7a ff ff ff       	jmp    80285c <__udivdi3+0x7c>
  8028e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028e8:	31 d2                	xor    %edx,%edx
  8028ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ef:	e9 68 ff ff ff       	jmp    80285c <__udivdi3+0x7c>
  8028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8028fb:	31 d2                	xor    %edx,%edx
  8028fd:	83 c4 0c             	add    $0xc,%esp
  802900:	5e                   	pop    %esi
  802901:	5f                   	pop    %edi
  802902:	5d                   	pop    %ebp
  802903:	c3                   	ret    
  802904:	66 90                	xchg   %ax,%ax
  802906:	66 90                	xchg   %ax,%ax
  802908:	66 90                	xchg   %ax,%ax
  80290a:	66 90                	xchg   %ax,%ax
  80290c:	66 90                	xchg   %ax,%ax
  80290e:	66 90                	xchg   %ax,%ax

00802910 <__umoddi3>:
  802910:	55                   	push   %ebp
  802911:	57                   	push   %edi
  802912:	56                   	push   %esi
  802913:	83 ec 14             	sub    $0x14,%esp
  802916:	8b 44 24 28          	mov    0x28(%esp),%eax
  80291a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80291e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802922:	89 c7                	mov    %eax,%edi
  802924:	89 44 24 04          	mov    %eax,0x4(%esp)
  802928:	8b 44 24 30          	mov    0x30(%esp),%eax
  80292c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802930:	89 34 24             	mov    %esi,(%esp)
  802933:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802937:	85 c0                	test   %eax,%eax
  802939:	89 c2                	mov    %eax,%edx
  80293b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80293f:	75 17                	jne    802958 <__umoddi3+0x48>
  802941:	39 fe                	cmp    %edi,%esi
  802943:	76 4b                	jbe    802990 <__umoddi3+0x80>
  802945:	89 c8                	mov    %ecx,%eax
  802947:	89 fa                	mov    %edi,%edx
  802949:	f7 f6                	div    %esi
  80294b:	89 d0                	mov    %edx,%eax
  80294d:	31 d2                	xor    %edx,%edx
  80294f:	83 c4 14             	add    $0x14,%esp
  802952:	5e                   	pop    %esi
  802953:	5f                   	pop    %edi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    
  802956:	66 90                	xchg   %ax,%ax
  802958:	39 f8                	cmp    %edi,%eax
  80295a:	77 54                	ja     8029b0 <__umoddi3+0xa0>
  80295c:	0f bd e8             	bsr    %eax,%ebp
  80295f:	83 f5 1f             	xor    $0x1f,%ebp
  802962:	75 5c                	jne    8029c0 <__umoddi3+0xb0>
  802964:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802968:	39 3c 24             	cmp    %edi,(%esp)
  80296b:	0f 87 e7 00 00 00    	ja     802a58 <__umoddi3+0x148>
  802971:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802975:	29 f1                	sub    %esi,%ecx
  802977:	19 c7                	sbb    %eax,%edi
  802979:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80297d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802981:	8b 44 24 08          	mov    0x8(%esp),%eax
  802985:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802989:	83 c4 14             	add    $0x14,%esp
  80298c:	5e                   	pop    %esi
  80298d:	5f                   	pop    %edi
  80298e:	5d                   	pop    %ebp
  80298f:	c3                   	ret    
  802990:	85 f6                	test   %esi,%esi
  802992:	89 f5                	mov    %esi,%ebp
  802994:	75 0b                	jne    8029a1 <__umoddi3+0x91>
  802996:	b8 01 00 00 00       	mov    $0x1,%eax
  80299b:	31 d2                	xor    %edx,%edx
  80299d:	f7 f6                	div    %esi
  80299f:	89 c5                	mov    %eax,%ebp
  8029a1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029a5:	31 d2                	xor    %edx,%edx
  8029a7:	f7 f5                	div    %ebp
  8029a9:	89 c8                	mov    %ecx,%eax
  8029ab:	f7 f5                	div    %ebp
  8029ad:	eb 9c                	jmp    80294b <__umoddi3+0x3b>
  8029af:	90                   	nop
  8029b0:	89 c8                	mov    %ecx,%eax
  8029b2:	89 fa                	mov    %edi,%edx
  8029b4:	83 c4 14             	add    $0x14,%esp
  8029b7:	5e                   	pop    %esi
  8029b8:	5f                   	pop    %edi
  8029b9:	5d                   	pop    %ebp
  8029ba:	c3                   	ret    
  8029bb:	90                   	nop
  8029bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029c0:	8b 04 24             	mov    (%esp),%eax
  8029c3:	be 20 00 00 00       	mov    $0x20,%esi
  8029c8:	89 e9                	mov    %ebp,%ecx
  8029ca:	29 ee                	sub    %ebp,%esi
  8029cc:	d3 e2                	shl    %cl,%edx
  8029ce:	89 f1                	mov    %esi,%ecx
  8029d0:	d3 e8                	shr    %cl,%eax
  8029d2:	89 e9                	mov    %ebp,%ecx
  8029d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d8:	8b 04 24             	mov    (%esp),%eax
  8029db:	09 54 24 04          	or     %edx,0x4(%esp)
  8029df:	89 fa                	mov    %edi,%edx
  8029e1:	d3 e0                	shl    %cl,%eax
  8029e3:	89 f1                	mov    %esi,%ecx
  8029e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029e9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8029ed:	d3 ea                	shr    %cl,%edx
  8029ef:	89 e9                	mov    %ebp,%ecx
  8029f1:	d3 e7                	shl    %cl,%edi
  8029f3:	89 f1                	mov    %esi,%ecx
  8029f5:	d3 e8                	shr    %cl,%eax
  8029f7:	89 e9                	mov    %ebp,%ecx
  8029f9:	09 f8                	or     %edi,%eax
  8029fb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8029ff:	f7 74 24 04          	divl   0x4(%esp)
  802a03:	d3 e7                	shl    %cl,%edi
  802a05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a09:	89 d7                	mov    %edx,%edi
  802a0b:	f7 64 24 08          	mull   0x8(%esp)
  802a0f:	39 d7                	cmp    %edx,%edi
  802a11:	89 c1                	mov    %eax,%ecx
  802a13:	89 14 24             	mov    %edx,(%esp)
  802a16:	72 2c                	jb     802a44 <__umoddi3+0x134>
  802a18:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802a1c:	72 22                	jb     802a40 <__umoddi3+0x130>
  802a1e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802a22:	29 c8                	sub    %ecx,%eax
  802a24:	19 d7                	sbb    %edx,%edi
  802a26:	89 e9                	mov    %ebp,%ecx
  802a28:	89 fa                	mov    %edi,%edx
  802a2a:	d3 e8                	shr    %cl,%eax
  802a2c:	89 f1                	mov    %esi,%ecx
  802a2e:	d3 e2                	shl    %cl,%edx
  802a30:	89 e9                	mov    %ebp,%ecx
  802a32:	d3 ef                	shr    %cl,%edi
  802a34:	09 d0                	or     %edx,%eax
  802a36:	89 fa                	mov    %edi,%edx
  802a38:	83 c4 14             	add    $0x14,%esp
  802a3b:	5e                   	pop    %esi
  802a3c:	5f                   	pop    %edi
  802a3d:	5d                   	pop    %ebp
  802a3e:	c3                   	ret    
  802a3f:	90                   	nop
  802a40:	39 d7                	cmp    %edx,%edi
  802a42:	75 da                	jne    802a1e <__umoddi3+0x10e>
  802a44:	8b 14 24             	mov    (%esp),%edx
  802a47:	89 c1                	mov    %eax,%ecx
  802a49:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802a4d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802a51:	eb cb                	jmp    802a1e <__umoddi3+0x10e>
  802a53:	90                   	nop
  802a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a58:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802a5c:	0f 82 0f ff ff ff    	jb     802971 <__umoddi3+0x61>
  802a62:	e9 1a ff ff ff       	jmp    802981 <__umoddi3+0x71>
