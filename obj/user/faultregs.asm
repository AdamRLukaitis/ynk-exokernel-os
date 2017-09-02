
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 64 05 00 00       	call   800595 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	8b 45 08             	mov    0x8(%ebp),%eax
  800043:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800047:	89 54 24 08          	mov    %edx,0x8(%esp)
  80004b:	c7 44 24 04 d1 2b 80 	movl   $0x802bd1,0x4(%esp)
  800052:	00 
  800053:	c7 04 24 a0 2b 80 00 	movl   $0x802ba0,(%esp)
  80005a:	e8 9a 06 00 00       	call   8006f9 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  80005f:	8b 03                	mov    (%ebx),%eax
  800061:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800065:	8b 06                	mov    (%esi),%eax
  800067:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006b:	c7 44 24 04 b0 2b 80 	movl   $0x802bb0,0x4(%esp)
  800072:	00 
  800073:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  80007a:	e8 7a 06 00 00       	call   8006f9 <cprintf>
  80007f:	8b 03                	mov    (%ebx),%eax
  800081:	39 06                	cmp    %eax,(%esi)
  800083:	75 13                	jne    800098 <check_regs+0x65>
  800085:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  80008c:	e8 68 06 00 00       	call   8006f9 <cprintf>

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
	int mismatch = 0;
  800091:	bf 00 00 00 00       	mov    $0x0,%edi
  800096:	eb 11                	jmp    8000a9 <check_regs+0x76>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800098:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  80009f:	e8 55 06 00 00       	call   8006f9 <cprintf>
  8000a4:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  8000a9:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	8b 46 04             	mov    0x4(%esi),%eax
  8000b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b7:	c7 44 24 04 d2 2b 80 	movl   $0x802bd2,0x4(%esp)
  8000be:	00 
  8000bf:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  8000c6:	e8 2e 06 00 00       	call   8006f9 <cprintf>
  8000cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ce:	39 46 04             	cmp    %eax,0x4(%esi)
  8000d1:	75 0e                	jne    8000e1 <check_regs+0xae>
  8000d3:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  8000da:	e8 1a 06 00 00       	call   8006f9 <cprintf>
  8000df:	eb 11                	jmp    8000f2 <check_regs+0xbf>
  8000e1:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  8000e8:	e8 0c 06 00 00       	call   8006f9 <cprintf>
  8000ed:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000f2:	8b 43 08             	mov    0x8(%ebx),%eax
  8000f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f9:	8b 46 08             	mov    0x8(%esi),%eax
  8000fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800100:	c7 44 24 04 d6 2b 80 	movl   $0x802bd6,0x4(%esp)
  800107:	00 
  800108:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  80010f:	e8 e5 05 00 00       	call   8006f9 <cprintf>
  800114:	8b 43 08             	mov    0x8(%ebx),%eax
  800117:	39 46 08             	cmp    %eax,0x8(%esi)
  80011a:	75 0e                	jne    80012a <check_regs+0xf7>
  80011c:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  800123:	e8 d1 05 00 00       	call   8006f9 <cprintf>
  800128:	eb 11                	jmp    80013b <check_regs+0x108>
  80012a:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  800131:	e8 c3 05 00 00       	call   8006f9 <cprintf>
  800136:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  80013b:	8b 43 10             	mov    0x10(%ebx),%eax
  80013e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800142:	8b 46 10             	mov    0x10(%esi),%eax
  800145:	89 44 24 08          	mov    %eax,0x8(%esp)
  800149:	c7 44 24 04 da 2b 80 	movl   $0x802bda,0x4(%esp)
  800150:	00 
  800151:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800158:	e8 9c 05 00 00       	call   8006f9 <cprintf>
  80015d:	8b 43 10             	mov    0x10(%ebx),%eax
  800160:	39 46 10             	cmp    %eax,0x10(%esi)
  800163:	75 0e                	jne    800173 <check_regs+0x140>
  800165:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  80016c:	e8 88 05 00 00       	call   8006f9 <cprintf>
  800171:	eb 11                	jmp    800184 <check_regs+0x151>
  800173:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  80017a:	e8 7a 05 00 00       	call   8006f9 <cprintf>
  80017f:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800184:	8b 43 14             	mov    0x14(%ebx),%eax
  800187:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018b:	8b 46 14             	mov    0x14(%esi),%eax
  80018e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800192:	c7 44 24 04 de 2b 80 	movl   $0x802bde,0x4(%esp)
  800199:	00 
  80019a:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  8001a1:	e8 53 05 00 00       	call   8006f9 <cprintf>
  8001a6:	8b 43 14             	mov    0x14(%ebx),%eax
  8001a9:	39 46 14             	cmp    %eax,0x14(%esi)
  8001ac:	75 0e                	jne    8001bc <check_regs+0x189>
  8001ae:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  8001b5:	e8 3f 05 00 00       	call   8006f9 <cprintf>
  8001ba:	eb 11                	jmp    8001cd <check_regs+0x19a>
  8001bc:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  8001c3:	e8 31 05 00 00       	call   8006f9 <cprintf>
  8001c8:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  8001cd:	8b 43 18             	mov    0x18(%ebx),%eax
  8001d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d4:	8b 46 18             	mov    0x18(%esi),%eax
  8001d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001db:	c7 44 24 04 e2 2b 80 	movl   $0x802be2,0x4(%esp)
  8001e2:	00 
  8001e3:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  8001ea:	e8 0a 05 00 00       	call   8006f9 <cprintf>
  8001ef:	8b 43 18             	mov    0x18(%ebx),%eax
  8001f2:	39 46 18             	cmp    %eax,0x18(%esi)
  8001f5:	75 0e                	jne    800205 <check_regs+0x1d2>
  8001f7:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  8001fe:	e8 f6 04 00 00       	call   8006f9 <cprintf>
  800203:	eb 11                	jmp    800216 <check_regs+0x1e3>
  800205:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  80020c:	e8 e8 04 00 00       	call   8006f9 <cprintf>
  800211:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  800216:	8b 43 1c             	mov    0x1c(%ebx),%eax
  800219:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021d:	8b 46 1c             	mov    0x1c(%esi),%eax
  800220:	89 44 24 08          	mov    %eax,0x8(%esp)
  800224:	c7 44 24 04 e6 2b 80 	movl   $0x802be6,0x4(%esp)
  80022b:	00 
  80022c:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800233:	e8 c1 04 00 00       	call   8006f9 <cprintf>
  800238:	8b 43 1c             	mov    0x1c(%ebx),%eax
  80023b:	39 46 1c             	cmp    %eax,0x1c(%esi)
  80023e:	75 0e                	jne    80024e <check_regs+0x21b>
  800240:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  800247:	e8 ad 04 00 00       	call   8006f9 <cprintf>
  80024c:	eb 11                	jmp    80025f <check_regs+0x22c>
  80024e:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  800255:	e8 9f 04 00 00       	call   8006f9 <cprintf>
  80025a:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  80025f:	8b 43 20             	mov    0x20(%ebx),%eax
  800262:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800266:	8b 46 20             	mov    0x20(%esi),%eax
  800269:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026d:	c7 44 24 04 ea 2b 80 	movl   $0x802bea,0x4(%esp)
  800274:	00 
  800275:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  80027c:	e8 78 04 00 00       	call   8006f9 <cprintf>
  800281:	8b 43 20             	mov    0x20(%ebx),%eax
  800284:	39 46 20             	cmp    %eax,0x20(%esi)
  800287:	75 0e                	jne    800297 <check_regs+0x264>
  800289:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  800290:	e8 64 04 00 00       	call   8006f9 <cprintf>
  800295:	eb 11                	jmp    8002a8 <check_regs+0x275>
  800297:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  80029e:	e8 56 04 00 00       	call   8006f9 <cprintf>
  8002a3:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  8002a8:	8b 43 24             	mov    0x24(%ebx),%eax
  8002ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002af:	8b 46 24             	mov    0x24(%esi),%eax
  8002b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b6:	c7 44 24 04 ee 2b 80 	movl   $0x802bee,0x4(%esp)
  8002bd:	00 
  8002be:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  8002c5:	e8 2f 04 00 00       	call   8006f9 <cprintf>
  8002ca:	8b 43 24             	mov    0x24(%ebx),%eax
  8002cd:	39 46 24             	cmp    %eax,0x24(%esi)
  8002d0:	75 0e                	jne    8002e0 <check_regs+0x2ad>
  8002d2:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  8002d9:	e8 1b 04 00 00       	call   8006f9 <cprintf>
  8002de:	eb 11                	jmp    8002f1 <check_regs+0x2be>
  8002e0:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  8002e7:	e8 0d 04 00 00       	call   8006f9 <cprintf>
  8002ec:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esp, esp);
  8002f1:	8b 43 28             	mov    0x28(%ebx),%eax
  8002f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f8:	8b 46 28             	mov    0x28(%esi),%eax
  8002fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ff:	c7 44 24 04 f5 2b 80 	movl   $0x802bf5,0x4(%esp)
  800306:	00 
  800307:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  80030e:	e8 e6 03 00 00       	call   8006f9 <cprintf>
  800313:	8b 43 28             	mov    0x28(%ebx),%eax
  800316:	39 46 28             	cmp    %eax,0x28(%esi)
  800319:	75 25                	jne    800340 <check_regs+0x30d>
  80031b:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  800322:	e8 d2 03 00 00       	call   8006f9 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032e:	c7 04 24 f9 2b 80 00 	movl   $0x802bf9,(%esp)
  800335:	e8 bf 03 00 00       	call   8006f9 <cprintf>
	if (!mismatch)
  80033a:	85 ff                	test   %edi,%edi
  80033c:	74 23                	je     800361 <check_regs+0x32e>
  80033e:	eb 2f                	jmp    80036f <check_regs+0x33c>
	CHECK(edx, regs.reg_edx);
	CHECK(ecx, regs.reg_ecx);
	CHECK(eax, regs.reg_eax);
	CHECK(eip, eip);
	CHECK(eflags, eflags);
	CHECK(esp, esp);
  800340:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  800347:	e8 ad 03 00 00       	call   8006f9 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800353:	c7 04 24 f9 2b 80 00 	movl   $0x802bf9,(%esp)
  80035a:	e8 9a 03 00 00       	call   8006f9 <cprintf>
  80035f:	eb 0e                	jmp    80036f <check_regs+0x33c>
	if (!mismatch)
		cprintf("OK\n");
  800361:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  800368:	e8 8c 03 00 00       	call   8006f9 <cprintf>
  80036d:	eb 0c                	jmp    80037b <check_regs+0x348>
	else
		cprintf("MISMATCH\n");
  80036f:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  800376:	e8 7e 03 00 00       	call   8006f9 <cprintf>
}
  80037b:	83 c4 1c             	add    $0x1c,%esp
  80037e:	5b                   	pop    %ebx
  80037f:	5e                   	pop    %esi
  800380:	5f                   	pop    %edi
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	83 ec 28             	sub    $0x28,%esp
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  80038c:	8b 10                	mov    (%eax),%edx
  80038e:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  800394:	74 27                	je     8003bd <pgfault+0x3a>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  800396:	8b 40 28             	mov    0x28(%eax),%eax
  800399:	89 44 24 10          	mov    %eax,0x10(%esp)
  80039d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a1:	c7 44 24 08 60 2c 80 	movl   $0x802c60,0x8(%esp)
  8003a8:	00 
  8003a9:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  8003b0:	00 
  8003b1:	c7 04 24 07 2c 80 00 	movl   $0x802c07,(%esp)
  8003b8:	e8 43 02 00 00       	call   800600 <_panic>
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003bd:	8b 50 08             	mov    0x8(%eax),%edx
  8003c0:	89 15 40 50 80 00    	mov    %edx,0x805040
  8003c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8003c9:	89 15 44 50 80 00    	mov    %edx,0x805044
  8003cf:	8b 50 10             	mov    0x10(%eax),%edx
  8003d2:	89 15 48 50 80 00    	mov    %edx,0x805048
  8003d8:	8b 50 14             	mov    0x14(%eax),%edx
  8003db:	89 15 4c 50 80 00    	mov    %edx,0x80504c
  8003e1:	8b 50 18             	mov    0x18(%eax),%edx
  8003e4:	89 15 50 50 80 00    	mov    %edx,0x805050
  8003ea:	8b 50 1c             	mov    0x1c(%eax),%edx
  8003ed:	89 15 54 50 80 00    	mov    %edx,0x805054
  8003f3:	8b 50 20             	mov    0x20(%eax),%edx
  8003f6:	89 15 58 50 80 00    	mov    %edx,0x805058
  8003fc:	8b 50 24             	mov    0x24(%eax),%edx
  8003ff:	89 15 5c 50 80 00    	mov    %edx,0x80505c
	during.eip = utf->utf_eip;
  800405:	8b 50 28             	mov    0x28(%eax),%edx
  800408:	89 15 60 50 80 00    	mov    %edx,0x805060
	during.eflags = utf->utf_eflags;
  80040e:	8b 50 2c             	mov    0x2c(%eax),%edx
  800411:	89 15 64 50 80 00    	mov    %edx,0x805064
	during.esp = utf->utf_esp;
  800417:	8b 40 30             	mov    0x30(%eax),%eax
  80041a:	a3 68 50 80 00       	mov    %eax,0x805068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  80041f:	c7 44 24 04 1f 2c 80 	movl   $0x802c1f,0x4(%esp)
  800426:	00 
  800427:	c7 04 24 2d 2c 80 00 	movl   $0x802c2d,(%esp)
  80042e:	b9 40 50 80 00       	mov    $0x805040,%ecx
  800433:	ba 18 2c 80 00       	mov    $0x802c18,%edx
  800438:	b8 80 50 80 00       	mov    $0x805080,%eax
  80043d:	e8 f1 fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800442:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800449:	00 
  80044a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800451:	00 
  800452:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800459:	e8 e5 0c 00 00       	call   801143 <sys_page_alloc>
  80045e:	85 c0                	test   %eax,%eax
  800460:	79 20                	jns    800482 <pgfault+0xff>
		panic("sys_page_alloc: %e", r);
  800462:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800466:	c7 44 24 08 34 2c 80 	movl   $0x802c34,0x8(%esp)
  80046d:	00 
  80046e:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800475:	00 
  800476:	c7 04 24 07 2c 80 00 	movl   $0x802c07,(%esp)
  80047d:	e8 7e 01 00 00       	call   800600 <_panic>
}
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <umain>:

void
umain(int argc, char **argv)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(pgfault);
  80048a:	c7 04 24 83 03 80 00 	movl   $0x800383,(%esp)
  800491:	e8 da 0f 00 00       	call   801470 <set_pgfault_handler>

	__asm __volatile(
  800496:	50                   	push   %eax
  800497:	9c                   	pushf  
  800498:	58                   	pop    %eax
  800499:	0d d5 08 00 00       	or     $0x8d5,%eax
  80049e:	50                   	push   %eax
  80049f:	9d                   	popf   
  8004a0:	a3 a4 50 80 00       	mov    %eax,0x8050a4
  8004a5:	8d 05 e0 04 80 00    	lea    0x8004e0,%eax
  8004ab:	a3 a0 50 80 00       	mov    %eax,0x8050a0
  8004b0:	58                   	pop    %eax
  8004b1:	89 3d 80 50 80 00    	mov    %edi,0x805080
  8004b7:	89 35 84 50 80 00    	mov    %esi,0x805084
  8004bd:	89 2d 88 50 80 00    	mov    %ebp,0x805088
  8004c3:	89 1d 90 50 80 00    	mov    %ebx,0x805090
  8004c9:	89 15 94 50 80 00    	mov    %edx,0x805094
  8004cf:	89 0d 98 50 80 00    	mov    %ecx,0x805098
  8004d5:	a3 9c 50 80 00       	mov    %eax,0x80509c
  8004da:	89 25 a8 50 80 00    	mov    %esp,0x8050a8
  8004e0:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  8004e7:	00 00 00 
  8004ea:	89 3d 00 50 80 00    	mov    %edi,0x805000
  8004f0:	89 35 04 50 80 00    	mov    %esi,0x805004
  8004f6:	89 2d 08 50 80 00    	mov    %ebp,0x805008
  8004fc:	89 1d 10 50 80 00    	mov    %ebx,0x805010
  800502:	89 15 14 50 80 00    	mov    %edx,0x805014
  800508:	89 0d 18 50 80 00    	mov    %ecx,0x805018
  80050e:	a3 1c 50 80 00       	mov    %eax,0x80501c
  800513:	89 25 28 50 80 00    	mov    %esp,0x805028
  800519:	8b 3d 80 50 80 00    	mov    0x805080,%edi
  80051f:	8b 35 84 50 80 00    	mov    0x805084,%esi
  800525:	8b 2d 88 50 80 00    	mov    0x805088,%ebp
  80052b:	8b 1d 90 50 80 00    	mov    0x805090,%ebx
  800531:	8b 15 94 50 80 00    	mov    0x805094,%edx
  800537:	8b 0d 98 50 80 00    	mov    0x805098,%ecx
  80053d:	a1 9c 50 80 00       	mov    0x80509c,%eax
  800542:	8b 25 a8 50 80 00    	mov    0x8050a8,%esp
  800548:	50                   	push   %eax
  800549:	9c                   	pushf  
  80054a:	58                   	pop    %eax
  80054b:	a3 24 50 80 00       	mov    %eax,0x805024
  800550:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800551:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  800558:	74 0c                	je     800566 <umain+0xe2>
		cprintf("EIP after page-fault MISMATCH\n");
  80055a:	c7 04 24 94 2c 80 00 	movl   $0x802c94,(%esp)
  800561:	e8 93 01 00 00       	call   8006f9 <cprintf>
	after.eip = before.eip;
  800566:	a1 a0 50 80 00       	mov    0x8050a0,%eax
  80056b:	a3 20 50 80 00       	mov    %eax,0x805020

	check_regs(&before, "before", &after, "after", "after page-fault");
  800570:	c7 44 24 04 47 2c 80 	movl   $0x802c47,0x4(%esp)
  800577:	00 
  800578:	c7 04 24 58 2c 80 00 	movl   $0x802c58,(%esp)
  80057f:	b9 00 50 80 00       	mov    $0x805000,%ecx
  800584:	ba 18 2c 80 00       	mov    $0x802c18,%edx
  800589:	b8 80 50 80 00       	mov    $0x805080,%eax
  80058e:	e8 a0 fa ff ff       	call   800033 <check_regs>
}
  800593:	c9                   	leave  
  800594:	c3                   	ret    

00800595 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
  80059a:	83 ec 10             	sub    $0x10,%esp
  80059d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005a0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8005a3:	c7 05 b4 50 80 00 00 	movl   $0x0,0x8050b4
  8005aa:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8005ad:	e8 53 0b 00 00       	call   801105 <sys_getenvid>
  8005b2:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  8005b7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005bf:	a3 b4 50 80 00       	mov    %eax,0x8050b4


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c4:	85 db                	test   %ebx,%ebx
  8005c6:	7e 07                	jle    8005cf <libmain+0x3a>
		binaryname = argv[0];
  8005c8:	8b 06                	mov    (%esi),%eax
  8005ca:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8005cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d3:	89 1c 24             	mov    %ebx,(%esp)
  8005d6:	e8 a9 fe ff ff       	call   800484 <umain>

	// exit gracefully
	exit();
  8005db:	e8 07 00 00 00       	call   8005e7 <exit>
}
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	5b                   	pop    %ebx
  8005e4:	5e                   	pop    %esi
  8005e5:	5d                   	pop    %ebp
  8005e6:	c3                   	ret    

008005e7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8005ed:	e8 f8 10 00 00       	call   8016ea <close_all>
	sys_env_destroy(0);
  8005f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005f9:	e8 b5 0a 00 00       	call   8010b3 <sys_env_destroy>
}
  8005fe:	c9                   	leave  
  8005ff:	c3                   	ret    

00800600 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800600:	55                   	push   %ebp
  800601:	89 e5                	mov    %esp,%ebp
  800603:	56                   	push   %esi
  800604:	53                   	push   %ebx
  800605:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800608:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80060b:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800611:	e8 ef 0a 00 00       	call   801105 <sys_getenvid>
  800616:	8b 55 0c             	mov    0xc(%ebp),%edx
  800619:	89 54 24 10          	mov    %edx,0x10(%esp)
  80061d:	8b 55 08             	mov    0x8(%ebp),%edx
  800620:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800624:	89 74 24 08          	mov    %esi,0x8(%esp)
  800628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80062c:	c7 04 24 c0 2c 80 00 	movl   $0x802cc0,(%esp)
  800633:	e8 c1 00 00 00       	call   8006f9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800638:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80063c:	8b 45 10             	mov    0x10(%ebp),%eax
  80063f:	89 04 24             	mov    %eax,(%esp)
  800642:	e8 51 00 00 00       	call   800698 <vcprintf>
	cprintf("\n");
  800647:	c7 04 24 d0 2b 80 00 	movl   $0x802bd0,(%esp)
  80064e:	e8 a6 00 00 00       	call   8006f9 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800653:	cc                   	int3   
  800654:	eb fd                	jmp    800653 <_panic+0x53>

00800656 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800656:	55                   	push   %ebp
  800657:	89 e5                	mov    %esp,%ebp
  800659:	53                   	push   %ebx
  80065a:	83 ec 14             	sub    $0x14,%esp
  80065d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800660:	8b 13                	mov    (%ebx),%edx
  800662:	8d 42 01             	lea    0x1(%edx),%eax
  800665:	89 03                	mov    %eax,(%ebx)
  800667:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80066a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80066e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800673:	75 19                	jne    80068e <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800675:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80067c:	00 
  80067d:	8d 43 08             	lea    0x8(%ebx),%eax
  800680:	89 04 24             	mov    %eax,(%esp)
  800683:	e8 ee 09 00 00       	call   801076 <sys_cputs>
		b->idx = 0;
  800688:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80068e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800692:	83 c4 14             	add    $0x14,%esp
  800695:	5b                   	pop    %ebx
  800696:	5d                   	pop    %ebp
  800697:	c3                   	ret    

00800698 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800698:	55                   	push   %ebp
  800699:	89 e5                	mov    %esp,%ebp
  80069b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8006a1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006a8:	00 00 00 
	b.cnt = 0;
  8006ab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006b2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006c3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006cd:	c7 04 24 56 06 80 00 	movl   $0x800656,(%esp)
  8006d4:	e8 b5 01 00 00       	call   80088e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006d9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8006df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006e9:	89 04 24             	mov    %eax,(%esp)
  8006ec:	e8 85 09 00 00       	call   801076 <sys_cputs>

	return b.cnt;
}
  8006f1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006f7:	c9                   	leave  
  8006f8:	c3                   	ret    

008006f9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006f9:	55                   	push   %ebp
  8006fa:	89 e5                	mov    %esp,%ebp
  8006fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006ff:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800702:	89 44 24 04          	mov    %eax,0x4(%esp)
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	89 04 24             	mov    %eax,(%esp)
  80070c:	e8 87 ff ff ff       	call   800698 <vcprintf>
	va_end(ap);

	return cnt;
}
  800711:	c9                   	leave  
  800712:	c3                   	ret    
  800713:	66 90                	xchg   %ax,%ax
  800715:	66 90                	xchg   %ax,%ax
  800717:	66 90                	xchg   %ax,%ax
  800719:	66 90                	xchg   %ax,%ax
  80071b:	66 90                	xchg   %ax,%ax
  80071d:	66 90                	xchg   %ax,%ax
  80071f:	90                   	nop

00800720 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800720:	55                   	push   %ebp
  800721:	89 e5                	mov    %esp,%ebp
  800723:	57                   	push   %edi
  800724:	56                   	push   %esi
  800725:	53                   	push   %ebx
  800726:	83 ec 3c             	sub    $0x3c,%esp
  800729:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072c:	89 d7                	mov    %edx,%edi
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800734:	8b 45 0c             	mov    0xc(%ebp),%eax
  800737:	89 c3                	mov    %eax,%ebx
  800739:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80073c:	8b 45 10             	mov    0x10(%ebp),%eax
  80073f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800742:	b9 00 00 00 00       	mov    $0x0,%ecx
  800747:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80074d:	39 d9                	cmp    %ebx,%ecx
  80074f:	72 05                	jb     800756 <printnum+0x36>
  800751:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800754:	77 69                	ja     8007bf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800756:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800759:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80075d:	83 ee 01             	sub    $0x1,%esi
  800760:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800764:	89 44 24 08          	mov    %eax,0x8(%esp)
  800768:	8b 44 24 08          	mov    0x8(%esp),%eax
  80076c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800770:	89 c3                	mov    %eax,%ebx
  800772:	89 d6                	mov    %edx,%esi
  800774:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800777:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80077a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80077e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800782:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800785:	89 04 24             	mov    %eax,(%esp)
  800788:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80078b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078f:	e8 7c 21 00 00       	call   802910 <__udivdi3>
  800794:	89 d9                	mov    %ebx,%ecx
  800796:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80079a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80079e:	89 04 24             	mov    %eax,(%esp)
  8007a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007a5:	89 fa                	mov    %edi,%edx
  8007a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007aa:	e8 71 ff ff ff       	call   800720 <printnum>
  8007af:	eb 1b                	jmp    8007cc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b8:	89 04 24             	mov    %eax,(%esp)
  8007bb:	ff d3                	call   *%ebx
  8007bd:	eb 03                	jmp    8007c2 <printnum+0xa2>
  8007bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007c2:	83 ee 01             	sub    $0x1,%esi
  8007c5:	85 f6                	test   %esi,%esi
  8007c7:	7f e8                	jg     8007b1 <printnum+0x91>
  8007c9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8007d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007de:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e5:	89 04 24             	mov    %eax,(%esp)
  8007e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ef:	e8 4c 22 00 00       	call   802a40 <__umoddi3>
  8007f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f8:	0f be 80 e3 2c 80 00 	movsbl 0x802ce3(%eax),%eax
  8007ff:	89 04 24             	mov    %eax,(%esp)
  800802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800805:	ff d0                	call   *%eax
}
  800807:	83 c4 3c             	add    $0x3c,%esp
  80080a:	5b                   	pop    %ebx
  80080b:	5e                   	pop    %esi
  80080c:	5f                   	pop    %edi
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800812:	83 fa 01             	cmp    $0x1,%edx
  800815:	7e 0e                	jle    800825 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800817:	8b 10                	mov    (%eax),%edx
  800819:	8d 4a 08             	lea    0x8(%edx),%ecx
  80081c:	89 08                	mov    %ecx,(%eax)
  80081e:	8b 02                	mov    (%edx),%eax
  800820:	8b 52 04             	mov    0x4(%edx),%edx
  800823:	eb 22                	jmp    800847 <getuint+0x38>
	else if (lflag)
  800825:	85 d2                	test   %edx,%edx
  800827:	74 10                	je     800839 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800829:	8b 10                	mov    (%eax),%edx
  80082b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80082e:	89 08                	mov    %ecx,(%eax)
  800830:	8b 02                	mov    (%edx),%eax
  800832:	ba 00 00 00 00       	mov    $0x0,%edx
  800837:	eb 0e                	jmp    800847 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800839:	8b 10                	mov    (%eax),%edx
  80083b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80083e:	89 08                	mov    %ecx,(%eax)
  800840:	8b 02                	mov    (%edx),%eax
  800842:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80084f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800853:	8b 10                	mov    (%eax),%edx
  800855:	3b 50 04             	cmp    0x4(%eax),%edx
  800858:	73 0a                	jae    800864 <sprintputch+0x1b>
		*b->buf++ = ch;
  80085a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80085d:	89 08                	mov    %ecx,(%eax)
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	88 02                	mov    %al,(%edx)
}
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80086c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80086f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800873:	8b 45 10             	mov    0x10(%ebp),%eax
  800876:	89 44 24 08          	mov    %eax,0x8(%esp)
  80087a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	89 04 24             	mov    %eax,(%esp)
  800887:	e8 02 00 00 00       	call   80088e <vprintfmt>
	va_end(ap);
}
  80088c:	c9                   	leave  
  80088d:	c3                   	ret    

0080088e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	57                   	push   %edi
  800892:	56                   	push   %esi
  800893:	53                   	push   %ebx
  800894:	83 ec 3c             	sub    $0x3c,%esp
  800897:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80089a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80089d:	eb 14                	jmp    8008b3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80089f:	85 c0                	test   %eax,%eax
  8008a1:	0f 84 b3 03 00 00    	je     800c5a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8008a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ab:	89 04 24             	mov    %eax,(%esp)
  8008ae:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b1:	89 f3                	mov    %esi,%ebx
  8008b3:	8d 73 01             	lea    0x1(%ebx),%esi
  8008b6:	0f b6 03             	movzbl (%ebx),%eax
  8008b9:	83 f8 25             	cmp    $0x25,%eax
  8008bc:	75 e1                	jne    80089f <vprintfmt+0x11>
  8008be:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8008c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008c9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8008d0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8008d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dc:	eb 1d                	jmp    8008fb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008de:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8008e0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8008e4:	eb 15                	jmp    8008fb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008e8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8008ec:	eb 0d                	jmp    8008fb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8008ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008f4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008fb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8008fe:	0f b6 0e             	movzbl (%esi),%ecx
  800901:	0f b6 c1             	movzbl %cl,%eax
  800904:	83 e9 23             	sub    $0x23,%ecx
  800907:	80 f9 55             	cmp    $0x55,%cl
  80090a:	0f 87 2a 03 00 00    	ja     800c3a <vprintfmt+0x3ac>
  800910:	0f b6 c9             	movzbl %cl,%ecx
  800913:	ff 24 8d 20 2e 80 00 	jmp    *0x802e20(,%ecx,4)
  80091a:	89 de                	mov    %ebx,%esi
  80091c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800921:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800924:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800928:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80092b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80092e:	83 fb 09             	cmp    $0x9,%ebx
  800931:	77 36                	ja     800969 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800933:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800936:	eb e9                	jmp    800921 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	8d 48 04             	lea    0x4(%eax),%ecx
  80093e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800941:	8b 00                	mov    (%eax),%eax
  800943:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800946:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800948:	eb 22                	jmp    80096c <vprintfmt+0xde>
  80094a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80094d:	85 c9                	test   %ecx,%ecx
  80094f:	b8 00 00 00 00       	mov    $0x0,%eax
  800954:	0f 49 c1             	cmovns %ecx,%eax
  800957:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80095a:	89 de                	mov    %ebx,%esi
  80095c:	eb 9d                	jmp    8008fb <vprintfmt+0x6d>
  80095e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800960:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800967:	eb 92                	jmp    8008fb <vprintfmt+0x6d>
  800969:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80096c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800970:	79 89                	jns    8008fb <vprintfmt+0x6d>
  800972:	e9 77 ff ff ff       	jmp    8008ee <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800977:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80097c:	e9 7a ff ff ff       	jmp    8008fb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800981:	8b 45 14             	mov    0x14(%ebp),%eax
  800984:	8d 50 04             	lea    0x4(%eax),%edx
  800987:	89 55 14             	mov    %edx,0x14(%ebp)
  80098a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	89 04 24             	mov    %eax,(%esp)
  800993:	ff 55 08             	call   *0x8(%ebp)
			break;
  800996:	e9 18 ff ff ff       	jmp    8008b3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	8d 50 04             	lea    0x4(%eax),%edx
  8009a1:	89 55 14             	mov    %edx,0x14(%ebp)
  8009a4:	8b 00                	mov    (%eax),%eax
  8009a6:	99                   	cltd   
  8009a7:	31 d0                	xor    %edx,%eax
  8009a9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009ab:	83 f8 0f             	cmp    $0xf,%eax
  8009ae:	7f 0b                	jg     8009bb <vprintfmt+0x12d>
  8009b0:	8b 14 85 80 2f 80 00 	mov    0x802f80(,%eax,4),%edx
  8009b7:	85 d2                	test   %edx,%edx
  8009b9:	75 20                	jne    8009db <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8009bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009bf:	c7 44 24 08 fb 2c 80 	movl   $0x802cfb,0x8(%esp)
  8009c6:	00 
  8009c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	89 04 24             	mov    %eax,(%esp)
  8009d1:	e8 90 fe ff ff       	call   800866 <printfmt>
  8009d6:	e9 d8 fe ff ff       	jmp    8008b3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8009db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009df:	c7 44 24 08 21 31 80 	movl   $0x803121,0x8(%esp)
  8009e6:	00 
  8009e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	89 04 24             	mov    %eax,(%esp)
  8009f1:	e8 70 fe ff ff       	call   800866 <printfmt>
  8009f6:	e9 b8 fe ff ff       	jmp    8008b3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009fb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8009fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a01:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	8d 50 04             	lea    0x4(%eax),%edx
  800a0a:	89 55 14             	mov    %edx,0x14(%ebp)
  800a0d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800a0f:	85 f6                	test   %esi,%esi
  800a11:	b8 f4 2c 80 00       	mov    $0x802cf4,%eax
  800a16:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800a19:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800a1d:	0f 84 97 00 00 00    	je     800aba <vprintfmt+0x22c>
  800a23:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800a27:	0f 8e 9b 00 00 00    	jle    800ac8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a2d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a31:	89 34 24             	mov    %esi,(%esp)
  800a34:	e8 cf 02 00 00       	call   800d08 <strnlen>
  800a39:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a3c:	29 c2                	sub    %eax,%edx
  800a3e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800a41:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800a45:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a48:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800a4b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a4e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a51:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a53:	eb 0f                	jmp    800a64 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800a55:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a5c:	89 04 24             	mov    %eax,(%esp)
  800a5f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a61:	83 eb 01             	sub    $0x1,%ebx
  800a64:	85 db                	test   %ebx,%ebx
  800a66:	7f ed                	jg     800a55 <vprintfmt+0x1c7>
  800a68:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800a6b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a6e:	85 d2                	test   %edx,%edx
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
  800a75:	0f 49 c2             	cmovns %edx,%eax
  800a78:	29 c2                	sub    %eax,%edx
  800a7a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a7d:	89 d7                	mov    %edx,%edi
  800a7f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a82:	eb 50                	jmp    800ad4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a88:	74 1e                	je     800aa8 <vprintfmt+0x21a>
  800a8a:	0f be d2             	movsbl %dl,%edx
  800a8d:	83 ea 20             	sub    $0x20,%edx
  800a90:	83 fa 5e             	cmp    $0x5e,%edx
  800a93:	76 13                	jbe    800aa8 <vprintfmt+0x21a>
					putch('?', putdat);
  800a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a9c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800aa3:	ff 55 08             	call   *0x8(%ebp)
  800aa6:	eb 0d                	jmp    800ab5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800aa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aab:	89 54 24 04          	mov    %edx,0x4(%esp)
  800aaf:	89 04 24             	mov    %eax,(%esp)
  800ab2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab5:	83 ef 01             	sub    $0x1,%edi
  800ab8:	eb 1a                	jmp    800ad4 <vprintfmt+0x246>
  800aba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800abd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800ac0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ac3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ac6:	eb 0c                	jmp    800ad4 <vprintfmt+0x246>
  800ac8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800acb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800ace:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ad1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ad4:	83 c6 01             	add    $0x1,%esi
  800ad7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800adb:	0f be c2             	movsbl %dl,%eax
  800ade:	85 c0                	test   %eax,%eax
  800ae0:	74 27                	je     800b09 <vprintfmt+0x27b>
  800ae2:	85 db                	test   %ebx,%ebx
  800ae4:	78 9e                	js     800a84 <vprintfmt+0x1f6>
  800ae6:	83 eb 01             	sub    $0x1,%ebx
  800ae9:	79 99                	jns    800a84 <vprintfmt+0x1f6>
  800aeb:	89 f8                	mov    %edi,%eax
  800aed:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800af0:	8b 75 08             	mov    0x8(%ebp),%esi
  800af3:	89 c3                	mov    %eax,%ebx
  800af5:	eb 1a                	jmp    800b11 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800af7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800afb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800b02:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b04:	83 eb 01             	sub    $0x1,%ebx
  800b07:	eb 08                	jmp    800b11 <vprintfmt+0x283>
  800b09:	89 fb                	mov    %edi,%ebx
  800b0b:	8b 75 08             	mov    0x8(%ebp),%esi
  800b0e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b11:	85 db                	test   %ebx,%ebx
  800b13:	7f e2                	jg     800af7 <vprintfmt+0x269>
  800b15:	89 75 08             	mov    %esi,0x8(%ebp)
  800b18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b1b:	e9 93 fd ff ff       	jmp    8008b3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b20:	83 fa 01             	cmp    $0x1,%edx
  800b23:	7e 16                	jle    800b3b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	8d 50 08             	lea    0x8(%eax),%edx
  800b2b:	89 55 14             	mov    %edx,0x14(%ebp)
  800b2e:	8b 50 04             	mov    0x4(%eax),%edx
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b36:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b39:	eb 32                	jmp    800b6d <vprintfmt+0x2df>
	else if (lflag)
  800b3b:	85 d2                	test   %edx,%edx
  800b3d:	74 18                	je     800b57 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b42:	8d 50 04             	lea    0x4(%eax),%edx
  800b45:	89 55 14             	mov    %edx,0x14(%ebp)
  800b48:	8b 30                	mov    (%eax),%esi
  800b4a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b4d:	89 f0                	mov    %esi,%eax
  800b4f:	c1 f8 1f             	sar    $0x1f,%eax
  800b52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b55:	eb 16                	jmp    800b6d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800b57:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5a:	8d 50 04             	lea    0x4(%eax),%edx
  800b5d:	89 55 14             	mov    %edx,0x14(%ebp)
  800b60:	8b 30                	mov    (%eax),%esi
  800b62:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b65:	89 f0                	mov    %esi,%eax
  800b67:	c1 f8 1f             	sar    $0x1f,%eax
  800b6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800b73:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7c:	0f 89 80 00 00 00    	jns    800c02 <vprintfmt+0x374>
				putch('-', putdat);
  800b82:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b86:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b8d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b96:	f7 d8                	neg    %eax
  800b98:	83 d2 00             	adc    $0x0,%edx
  800b9b:	f7 da                	neg    %edx
			}
			base = 10;
  800b9d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ba2:	eb 5e                	jmp    800c02 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ba4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba7:	e8 63 fc ff ff       	call   80080f <getuint>
			base = 10;
  800bac:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800bb1:	eb 4f                	jmp    800c02 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800bb3:	8d 45 14             	lea    0x14(%ebp),%eax
  800bb6:	e8 54 fc ff ff       	call   80080f <getuint>
			base =8;
  800bbb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800bc0:	eb 40                	jmp    800c02 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800bc2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bc6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800bcd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800bd0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bd4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800bdb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800bde:	8b 45 14             	mov    0x14(%ebp),%eax
  800be1:	8d 50 04             	lea    0x4(%eax),%edx
  800be4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800bee:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800bf3:	eb 0d                	jmp    800c02 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bf5:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf8:	e8 12 fc ff ff       	call   80080f <getuint>
			base = 16;
  800bfd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c02:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800c06:	89 74 24 10          	mov    %esi,0x10(%esp)
  800c0a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800c0d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800c11:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c15:	89 04 24             	mov    %eax,(%esp)
  800c18:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c1c:	89 fa                	mov    %edi,%edx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	e8 fa fa ff ff       	call   800720 <printnum>
			break;
  800c26:	e9 88 fc ff ff       	jmp    8008b3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c2b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c2f:	89 04 24             	mov    %eax,(%esp)
  800c32:	ff 55 08             	call   *0x8(%ebp)
			break;
  800c35:	e9 79 fc ff ff       	jmp    8008b3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c3a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c3e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c45:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c48:	89 f3                	mov    %esi,%ebx
  800c4a:	eb 03                	jmp    800c4f <vprintfmt+0x3c1>
  800c4c:	83 eb 01             	sub    $0x1,%ebx
  800c4f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800c53:	75 f7                	jne    800c4c <vprintfmt+0x3be>
  800c55:	e9 59 fc ff ff       	jmp    8008b3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800c5a:	83 c4 3c             	add    $0x3c,%esp
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	83 ec 28             	sub    $0x28,%esp
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c71:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c75:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	74 30                	je     800cb3 <vsnprintf+0x51>
  800c83:	85 d2                	test   %edx,%edx
  800c85:	7e 2c                	jle    800cb3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c87:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c9c:	c7 04 24 49 08 80 00 	movl   $0x800849,(%esp)
  800ca3:	e8 e6 fb ff ff       	call   80088e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cb1:	eb 05                	jmp    800cb8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800cb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cc0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	89 04 24             	mov    %eax,(%esp)
  800cdb:	e8 82 ff ff ff       	call   800c62 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ce0:	c9                   	leave  
  800ce1:	c3                   	ret    
  800ce2:	66 90                	xchg   %ax,%ax
  800ce4:	66 90                	xchg   %ax,%ax
  800ce6:	66 90                	xchg   %ax,%ax
  800ce8:	66 90                	xchg   %ax,%ax
  800cea:	66 90                	xchg   %ax,%ax
  800cec:	66 90                	xchg   %ax,%ax
  800cee:	66 90                	xchg   %ax,%ax

00800cf0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfb:	eb 03                	jmp    800d00 <strlen+0x10>
		n++;
  800cfd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d00:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d04:	75 f7                	jne    800cfd <strlen+0xd>
		n++;
	return n;
}
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
  800d16:	eb 03                	jmp    800d1b <strnlen+0x13>
		n++;
  800d18:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d1b:	39 d0                	cmp    %edx,%eax
  800d1d:	74 06                	je     800d25 <strnlen+0x1d>
  800d1f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d23:	75 f3                	jne    800d18 <strnlen+0x10>
		n++;
	return n;
}
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	53                   	push   %ebx
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d31:	89 c2                	mov    %eax,%edx
  800d33:	83 c2 01             	add    $0x1,%edx
  800d36:	83 c1 01             	add    $0x1,%ecx
  800d39:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d3d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d40:	84 db                	test   %bl,%bl
  800d42:	75 ef                	jne    800d33 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d44:	5b                   	pop    %ebx
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	53                   	push   %ebx
  800d4b:	83 ec 08             	sub    $0x8,%esp
  800d4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d51:	89 1c 24             	mov    %ebx,(%esp)
  800d54:	e8 97 ff ff ff       	call   800cf0 <strlen>
	strcpy(dst + len, src);
  800d59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d60:	01 d8                	add    %ebx,%eax
  800d62:	89 04 24             	mov    %eax,(%esp)
  800d65:	e8 bd ff ff ff       	call   800d27 <strcpy>
	return dst;
}
  800d6a:	89 d8                	mov    %ebx,%eax
  800d6c:	83 c4 08             	add    $0x8,%esp
  800d6f:	5b                   	pop    %ebx
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    

00800d72 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	56                   	push   %esi
  800d76:	53                   	push   %ebx
  800d77:	8b 75 08             	mov    0x8(%ebp),%esi
  800d7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7d:	89 f3                	mov    %esi,%ebx
  800d7f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d82:	89 f2                	mov    %esi,%edx
  800d84:	eb 0f                	jmp    800d95 <strncpy+0x23>
		*dst++ = *src;
  800d86:	83 c2 01             	add    $0x1,%edx
  800d89:	0f b6 01             	movzbl (%ecx),%eax
  800d8c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d8f:	80 39 01             	cmpb   $0x1,(%ecx)
  800d92:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d95:	39 da                	cmp    %ebx,%edx
  800d97:	75 ed                	jne    800d86 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d99:	89 f0                	mov    %esi,%eax
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    

00800d9f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
  800da4:	8b 75 08             	mov    0x8(%ebp),%esi
  800da7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800daa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800dad:	89 f0                	mov    %esi,%eax
  800daf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800db3:	85 c9                	test   %ecx,%ecx
  800db5:	75 0b                	jne    800dc2 <strlcpy+0x23>
  800db7:	eb 1d                	jmp    800dd6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800db9:	83 c0 01             	add    $0x1,%eax
  800dbc:	83 c2 01             	add    $0x1,%edx
  800dbf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dc2:	39 d8                	cmp    %ebx,%eax
  800dc4:	74 0b                	je     800dd1 <strlcpy+0x32>
  800dc6:	0f b6 0a             	movzbl (%edx),%ecx
  800dc9:	84 c9                	test   %cl,%cl
  800dcb:	75 ec                	jne    800db9 <strlcpy+0x1a>
  800dcd:	89 c2                	mov    %eax,%edx
  800dcf:	eb 02                	jmp    800dd3 <strlcpy+0x34>
  800dd1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800dd3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800dd6:	29 f0                	sub    %esi,%eax
}
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800de5:	eb 06                	jmp    800ded <strcmp+0x11>
		p++, q++;
  800de7:	83 c1 01             	add    $0x1,%ecx
  800dea:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ded:	0f b6 01             	movzbl (%ecx),%eax
  800df0:	84 c0                	test   %al,%al
  800df2:	74 04                	je     800df8 <strcmp+0x1c>
  800df4:	3a 02                	cmp    (%edx),%al
  800df6:	74 ef                	je     800de7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df8:	0f b6 c0             	movzbl %al,%eax
  800dfb:	0f b6 12             	movzbl (%edx),%edx
  800dfe:	29 d0                	sub    %edx,%eax
}
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	53                   	push   %ebx
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0c:	89 c3                	mov    %eax,%ebx
  800e0e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e11:	eb 06                	jmp    800e19 <strncmp+0x17>
		n--, p++, q++;
  800e13:	83 c0 01             	add    $0x1,%eax
  800e16:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e19:	39 d8                	cmp    %ebx,%eax
  800e1b:	74 15                	je     800e32 <strncmp+0x30>
  800e1d:	0f b6 08             	movzbl (%eax),%ecx
  800e20:	84 c9                	test   %cl,%cl
  800e22:	74 04                	je     800e28 <strncmp+0x26>
  800e24:	3a 0a                	cmp    (%edx),%cl
  800e26:	74 eb                	je     800e13 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e28:	0f b6 00             	movzbl (%eax),%eax
  800e2b:	0f b6 12             	movzbl (%edx),%edx
  800e2e:	29 d0                	sub    %edx,%eax
  800e30:	eb 05                	jmp    800e37 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800e32:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800e37:	5b                   	pop    %ebx
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e44:	eb 07                	jmp    800e4d <strchr+0x13>
		if (*s == c)
  800e46:	38 ca                	cmp    %cl,%dl
  800e48:	74 0f                	je     800e59 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4a:	83 c0 01             	add    $0x1,%eax
  800e4d:	0f b6 10             	movzbl (%eax),%edx
  800e50:	84 d2                	test   %dl,%dl
  800e52:	75 f2                	jne    800e46 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800e54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e65:	eb 07                	jmp    800e6e <strfind+0x13>
		if (*s == c)
  800e67:	38 ca                	cmp    %cl,%dl
  800e69:	74 0a                	je     800e75 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e6b:	83 c0 01             	add    $0x1,%eax
  800e6e:	0f b6 10             	movzbl (%eax),%edx
  800e71:	84 d2                	test   %dl,%dl
  800e73:	75 f2                	jne    800e67 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    

00800e77 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	57                   	push   %edi
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
  800e7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e83:	85 c9                	test   %ecx,%ecx
  800e85:	74 36                	je     800ebd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e87:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e8d:	75 28                	jne    800eb7 <memset+0x40>
  800e8f:	f6 c1 03             	test   $0x3,%cl
  800e92:	75 23                	jne    800eb7 <memset+0x40>
		c &= 0xFF;
  800e94:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e98:	89 d3                	mov    %edx,%ebx
  800e9a:	c1 e3 08             	shl    $0x8,%ebx
  800e9d:	89 d6                	mov    %edx,%esi
  800e9f:	c1 e6 18             	shl    $0x18,%esi
  800ea2:	89 d0                	mov    %edx,%eax
  800ea4:	c1 e0 10             	shl    $0x10,%eax
  800ea7:	09 f0                	or     %esi,%eax
  800ea9:	09 c2                	or     %eax,%edx
  800eab:	89 d0                	mov    %edx,%eax
  800ead:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800eaf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800eb2:	fc                   	cld    
  800eb3:	f3 ab                	rep stos %eax,%es:(%edi)
  800eb5:	eb 06                	jmp    800ebd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	fc                   	cld    
  800ebb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ebd:	89 f8                	mov    %edi,%eax
  800ebf:	5b                   	pop    %ebx
  800ec0:	5e                   	pop    %esi
  800ec1:	5f                   	pop    %edi
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	57                   	push   %edi
  800ec8:	56                   	push   %esi
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ecf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ed2:	39 c6                	cmp    %eax,%esi
  800ed4:	73 35                	jae    800f0b <memmove+0x47>
  800ed6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ed9:	39 d0                	cmp    %edx,%eax
  800edb:	73 2e                	jae    800f0b <memmove+0x47>
		s += n;
		d += n;
  800edd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ee0:	89 d6                	mov    %edx,%esi
  800ee2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ee4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800eea:	75 13                	jne    800eff <memmove+0x3b>
  800eec:	f6 c1 03             	test   $0x3,%cl
  800eef:	75 0e                	jne    800eff <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ef1:	83 ef 04             	sub    $0x4,%edi
  800ef4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ef7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800efa:	fd                   	std    
  800efb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800efd:	eb 09                	jmp    800f08 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800eff:	83 ef 01             	sub    $0x1,%edi
  800f02:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800f05:	fd                   	std    
  800f06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f08:	fc                   	cld    
  800f09:	eb 1d                	jmp    800f28 <memmove+0x64>
  800f0b:	89 f2                	mov    %esi,%edx
  800f0d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f0f:	f6 c2 03             	test   $0x3,%dl
  800f12:	75 0f                	jne    800f23 <memmove+0x5f>
  800f14:	f6 c1 03             	test   $0x3,%cl
  800f17:	75 0a                	jne    800f23 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f19:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800f1c:	89 c7                	mov    %eax,%edi
  800f1e:	fc                   	cld    
  800f1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f21:	eb 05                	jmp    800f28 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f23:	89 c7                	mov    %eax,%edi
  800f25:	fc                   	cld    
  800f26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f32:	8b 45 10             	mov    0x10(%ebp),%eax
  800f35:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	89 04 24             	mov    %eax,(%esp)
  800f46:	e8 79 ff ff ff       	call   800ec4 <memmove>
}
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	56                   	push   %esi
  800f51:	53                   	push   %ebx
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f58:	89 d6                	mov    %edx,%esi
  800f5a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f5d:	eb 1a                	jmp    800f79 <memcmp+0x2c>
		if (*s1 != *s2)
  800f5f:	0f b6 02             	movzbl (%edx),%eax
  800f62:	0f b6 19             	movzbl (%ecx),%ebx
  800f65:	38 d8                	cmp    %bl,%al
  800f67:	74 0a                	je     800f73 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800f69:	0f b6 c0             	movzbl %al,%eax
  800f6c:	0f b6 db             	movzbl %bl,%ebx
  800f6f:	29 d8                	sub    %ebx,%eax
  800f71:	eb 0f                	jmp    800f82 <memcmp+0x35>
		s1++, s2++;
  800f73:	83 c2 01             	add    $0x1,%edx
  800f76:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f79:	39 f2                	cmp    %esi,%edx
  800f7b:	75 e2                	jne    800f5f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f8f:	89 c2                	mov    %eax,%edx
  800f91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f94:	eb 07                	jmp    800f9d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f96:	38 08                	cmp    %cl,(%eax)
  800f98:	74 07                	je     800fa1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f9a:	83 c0 01             	add    $0x1,%eax
  800f9d:	39 d0                	cmp    %edx,%eax
  800f9f:	72 f5                	jb     800f96 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	57                   	push   %edi
  800fa7:	56                   	push   %esi
  800fa8:	53                   	push   %ebx
  800fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fac:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800faf:	eb 03                	jmp    800fb4 <strtol+0x11>
		s++;
  800fb1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fb4:	0f b6 0a             	movzbl (%edx),%ecx
  800fb7:	80 f9 09             	cmp    $0x9,%cl
  800fba:	74 f5                	je     800fb1 <strtol+0xe>
  800fbc:	80 f9 20             	cmp    $0x20,%cl
  800fbf:	74 f0                	je     800fb1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fc1:	80 f9 2b             	cmp    $0x2b,%cl
  800fc4:	75 0a                	jne    800fd0 <strtol+0x2d>
		s++;
  800fc6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800fc9:	bf 00 00 00 00       	mov    $0x0,%edi
  800fce:	eb 11                	jmp    800fe1 <strtol+0x3e>
  800fd0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800fd5:	80 f9 2d             	cmp    $0x2d,%cl
  800fd8:	75 07                	jne    800fe1 <strtol+0x3e>
		s++, neg = 1;
  800fda:	8d 52 01             	lea    0x1(%edx),%edx
  800fdd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fe1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800fe6:	75 15                	jne    800ffd <strtol+0x5a>
  800fe8:	80 3a 30             	cmpb   $0x30,(%edx)
  800feb:	75 10                	jne    800ffd <strtol+0x5a>
  800fed:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ff1:	75 0a                	jne    800ffd <strtol+0x5a>
		s += 2, base = 16;
  800ff3:	83 c2 02             	add    $0x2,%edx
  800ff6:	b8 10 00 00 00       	mov    $0x10,%eax
  800ffb:	eb 10                	jmp    80100d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	75 0c                	jne    80100d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801001:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801003:	80 3a 30             	cmpb   $0x30,(%edx)
  801006:	75 05                	jne    80100d <strtol+0x6a>
		s++, base = 8;
  801008:	83 c2 01             	add    $0x1,%edx
  80100b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80100d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801012:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801015:	0f b6 0a             	movzbl (%edx),%ecx
  801018:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80101b:	89 f0                	mov    %esi,%eax
  80101d:	3c 09                	cmp    $0x9,%al
  80101f:	77 08                	ja     801029 <strtol+0x86>
			dig = *s - '0';
  801021:	0f be c9             	movsbl %cl,%ecx
  801024:	83 e9 30             	sub    $0x30,%ecx
  801027:	eb 20                	jmp    801049 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801029:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80102c:	89 f0                	mov    %esi,%eax
  80102e:	3c 19                	cmp    $0x19,%al
  801030:	77 08                	ja     80103a <strtol+0x97>
			dig = *s - 'a' + 10;
  801032:	0f be c9             	movsbl %cl,%ecx
  801035:	83 e9 57             	sub    $0x57,%ecx
  801038:	eb 0f                	jmp    801049 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80103a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80103d:	89 f0                	mov    %esi,%eax
  80103f:	3c 19                	cmp    $0x19,%al
  801041:	77 16                	ja     801059 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801043:	0f be c9             	movsbl %cl,%ecx
  801046:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801049:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80104c:	7d 0f                	jge    80105d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80104e:	83 c2 01             	add    $0x1,%edx
  801051:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801055:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801057:	eb bc                	jmp    801015 <strtol+0x72>
  801059:	89 d8                	mov    %ebx,%eax
  80105b:	eb 02                	jmp    80105f <strtol+0xbc>
  80105d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80105f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801063:	74 05                	je     80106a <strtol+0xc7>
		*endptr = (char *) s;
  801065:	8b 75 0c             	mov    0xc(%ebp),%esi
  801068:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80106a:	f7 d8                	neg    %eax
  80106c:	85 ff                	test   %edi,%edi
  80106e:	0f 44 c3             	cmove  %ebx,%eax
}
  801071:	5b                   	pop    %ebx
  801072:	5e                   	pop    %esi
  801073:	5f                   	pop    %edi
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	57                   	push   %edi
  80107a:	56                   	push   %esi
  80107b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107c:	b8 00 00 00 00       	mov    $0x0,%eax
  801081:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801084:	8b 55 08             	mov    0x8(%ebp),%edx
  801087:	89 c3                	mov    %eax,%ebx
  801089:	89 c7                	mov    %eax,%edi
  80108b:	89 c6                	mov    %eax,%esi
  80108d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80108f:	5b                   	pop    %ebx
  801090:	5e                   	pop    %esi
  801091:	5f                   	pop    %edi
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    

00801094 <sys_cgetc>:

int
sys_cgetc(void)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80109a:	ba 00 00 00 00       	mov    $0x0,%edx
  80109f:	b8 01 00 00 00       	mov    $0x1,%eax
  8010a4:	89 d1                	mov    %edx,%ecx
  8010a6:	89 d3                	mov    %edx,%ebx
  8010a8:	89 d7                	mov    %edx,%edi
  8010aa:	89 d6                	mov    %edx,%esi
  8010ac:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	57                   	push   %edi
  8010b7:	56                   	push   %esi
  8010b8:	53                   	push   %ebx
  8010b9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010c1:	b8 03 00 00 00       	mov    $0x3,%eax
  8010c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c9:	89 cb                	mov    %ecx,%ebx
  8010cb:	89 cf                	mov    %ecx,%edi
  8010cd:	89 ce                	mov    %ecx,%esi
  8010cf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	7e 28                	jle    8010fd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010e0:	00 
  8010e1:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  8010e8:	00 
  8010e9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f0:	00 
  8010f1:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  8010f8:	e8 03 f5 ff ff       	call   800600 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010fd:	83 c4 2c             	add    $0x2c,%esp
  801100:	5b                   	pop    %ebx
  801101:	5e                   	pop    %esi
  801102:	5f                   	pop    %edi
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    

00801105 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	57                   	push   %edi
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80110b:	ba 00 00 00 00       	mov    $0x0,%edx
  801110:	b8 02 00 00 00       	mov    $0x2,%eax
  801115:	89 d1                	mov    %edx,%ecx
  801117:	89 d3                	mov    %edx,%ebx
  801119:	89 d7                	mov    %edx,%edi
  80111b:	89 d6                	mov    %edx,%esi
  80111d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80111f:	5b                   	pop    %ebx
  801120:	5e                   	pop    %esi
  801121:	5f                   	pop    %edi
  801122:	5d                   	pop    %ebp
  801123:	c3                   	ret    

00801124 <sys_yield>:

void
sys_yield(void)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	57                   	push   %edi
  801128:	56                   	push   %esi
  801129:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80112a:	ba 00 00 00 00       	mov    $0x0,%edx
  80112f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801134:	89 d1                	mov    %edx,%ecx
  801136:	89 d3                	mov    %edx,%ebx
  801138:	89 d7                	mov    %edx,%edi
  80113a:	89 d6                	mov    %edx,%esi
  80113c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80113e:	5b                   	pop    %ebx
  80113f:	5e                   	pop    %esi
  801140:	5f                   	pop    %edi
  801141:	5d                   	pop    %ebp
  801142:	c3                   	ret    

00801143 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	57                   	push   %edi
  801147:	56                   	push   %esi
  801148:	53                   	push   %ebx
  801149:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114c:	be 00 00 00 00       	mov    $0x0,%esi
  801151:	b8 04 00 00 00       	mov    $0x4,%eax
  801156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801159:	8b 55 08             	mov    0x8(%ebp),%edx
  80115c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80115f:	89 f7                	mov    %esi,%edi
  801161:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801163:	85 c0                	test   %eax,%eax
  801165:	7e 28                	jle    80118f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801167:	89 44 24 10          	mov    %eax,0x10(%esp)
  80116b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801172:	00 
  801173:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  80117a:	00 
  80117b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801182:	00 
  801183:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  80118a:	e8 71 f4 ff ff       	call   800600 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80118f:	83 c4 2c             	add    $0x2c,%esp
  801192:	5b                   	pop    %ebx
  801193:	5e                   	pop    %esi
  801194:	5f                   	pop    %edi
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	57                   	push   %edi
  80119b:	56                   	push   %esi
  80119c:	53                   	push   %ebx
  80119d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8011a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011ae:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8011b4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	7e 28                	jle    8011e2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011be:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8011c5:	00 
  8011c6:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  8011cd:	00 
  8011ce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d5:	00 
  8011d6:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  8011dd:	e8 1e f4 ff ff       	call   800600 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011e2:	83 c4 2c             	add    $0x2c,%esp
  8011e5:	5b                   	pop    %ebx
  8011e6:	5e                   	pop    %esi
  8011e7:	5f                   	pop    %edi
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    

008011ea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  8011f8:	b8 06 00 00 00       	mov    $0x6,%eax
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
  80120b:	7e 28                	jle    801235 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80120d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801211:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801218:	00 
  801219:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  801220:	00 
  801221:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801228:	00 
  801229:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  801230:	e8 cb f3 ff ff       	call   800600 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801235:	83 c4 2c             	add    $0x2c,%esp
  801238:	5b                   	pop    %ebx
  801239:	5e                   	pop    %esi
  80123a:	5f                   	pop    %edi
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    

0080123d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  80124b:	b8 08 00 00 00       	mov    $0x8,%eax
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
  80125e:	7e 28                	jle    801288 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801260:	89 44 24 10          	mov    %eax,0x10(%esp)
  801264:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80126b:	00 
  80126c:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  801283:	e8 78 f3 ff ff       	call   800600 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801288:	83 c4 2c             	add    $0x2c,%esp
  80128b:	5b                   	pop    %ebx
  80128c:	5e                   	pop    %esi
  80128d:	5f                   	pop    %edi
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    

00801290 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	57                   	push   %edi
  801294:	56                   	push   %esi
  801295:	53                   	push   %ebx
  801296:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801299:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129e:	b8 09 00 00 00       	mov    $0x9,%eax
  8012a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a9:	89 df                	mov    %ebx,%edi
  8012ab:	89 de                	mov    %ebx,%esi
  8012ad:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	7e 28                	jle    8012db <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8012be:	00 
  8012bf:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  8012c6:	00 
  8012c7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012ce:	00 
  8012cf:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  8012d6:	e8 25 f3 ff ff       	call   800600 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012db:	83 c4 2c             	add    $0x2c,%esp
  8012de:	5b                   	pop    %ebx
  8012df:	5e                   	pop    %esi
  8012e0:	5f                   	pop    %edi
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    

008012e3 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	57                   	push   %edi
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
  8012e9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fc:	89 df                	mov    %ebx,%edi
  8012fe:	89 de                	mov    %ebx,%esi
  801300:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801302:	85 c0                	test   %eax,%eax
  801304:	7e 28                	jle    80132e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801306:	89 44 24 10          	mov    %eax,0x10(%esp)
  80130a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801311:	00 
  801312:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  801319:	00 
  80131a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801321:	00 
  801322:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  801329:	e8 d2 f2 ff ff       	call   800600 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80132e:	83 c4 2c             	add    $0x2c,%esp
  801331:	5b                   	pop    %ebx
  801332:	5e                   	pop    %esi
  801333:	5f                   	pop    %edi
  801334:	5d                   	pop    %ebp
  801335:	c3                   	ret    

00801336 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	57                   	push   %edi
  80133a:	56                   	push   %esi
  80133b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80133c:	be 00 00 00 00       	mov    $0x0,%esi
  801341:	b8 0c 00 00 00       	mov    $0xc,%eax
  801346:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801349:	8b 55 08             	mov    0x8(%ebp),%edx
  80134c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80134f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801352:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801354:	5b                   	pop    %ebx
  801355:	5e                   	pop    %esi
  801356:	5f                   	pop    %edi
  801357:	5d                   	pop    %ebp
  801358:	c3                   	ret    

00801359 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	57                   	push   %edi
  80135d:	56                   	push   %esi
  80135e:	53                   	push   %ebx
  80135f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801362:	b9 00 00 00 00       	mov    $0x0,%ecx
  801367:	b8 0d 00 00 00       	mov    $0xd,%eax
  80136c:	8b 55 08             	mov    0x8(%ebp),%edx
  80136f:	89 cb                	mov    %ecx,%ebx
  801371:	89 cf                	mov    %ecx,%edi
  801373:	89 ce                	mov    %ecx,%esi
  801375:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801377:	85 c0                	test   %eax,%eax
  801379:	7e 28                	jle    8013a3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80137b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80137f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801386:	00 
  801387:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  80138e:	00 
  80138f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801396:	00 
  801397:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  80139e:	e8 5d f2 ff ff       	call   800600 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8013a3:	83 c4 2c             	add    $0x2c,%esp
  8013a6:	5b                   	pop    %ebx
  8013a7:	5e                   	pop    %esi
  8013a8:	5f                   	pop    %edi
  8013a9:	5d                   	pop    %ebp
  8013aa:	c3                   	ret    

008013ab <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	57                   	push   %edi
  8013af:	56                   	push   %esi
  8013b0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013bb:	89 d1                	mov    %edx,%ecx
  8013bd:	89 d3                	mov    %edx,%ebx
  8013bf:	89 d7                	mov    %edx,%edi
  8013c1:	89 d6                	mov    %edx,%esi
  8013c3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013c5:	5b                   	pop    %ebx
  8013c6:	5e                   	pop    %esi
  8013c7:	5f                   	pop    %edi
  8013c8:	5d                   	pop    %ebp
  8013c9:	c3                   	ret    

008013ca <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	57                   	push   %edi
  8013ce:	56                   	push   %esi
  8013cf:	53                   	push   %ebx
  8013d0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e3:	89 df                	mov    %ebx,%edi
  8013e5:	89 de                	mov    %ebx,%esi
  8013e7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	7e 28                	jle    801415 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013f1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8013f8:	00 
  8013f9:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  801400:	00 
  801401:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801408:	00 
  801409:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  801410:	e8 eb f1 ff ff       	call   800600 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801415:	83 c4 2c             	add    $0x2c,%esp
  801418:	5b                   	pop    %ebx
  801419:	5e                   	pop    %esi
  80141a:	5f                   	pop    %edi
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    

0080141d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	57                   	push   %edi
  801421:	56                   	push   %esi
  801422:	53                   	push   %ebx
  801423:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142b:	b8 10 00 00 00       	mov    $0x10,%eax
  801430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801433:	8b 55 08             	mov    0x8(%ebp),%edx
  801436:	89 df                	mov    %ebx,%edi
  801438:	89 de                	mov    %ebx,%esi
  80143a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80143c:	85 c0                	test   %eax,%eax
  80143e:	7e 28                	jle    801468 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801440:	89 44 24 10          	mov    %eax,0x10(%esp)
  801444:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80144b:	00 
  80144c:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  801453:	00 
  801454:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80145b:	00 
  80145c:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  801463:	e8 98 f1 ff ff       	call   800600 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801468:	83 c4 2c             	add    $0x2c,%esp
  80146b:	5b                   	pop    %ebx
  80146c:	5e                   	pop    %esi
  80146d:	5f                   	pop    %edi
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    

00801470 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  801476:	83 3d b8 50 80 00 00 	cmpl   $0x0,0x8050b8
  80147d:	75 58                	jne    8014d7 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  80147f:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801484:	8b 40 48             	mov    0x48(%eax),%eax
  801487:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80148e:	00 
  80148f:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801496:	ee 
  801497:	89 04 24             	mov    %eax,(%esp)
  80149a:	e8 a4 fc ff ff       	call   801143 <sys_page_alloc>
		if(return_code!=0)
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	74 1c                	je     8014bf <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  8014a3:	c7 44 24 08 0c 30 80 	movl   $0x80300c,0x8(%esp)
  8014aa:	00 
  8014ab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014b2:	00 
  8014b3:	c7 04 24 65 30 80 00 	movl   $0x803065,(%esp)
  8014ba:	e8 41 f1 ff ff       	call   800600 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  8014bf:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8014c4:	8b 40 48             	mov    0x48(%eax),%eax
  8014c7:	c7 44 24 04 e1 14 80 	movl   $0x8014e1,0x4(%esp)
  8014ce:	00 
  8014cf:	89 04 24             	mov    %eax,(%esp)
  8014d2:	e8 0c fe ff ff       	call   8012e3 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	a3 b8 50 80 00       	mov    %eax,0x8050b8
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014e1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8014e2:	a1 b8 50 80 00       	mov    0x8050b8,%eax
	call *%eax
  8014e7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8014e9:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  8014ec:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  8014ee:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  8014f2:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  8014f6:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  8014f7:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  8014f9:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  8014fb:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  8014ff:	58                   	pop    %eax
	popl %eax;
  801500:	58                   	pop    %eax
	popal;
  801501:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  801502:	83 c4 04             	add    $0x4,%esp
	popfl;
  801505:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  801506:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  801507:	c3                   	ret    
  801508:	66 90                	xchg   %ax,%ax
  80150a:	66 90                	xchg   %ax,%ax
  80150c:	66 90                	xchg   %ax,%ax
  80150e:	66 90                	xchg   %ax,%ax

00801510 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	05 00 00 00 30       	add    $0x30000000,%eax
  80151b:	c1 e8 0c             	shr    $0xc,%eax
}
  80151e:	5d                   	pop    %ebp
  80151f:	c3                   	ret    

00801520 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80152b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801530:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    

00801537 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801542:	89 c2                	mov    %eax,%edx
  801544:	c1 ea 16             	shr    $0x16,%edx
  801547:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80154e:	f6 c2 01             	test   $0x1,%dl
  801551:	74 11                	je     801564 <fd_alloc+0x2d>
  801553:	89 c2                	mov    %eax,%edx
  801555:	c1 ea 0c             	shr    $0xc,%edx
  801558:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80155f:	f6 c2 01             	test   $0x1,%dl
  801562:	75 09                	jne    80156d <fd_alloc+0x36>
			*fd_store = fd;
  801564:	89 01                	mov    %eax,(%ecx)
			return 0;
  801566:	b8 00 00 00 00       	mov    $0x0,%eax
  80156b:	eb 17                	jmp    801584 <fd_alloc+0x4d>
  80156d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801572:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801577:	75 c9                	jne    801542 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801579:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80157f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80158c:	83 f8 1f             	cmp    $0x1f,%eax
  80158f:	77 36                	ja     8015c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801591:	c1 e0 0c             	shl    $0xc,%eax
  801594:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801599:	89 c2                	mov    %eax,%edx
  80159b:	c1 ea 16             	shr    $0x16,%edx
  80159e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015a5:	f6 c2 01             	test   $0x1,%dl
  8015a8:	74 24                	je     8015ce <fd_lookup+0x48>
  8015aa:	89 c2                	mov    %eax,%edx
  8015ac:	c1 ea 0c             	shr    $0xc,%edx
  8015af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015b6:	f6 c2 01             	test   $0x1,%dl
  8015b9:	74 1a                	je     8015d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015be:	89 02                	mov    %eax,(%edx)
	return 0;
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c5:	eb 13                	jmp    8015da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cc:	eb 0c                	jmp    8015da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d3:	eb 05                	jmp    8015da <fd_lookup+0x54>
  8015d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
  8015e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  8015e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ea:	eb 13                	jmp    8015ff <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  8015ec:	39 08                	cmp    %ecx,(%eax)
  8015ee:	75 0c                	jne    8015fc <dev_lookup+0x20>
			*dev = devtab[i];
  8015f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fa:	eb 38                	jmp    801634 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  8015fc:	83 c2 01             	add    $0x1,%edx
  8015ff:	8b 04 95 f4 30 80 00 	mov    0x8030f4(,%edx,4),%eax
  801606:	85 c0                	test   %eax,%eax
  801608:	75 e2                	jne    8015ec <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80160a:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80160f:	8b 40 48             	mov    0x48(%eax),%eax
  801612:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801616:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161a:	c7 04 24 74 30 80 00 	movl   $0x803074,(%esp)
  801621:	e8 d3 f0 ff ff       	call   8006f9 <cprintf>
	*dev = 0;
  801626:	8b 45 0c             	mov    0xc(%ebp),%eax
  801629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80162f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	56                   	push   %esi
  80163a:	53                   	push   %ebx
  80163b:	83 ec 20             	sub    $0x20,%esp
  80163e:	8b 75 08             	mov    0x8(%ebp),%esi
  801641:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801644:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801647:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80164b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801651:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801654:	89 04 24             	mov    %eax,(%esp)
  801657:	e8 2a ff ff ff       	call   801586 <fd_lookup>
  80165c:	85 c0                	test   %eax,%eax
  80165e:	78 05                	js     801665 <fd_close+0x2f>
	    || fd != fd2)
  801660:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801663:	74 0c                	je     801671 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801665:	84 db                	test   %bl,%bl
  801667:	ba 00 00 00 00       	mov    $0x0,%edx
  80166c:	0f 44 c2             	cmove  %edx,%eax
  80166f:	eb 3f                	jmp    8016b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801671:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801674:	89 44 24 04          	mov    %eax,0x4(%esp)
  801678:	8b 06                	mov    (%esi),%eax
  80167a:	89 04 24             	mov    %eax,(%esp)
  80167d:	e8 5a ff ff ff       	call   8015dc <dev_lookup>
  801682:	89 c3                	mov    %eax,%ebx
  801684:	85 c0                	test   %eax,%eax
  801686:	78 16                	js     80169e <fd_close+0x68>
		if (dev->dev_close)
  801688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80168e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801693:	85 c0                	test   %eax,%eax
  801695:	74 07                	je     80169e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801697:	89 34 24             	mov    %esi,(%esp)
  80169a:	ff d0                	call   *%eax
  80169c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80169e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a9:	e8 3c fb ff ff       	call   8011ea <sys_page_unmap>
	return r;
  8016ae:	89 d8                	mov    %ebx,%eax
}
  8016b0:	83 c4 20             	add    $0x20,%esp
  8016b3:	5b                   	pop    %ebx
  8016b4:	5e                   	pop    %esi
  8016b5:	5d                   	pop    %ebp
  8016b6:	c3                   	ret    

008016b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	89 04 24             	mov    %eax,(%esp)
  8016ca:	e8 b7 fe ff ff       	call   801586 <fd_lookup>
  8016cf:	89 c2                	mov    %eax,%edx
  8016d1:	85 d2                	test   %edx,%edx
  8016d3:	78 13                	js     8016e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8016d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016dc:	00 
  8016dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e0:	89 04 24             	mov    %eax,(%esp)
  8016e3:	e8 4e ff ff ff       	call   801636 <fd_close>
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <close_all>:

void
close_all(void)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	53                   	push   %ebx
  8016ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016f6:	89 1c 24             	mov    %ebx,(%esp)
  8016f9:	e8 b9 ff ff ff       	call   8016b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016fe:	83 c3 01             	add    $0x1,%ebx
  801701:	83 fb 20             	cmp    $0x20,%ebx
  801704:	75 f0                	jne    8016f6 <close_all+0xc>
		close(i);
}
  801706:	83 c4 14             	add    $0x14,%esp
  801709:	5b                   	pop    %ebx
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	57                   	push   %edi
  801710:	56                   	push   %esi
  801711:	53                   	push   %ebx
  801712:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801715:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801718:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	89 04 24             	mov    %eax,(%esp)
  801722:	e8 5f fe ff ff       	call   801586 <fd_lookup>
  801727:	89 c2                	mov    %eax,%edx
  801729:	85 d2                	test   %edx,%edx
  80172b:	0f 88 e1 00 00 00    	js     801812 <dup+0x106>
		return r;
	close(newfdnum);
  801731:	8b 45 0c             	mov    0xc(%ebp),%eax
  801734:	89 04 24             	mov    %eax,(%esp)
  801737:	e8 7b ff ff ff       	call   8016b7 <close>

	newfd = INDEX2FD(newfdnum);
  80173c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80173f:	c1 e3 0c             	shl    $0xc,%ebx
  801742:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80174b:	89 04 24             	mov    %eax,(%esp)
  80174e:	e8 cd fd ff ff       	call   801520 <fd2data>
  801753:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801755:	89 1c 24             	mov    %ebx,(%esp)
  801758:	e8 c3 fd ff ff       	call   801520 <fd2data>
  80175d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80175f:	89 f0                	mov    %esi,%eax
  801761:	c1 e8 16             	shr    $0x16,%eax
  801764:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80176b:	a8 01                	test   $0x1,%al
  80176d:	74 43                	je     8017b2 <dup+0xa6>
  80176f:	89 f0                	mov    %esi,%eax
  801771:	c1 e8 0c             	shr    $0xc,%eax
  801774:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80177b:	f6 c2 01             	test   $0x1,%dl
  80177e:	74 32                	je     8017b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801780:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801787:	25 07 0e 00 00       	and    $0xe07,%eax
  80178c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801790:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801794:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80179b:	00 
  80179c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a7:	e8 eb f9 ff ff       	call   801197 <sys_page_map>
  8017ac:	89 c6                	mov    %eax,%esi
  8017ae:	85 c0                	test   %eax,%eax
  8017b0:	78 3e                	js     8017f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b5:	89 c2                	mov    %eax,%edx
  8017b7:	c1 ea 0c             	shr    $0xc,%edx
  8017ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8017cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017d6:	00 
  8017d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e2:	e8 b0 f9 ff ff       	call   801197 <sys_page_map>
  8017e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017ec:	85 f6                	test   %esi,%esi
  8017ee:	79 22                	jns    801812 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017fb:	e8 ea f9 ff ff       	call   8011ea <sys_page_unmap>
	sys_page_unmap(0, nva);
  801800:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801804:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80180b:	e8 da f9 ff ff       	call   8011ea <sys_page_unmap>
	return r;
  801810:	89 f0                	mov    %esi,%eax
}
  801812:	83 c4 3c             	add    $0x3c,%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5f                   	pop    %edi
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    

0080181a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	53                   	push   %ebx
  80181e:	83 ec 24             	sub    $0x24,%esp
  801821:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801824:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801827:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182b:	89 1c 24             	mov    %ebx,(%esp)
  80182e:	e8 53 fd ff ff       	call   801586 <fd_lookup>
  801833:	89 c2                	mov    %eax,%edx
  801835:	85 d2                	test   %edx,%edx
  801837:	78 6d                	js     8018a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801839:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801843:	8b 00                	mov    (%eax),%eax
  801845:	89 04 24             	mov    %eax,(%esp)
  801848:	e8 8f fd ff ff       	call   8015dc <dev_lookup>
  80184d:	85 c0                	test   %eax,%eax
  80184f:	78 55                	js     8018a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801854:	8b 50 08             	mov    0x8(%eax),%edx
  801857:	83 e2 03             	and    $0x3,%edx
  80185a:	83 fa 01             	cmp    $0x1,%edx
  80185d:	75 23                	jne    801882 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80185f:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801864:	8b 40 48             	mov    0x48(%eax),%eax
  801867:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80186b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186f:	c7 04 24 b8 30 80 00 	movl   $0x8030b8,(%esp)
  801876:	e8 7e ee ff ff       	call   8006f9 <cprintf>
		return -E_INVAL;
  80187b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801880:	eb 24                	jmp    8018a6 <read+0x8c>
	}
	if (!dev->dev_read)
  801882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801885:	8b 52 08             	mov    0x8(%edx),%edx
  801888:	85 d2                	test   %edx,%edx
  80188a:	74 15                	je     8018a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80188c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801893:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801896:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80189a:	89 04 24             	mov    %eax,(%esp)
  80189d:	ff d2                	call   *%edx
  80189f:	eb 05                	jmp    8018a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018a6:	83 c4 24             	add    $0x24,%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    

008018ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	57                   	push   %edi
  8018b0:	56                   	push   %esi
  8018b1:	53                   	push   %ebx
  8018b2:	83 ec 1c             	sub    $0x1c,%esp
  8018b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c0:	eb 23                	jmp    8018e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018c2:	89 f0                	mov    %esi,%eax
  8018c4:	29 d8                	sub    %ebx,%eax
  8018c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018ca:	89 d8                	mov    %ebx,%eax
  8018cc:	03 45 0c             	add    0xc(%ebp),%eax
  8018cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d3:	89 3c 24             	mov    %edi,(%esp)
  8018d6:	e8 3f ff ff ff       	call   80181a <read>
		if (m < 0)
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	78 10                	js     8018ef <readn+0x43>
			return m;
		if (m == 0)
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	74 0a                	je     8018ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018e3:	01 c3                	add    %eax,%ebx
  8018e5:	39 f3                	cmp    %esi,%ebx
  8018e7:	72 d9                	jb     8018c2 <readn+0x16>
  8018e9:	89 d8                	mov    %ebx,%eax
  8018eb:	eb 02                	jmp    8018ef <readn+0x43>
  8018ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8018ef:	83 c4 1c             	add    $0x1c,%esp
  8018f2:	5b                   	pop    %ebx
  8018f3:	5e                   	pop    %esi
  8018f4:	5f                   	pop    %edi
  8018f5:	5d                   	pop    %ebp
  8018f6:	c3                   	ret    

008018f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	53                   	push   %ebx
  8018fb:	83 ec 24             	sub    $0x24,%esp
  8018fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801901:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801904:	89 44 24 04          	mov    %eax,0x4(%esp)
  801908:	89 1c 24             	mov    %ebx,(%esp)
  80190b:	e8 76 fc ff ff       	call   801586 <fd_lookup>
  801910:	89 c2                	mov    %eax,%edx
  801912:	85 d2                	test   %edx,%edx
  801914:	78 68                	js     80197e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801916:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801919:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801920:	8b 00                	mov    (%eax),%eax
  801922:	89 04 24             	mov    %eax,(%esp)
  801925:	e8 b2 fc ff ff       	call   8015dc <dev_lookup>
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 50                	js     80197e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80192e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801931:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801935:	75 23                	jne    80195a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801937:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80193c:	8b 40 48             	mov    0x48(%eax),%eax
  80193f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801943:	89 44 24 04          	mov    %eax,0x4(%esp)
  801947:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  80194e:	e8 a6 ed ff ff       	call   8006f9 <cprintf>
		return -E_INVAL;
  801953:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801958:	eb 24                	jmp    80197e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80195a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195d:	8b 52 0c             	mov    0xc(%edx),%edx
  801960:	85 d2                	test   %edx,%edx
  801962:	74 15                	je     801979 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801964:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801967:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80196b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80196e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801972:	89 04 24             	mov    %eax,(%esp)
  801975:	ff d2                	call   *%edx
  801977:	eb 05                	jmp    80197e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801979:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80197e:	83 c4 24             	add    $0x24,%esp
  801981:	5b                   	pop    %ebx
  801982:	5d                   	pop    %ebp
  801983:	c3                   	ret    

00801984 <seek>:

int
seek(int fdnum, off_t offset)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80198a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80198d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	89 04 24             	mov    %eax,(%esp)
  801997:	e8 ea fb ff ff       	call   801586 <fd_lookup>
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 0e                	js     8019ae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 24             	sub    $0x24,%esp
  8019b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c1:	89 1c 24             	mov    %ebx,(%esp)
  8019c4:	e8 bd fb ff ff       	call   801586 <fd_lookup>
  8019c9:	89 c2                	mov    %eax,%edx
  8019cb:	85 d2                	test   %edx,%edx
  8019cd:	78 61                	js     801a30 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d9:	8b 00                	mov    (%eax),%eax
  8019db:	89 04 24             	mov    %eax,(%esp)
  8019de:	e8 f9 fb ff ff       	call   8015dc <dev_lookup>
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 49                	js     801a30 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019ee:	75 23                	jne    801a13 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8019f0:	a1 b4 50 80 00       	mov    0x8050b4,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019f5:	8b 40 48             	mov    0x48(%eax),%eax
  8019f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a00:	c7 04 24 94 30 80 00 	movl   $0x803094,(%esp)
  801a07:	e8 ed ec ff ff       	call   8006f9 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a11:	eb 1d                	jmp    801a30 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a16:	8b 52 18             	mov    0x18(%edx),%edx
  801a19:	85 d2                	test   %edx,%edx
  801a1b:	74 0e                	je     801a2b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a24:	89 04 24             	mov    %eax,(%esp)
  801a27:	ff d2                	call   *%edx
  801a29:	eb 05                	jmp    801a30 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a30:	83 c4 24             	add    $0x24,%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    

00801a36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	53                   	push   %ebx
  801a3a:	83 ec 24             	sub    $0x24,%esp
  801a3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	89 04 24             	mov    %eax,(%esp)
  801a4d:	e8 34 fb ff ff       	call   801586 <fd_lookup>
  801a52:	89 c2                	mov    %eax,%edx
  801a54:	85 d2                	test   %edx,%edx
  801a56:	78 52                	js     801aaa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a62:	8b 00                	mov    (%eax),%eax
  801a64:	89 04 24             	mov    %eax,(%esp)
  801a67:	e8 70 fb ff ff       	call   8015dc <dev_lookup>
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 3a                	js     801aaa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a73:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a77:	74 2c                	je     801aa5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a79:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a7c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a83:	00 00 00 
	stat->st_isdir = 0;
  801a86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a8d:	00 00 00 
	stat->st_dev = dev;
  801a90:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a9d:	89 14 24             	mov    %edx,(%esp)
  801aa0:	ff 50 14             	call   *0x14(%eax)
  801aa3:	eb 05                	jmp    801aaa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801aa5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801aaa:	83 c4 24             	add    $0x24,%esp
  801aad:	5b                   	pop    %ebx
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    

00801ab0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	56                   	push   %esi
  801ab4:	53                   	push   %ebx
  801ab5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ab8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801abf:	00 
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	89 04 24             	mov    %eax,(%esp)
  801ac6:	e8 28 02 00 00       	call   801cf3 <open>
  801acb:	89 c3                	mov    %eax,%ebx
  801acd:	85 db                	test   %ebx,%ebx
  801acf:	78 1b                	js     801aec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad8:	89 1c 24             	mov    %ebx,(%esp)
  801adb:	e8 56 ff ff ff       	call   801a36 <fstat>
  801ae0:	89 c6                	mov    %eax,%esi
	close(fd);
  801ae2:	89 1c 24             	mov    %ebx,(%esp)
  801ae5:	e8 cd fb ff ff       	call   8016b7 <close>
	return r;
  801aea:	89 f0                	mov    %esi,%eax
}
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5d                   	pop    %ebp
  801af2:	c3                   	ret    

00801af3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	56                   	push   %esi
  801af7:	53                   	push   %ebx
  801af8:	83 ec 10             	sub    $0x10,%esp
  801afb:	89 c6                	mov    %eax,%esi
  801afd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801aff:	83 3d ac 50 80 00 00 	cmpl   $0x0,0x8050ac
  801b06:	75 11                	jne    801b19 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b0f:	e8 7a 0d 00 00       	call   80288e <ipc_find_env>
  801b14:	a3 ac 50 80 00       	mov    %eax,0x8050ac
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b19:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b20:	00 
  801b21:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b28:	00 
  801b29:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b2d:	a1 ac 50 80 00       	mov    0x8050ac,%eax
  801b32:	89 04 24             	mov    %eax,(%esp)
  801b35:	e8 f6 0c 00 00       	call   802830 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b41:	00 
  801b42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b4d:	e8 74 0c 00 00       	call   8027c6 <ipc_recv>
}
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    

00801b59 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	8b 40 0c             	mov    0xc(%eax),%eax
  801b65:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b72:	ba 00 00 00 00       	mov    $0x0,%edx
  801b77:	b8 02 00 00 00       	mov    $0x2,%eax
  801b7c:	e8 72 ff ff ff       	call   801af3 <fsipc>
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b94:	ba 00 00 00 00       	mov    $0x0,%edx
  801b99:	b8 06 00 00 00       	mov    $0x6,%eax
  801b9e:	e8 50 ff ff ff       	call   801af3 <fsipc>
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	53                   	push   %ebx
  801ba9:	83 ec 14             	sub    $0x14,%esp
  801bac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bba:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbf:	b8 05 00 00 00       	mov    $0x5,%eax
  801bc4:	e8 2a ff ff ff       	call   801af3 <fsipc>
  801bc9:	89 c2                	mov    %eax,%edx
  801bcb:	85 d2                	test   %edx,%edx
  801bcd:	78 2b                	js     801bfa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bcf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bd6:	00 
  801bd7:	89 1c 24             	mov    %ebx,(%esp)
  801bda:	e8 48 f1 ff ff       	call   800d27 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bdf:	a1 80 60 80 00       	mov    0x806080,%eax
  801be4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bea:	a1 84 60 80 00       	mov    0x806084,%eax
  801bef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfa:	83 c4 14             	add    $0x14,%esp
  801bfd:	5b                   	pop    %ebx
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    

00801c00 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 18             	sub    $0x18,%esp
  801c06:	8b 45 10             	mov    0x10(%ebp),%eax
  801c09:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801c0e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801c13:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801c16:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c1b:	8b 55 08             	mov    0x8(%ebp),%edx
  801c1e:	8b 52 0c             	mov    0xc(%edx),%edx
  801c21:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801c27:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c32:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c39:	e8 86 f2 ff ff       	call   800ec4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c43:	b8 04 00 00 00       	mov    $0x4,%eax
  801c48:	e8 a6 fe ff ff       	call   801af3 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	56                   	push   %esi
  801c53:	53                   	push   %ebx
  801c54:	83 ec 10             	sub    $0x10,%esp
  801c57:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c60:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c65:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c70:	b8 03 00 00 00       	mov    $0x3,%eax
  801c75:	e8 79 fe ff ff       	call   801af3 <fsipc>
  801c7a:	89 c3                	mov    %eax,%ebx
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 6a                	js     801cea <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c80:	39 c6                	cmp    %eax,%esi
  801c82:	73 24                	jae    801ca8 <devfile_read+0x59>
  801c84:	c7 44 24 0c 08 31 80 	movl   $0x803108,0xc(%esp)
  801c8b:	00 
  801c8c:	c7 44 24 08 0f 31 80 	movl   $0x80310f,0x8(%esp)
  801c93:	00 
  801c94:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801c9b:	00 
  801c9c:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  801ca3:	e8 58 e9 ff ff       	call   800600 <_panic>
	assert(r <= PGSIZE);
  801ca8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cad:	7e 24                	jle    801cd3 <devfile_read+0x84>
  801caf:	c7 44 24 0c 2f 31 80 	movl   $0x80312f,0xc(%esp)
  801cb6:	00 
  801cb7:	c7 44 24 08 0f 31 80 	movl   $0x80310f,0x8(%esp)
  801cbe:	00 
  801cbf:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801cc6:	00 
  801cc7:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  801cce:	e8 2d e9 ff ff       	call   800600 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cd3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cd7:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cde:	00 
  801cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce2:	89 04 24             	mov    %eax,(%esp)
  801ce5:	e8 da f1 ff ff       	call   800ec4 <memmove>
	return r;
}
  801cea:	89 d8                	mov    %ebx,%eax
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	53                   	push   %ebx
  801cf7:	83 ec 24             	sub    $0x24,%esp
  801cfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801cfd:	89 1c 24             	mov    %ebx,(%esp)
  801d00:	e8 eb ef ff ff       	call   800cf0 <strlen>
  801d05:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d0a:	7f 60                	jg     801d6c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d0f:	89 04 24             	mov    %eax,(%esp)
  801d12:	e8 20 f8 ff ff       	call   801537 <fd_alloc>
  801d17:	89 c2                	mov    %eax,%edx
  801d19:	85 d2                	test   %edx,%edx
  801d1b:	78 54                	js     801d71 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d1d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d21:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d28:	e8 fa ef ff ff       	call   800d27 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d30:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d38:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3d:	e8 b1 fd ff ff       	call   801af3 <fsipc>
  801d42:	89 c3                	mov    %eax,%ebx
  801d44:	85 c0                	test   %eax,%eax
  801d46:	79 17                	jns    801d5f <open+0x6c>
		fd_close(fd, 0);
  801d48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d4f:	00 
  801d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d53:	89 04 24             	mov    %eax,(%esp)
  801d56:	e8 db f8 ff ff       	call   801636 <fd_close>
		return r;
  801d5b:	89 d8                	mov    %ebx,%eax
  801d5d:	eb 12                	jmp    801d71 <open+0x7e>
	}

	return fd2num(fd);
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	89 04 24             	mov    %eax,(%esp)
  801d65:	e8 a6 f7 ff ff       	call   801510 <fd2num>
  801d6a:	eb 05                	jmp    801d71 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801d6c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801d71:	83 c4 24             	add    $0x24,%esp
  801d74:	5b                   	pop    %ebx
  801d75:	5d                   	pop    %ebp
  801d76:	c3                   	ret    

00801d77 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d82:	b8 08 00 00 00       	mov    $0x8,%eax
  801d87:	e8 67 fd ff ff       	call   801af3 <fsipc>
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    
  801d8e:	66 90                	xchg   %ax,%ax

00801d90 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d96:	c7 44 24 04 3b 31 80 	movl   $0x80313b,0x4(%esp)
  801d9d:	00 
  801d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da1:	89 04 24             	mov    %eax,(%esp)
  801da4:	e8 7e ef ff ff       	call   800d27 <strcpy>
	return 0;
}
  801da9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	53                   	push   %ebx
  801db4:	83 ec 14             	sub    $0x14,%esp
  801db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801dba:	89 1c 24             	mov    %ebx,(%esp)
  801dbd:	e8 04 0b 00 00       	call   8028c6 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801dc2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801dc7:	83 f8 01             	cmp    $0x1,%eax
  801dca:	75 0d                	jne    801dd9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801dcc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801dcf:	89 04 24             	mov    %eax,(%esp)
  801dd2:	e8 29 03 00 00       	call   802100 <nsipc_close>
  801dd7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801dd9:	89 d0                	mov    %edx,%eax
  801ddb:	83 c4 14             	add    $0x14,%esp
  801dde:	5b                   	pop    %ebx
  801ddf:	5d                   	pop    %ebp
  801de0:	c3                   	ret    

00801de1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801de7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dee:	00 
  801def:	8b 45 10             	mov    0x10(%ebp),%eax
  801df2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	8b 40 0c             	mov    0xc(%eax),%eax
  801e03:	89 04 24             	mov    %eax,(%esp)
  801e06:	e8 f0 03 00 00       	call   8021fb <nsipc_send>
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e13:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e1a:	00 
  801e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e2f:	89 04 24             	mov    %eax,(%esp)
  801e32:	e8 44 03 00 00       	call   80217b <nsipc_recv>
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e3f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e42:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e46:	89 04 24             	mov    %eax,(%esp)
  801e49:	e8 38 f7 ff ff       	call   801586 <fd_lookup>
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	78 17                	js     801e69 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e55:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e5b:	39 08                	cmp    %ecx,(%eax)
  801e5d:	75 05                	jne    801e64 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e62:	eb 05                	jmp    801e69 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801e64:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	56                   	push   %esi
  801e6f:	53                   	push   %ebx
  801e70:	83 ec 20             	sub    $0x20,%esp
  801e73:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e78:	89 04 24             	mov    %eax,(%esp)
  801e7b:	e8 b7 f6 ff ff       	call   801537 <fd_alloc>
  801e80:	89 c3                	mov    %eax,%ebx
  801e82:	85 c0                	test   %eax,%eax
  801e84:	78 21                	js     801ea7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e86:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e8d:	00 
  801e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e91:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e9c:	e8 a2 f2 ff ff       	call   801143 <sys_page_alloc>
  801ea1:	89 c3                	mov    %eax,%ebx
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	79 0c                	jns    801eb3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801ea7:	89 34 24             	mov    %esi,(%esp)
  801eaa:	e8 51 02 00 00       	call   802100 <nsipc_close>
		return r;
  801eaf:	89 d8                	mov    %ebx,%eax
  801eb1:	eb 20                	jmp    801ed3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801eb3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801ec8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801ecb:	89 14 24             	mov    %edx,(%esp)
  801ece:	e8 3d f6 ff ff       	call   801510 <fd2num>
}
  801ed3:	83 c4 20             	add    $0x20,%esp
  801ed6:	5b                   	pop    %ebx
  801ed7:	5e                   	pop    %esi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    

00801eda <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	e8 51 ff ff ff       	call   801e39 <fd2sockid>
		return r;
  801ee8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eea:	85 c0                	test   %eax,%eax
  801eec:	78 23                	js     801f11 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801eee:	8b 55 10             	mov    0x10(%ebp),%edx
  801ef1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801efc:	89 04 24             	mov    %eax,(%esp)
  801eff:	e8 45 01 00 00       	call   802049 <nsipc_accept>
		return r;
  801f04:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f06:	85 c0                	test   %eax,%eax
  801f08:	78 07                	js     801f11 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801f0a:	e8 5c ff ff ff       	call   801e6b <alloc_sockfd>
  801f0f:	89 c1                	mov    %eax,%ecx
}
  801f11:	89 c8                	mov    %ecx,%eax
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	e8 16 ff ff ff       	call   801e39 <fd2sockid>
  801f23:	89 c2                	mov    %eax,%edx
  801f25:	85 d2                	test   %edx,%edx
  801f27:	78 16                	js     801f3f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801f29:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f37:	89 14 24             	mov    %edx,(%esp)
  801f3a:	e8 60 01 00 00       	call   80209f <nsipc_bind>
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <shutdown>:

int
shutdown(int s, int how)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	e8 ea fe ff ff       	call   801e39 <fd2sockid>
  801f4f:	89 c2                	mov    %eax,%edx
  801f51:	85 d2                	test   %edx,%edx
  801f53:	78 0f                	js     801f64 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5c:	89 14 24             	mov    %edx,(%esp)
  801f5f:	e8 7a 01 00 00       	call   8020de <nsipc_shutdown>
}
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    

00801f66 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	e8 c5 fe ff ff       	call   801e39 <fd2sockid>
  801f74:	89 c2                	mov    %eax,%edx
  801f76:	85 d2                	test   %edx,%edx
  801f78:	78 16                	js     801f90 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f88:	89 14 24             	mov    %edx,(%esp)
  801f8b:	e8 8a 01 00 00       	call   80211a <nsipc_connect>
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <listen>:

int
listen(int s, int backlog)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	e8 99 fe ff ff       	call   801e39 <fd2sockid>
  801fa0:	89 c2                	mov    %eax,%edx
  801fa2:	85 d2                	test   %edx,%edx
  801fa4:	78 0f                	js     801fb5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fad:	89 14 24             	mov    %edx,(%esp)
  801fb0:	e8 a4 01 00 00       	call   802159 <nsipc_listen>
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fbd:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	89 04 24             	mov    %eax,(%esp)
  801fd1:	e8 98 02 00 00       	call   80226e <nsipc_socket>
  801fd6:	89 c2                	mov    %eax,%edx
  801fd8:	85 d2                	test   %edx,%edx
  801fda:	78 05                	js     801fe1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801fdc:	e8 8a fe ff ff       	call   801e6b <alloc_sockfd>
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	53                   	push   %ebx
  801fe7:	83 ec 14             	sub    $0x14,%esp
  801fea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fec:	83 3d b0 50 80 00 00 	cmpl   $0x0,0x8050b0
  801ff3:	75 11                	jne    802006 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ff5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801ffc:	e8 8d 08 00 00       	call   80288e <ipc_find_env>
  802001:	a3 b0 50 80 00       	mov    %eax,0x8050b0
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802006:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80200d:	00 
  80200e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802015:	00 
  802016:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80201a:	a1 b0 50 80 00       	mov    0x8050b0,%eax
  80201f:	89 04 24             	mov    %eax,(%esp)
  802022:	e8 09 08 00 00       	call   802830 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802027:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80202e:	00 
  80202f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802036:	00 
  802037:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80203e:	e8 83 07 00 00       	call   8027c6 <ipc_recv>
}
  802043:	83 c4 14             	add    $0x14,%esp
  802046:	5b                   	pop    %ebx
  802047:	5d                   	pop    %ebp
  802048:	c3                   	ret    

00802049 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	56                   	push   %esi
  80204d:	53                   	push   %ebx
  80204e:	83 ec 10             	sub    $0x10,%esp
  802051:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80205c:	8b 06                	mov    (%esi),%eax
  80205e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802063:	b8 01 00 00 00       	mov    $0x1,%eax
  802068:	e8 76 ff ff ff       	call   801fe3 <nsipc>
  80206d:	89 c3                	mov    %eax,%ebx
  80206f:	85 c0                	test   %eax,%eax
  802071:	78 23                	js     802096 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802073:	a1 10 70 80 00       	mov    0x807010,%eax
  802078:	89 44 24 08          	mov    %eax,0x8(%esp)
  80207c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802083:	00 
  802084:	8b 45 0c             	mov    0xc(%ebp),%eax
  802087:	89 04 24             	mov    %eax,(%esp)
  80208a:	e8 35 ee ff ff       	call   800ec4 <memmove>
		*addrlen = ret->ret_addrlen;
  80208f:	a1 10 70 80 00       	mov    0x807010,%eax
  802094:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802096:	89 d8                	mov    %ebx,%eax
  802098:	83 c4 10             	add    $0x10,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5e                   	pop    %esi
  80209d:	5d                   	pop    %ebp
  80209e:	c3                   	ret    

0080209f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	53                   	push   %ebx
  8020a3:	83 ec 14             	sub    $0x14,%esp
  8020a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020bc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8020c3:	e8 fc ed ff ff       	call   800ec4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020c8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8020d3:	e8 0b ff ff ff       	call   801fe3 <nsipc>
}
  8020d8:	83 c4 14             	add    $0x14,%esp
  8020db:	5b                   	pop    %ebx
  8020dc:	5d                   	pop    %ebp
  8020dd:	c3                   	ret    

008020de <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ef:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8020f9:	e8 e5 fe ff ff       	call   801fe3 <nsipc>
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <nsipc_close>:

int
nsipc_close(int s)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80210e:	b8 04 00 00 00       	mov    $0x4,%eax
  802113:	e8 cb fe ff ff       	call   801fe3 <nsipc>
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	53                   	push   %ebx
  80211e:	83 ec 14             	sub    $0x14,%esp
  802121:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80212c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802130:	8b 45 0c             	mov    0xc(%ebp),%eax
  802133:	89 44 24 04          	mov    %eax,0x4(%esp)
  802137:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80213e:	e8 81 ed ff ff       	call   800ec4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802143:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802149:	b8 05 00 00 00       	mov    $0x5,%eax
  80214e:	e8 90 fe ff ff       	call   801fe3 <nsipc>
}
  802153:	83 c4 14             	add    $0x14,%esp
  802156:	5b                   	pop    %ebx
  802157:	5d                   	pop    %ebp
  802158:	c3                   	ret    

00802159 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80216f:	b8 06 00 00 00       	mov    $0x6,%eax
  802174:	e8 6a fe ff ff       	call   801fe3 <nsipc>
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	56                   	push   %esi
  80217f:	53                   	push   %ebx
  802180:	83 ec 10             	sub    $0x10,%esp
  802183:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80218e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802194:	8b 45 14             	mov    0x14(%ebp),%eax
  802197:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80219c:	b8 07 00 00 00       	mov    $0x7,%eax
  8021a1:	e8 3d fe ff ff       	call   801fe3 <nsipc>
  8021a6:	89 c3                	mov    %eax,%ebx
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	78 46                	js     8021f2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8021ac:	39 f0                	cmp    %esi,%eax
  8021ae:	7f 07                	jg     8021b7 <nsipc_recv+0x3c>
  8021b0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021b5:	7e 24                	jle    8021db <nsipc_recv+0x60>
  8021b7:	c7 44 24 0c 47 31 80 	movl   $0x803147,0xc(%esp)
  8021be:	00 
  8021bf:	c7 44 24 08 0f 31 80 	movl   $0x80310f,0x8(%esp)
  8021c6:	00 
  8021c7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8021ce:	00 
  8021cf:	c7 04 24 5c 31 80 00 	movl   $0x80315c,(%esp)
  8021d6:	e8 25 e4 ff ff       	call   800600 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021df:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8021e6:	00 
  8021e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ea:	89 04 24             	mov    %eax,(%esp)
  8021ed:	e8 d2 ec ff ff       	call   800ec4 <memmove>
	}

	return r;
}
  8021f2:	89 d8                	mov    %ebx,%eax
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	5b                   	pop    %ebx
  8021f8:	5e                   	pop    %esi
  8021f9:	5d                   	pop    %ebp
  8021fa:	c3                   	ret    

008021fb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	53                   	push   %ebx
  8021ff:	83 ec 14             	sub    $0x14,%esp
  802202:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80220d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802213:	7e 24                	jle    802239 <nsipc_send+0x3e>
  802215:	c7 44 24 0c 68 31 80 	movl   $0x803168,0xc(%esp)
  80221c:	00 
  80221d:	c7 44 24 08 0f 31 80 	movl   $0x80310f,0x8(%esp)
  802224:	00 
  802225:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80222c:	00 
  80222d:	c7 04 24 5c 31 80 00 	movl   $0x80315c,(%esp)
  802234:	e8 c7 e3 ff ff       	call   800600 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802239:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80223d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802240:	89 44 24 04          	mov    %eax,0x4(%esp)
  802244:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80224b:	e8 74 ec ff ff       	call   800ec4 <memmove>
	nsipcbuf.send.req_size = size;
  802250:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802256:	8b 45 14             	mov    0x14(%ebp),%eax
  802259:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80225e:	b8 08 00 00 00       	mov    $0x8,%eax
  802263:	e8 7b fd ff ff       	call   801fe3 <nsipc>
}
  802268:	83 c4 14             	add    $0x14,%esp
  80226b:	5b                   	pop    %ebx
  80226c:	5d                   	pop    %ebp
  80226d:	c3                   	ret    

0080226e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80227c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802284:	8b 45 10             	mov    0x10(%ebp),%eax
  802287:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80228c:	b8 09 00 00 00       	mov    $0x9,%eax
  802291:	e8 4d fd ff ff       	call   801fe3 <nsipc>
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	56                   	push   %esi
  80229c:	53                   	push   %ebx
  80229d:	83 ec 10             	sub    $0x10,%esp
  8022a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	89 04 24             	mov    %eax,(%esp)
  8022a9:	e8 72 f2 ff ff       	call   801520 <fd2data>
  8022ae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022b0:	c7 44 24 04 74 31 80 	movl   $0x803174,0x4(%esp)
  8022b7:	00 
  8022b8:	89 1c 24             	mov    %ebx,(%esp)
  8022bb:	e8 67 ea ff ff       	call   800d27 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022c0:	8b 46 04             	mov    0x4(%esi),%eax
  8022c3:	2b 06                	sub    (%esi),%eax
  8022c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022d2:	00 00 00 
	stat->st_dev = &devpipe;
  8022d5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022dc:	40 80 00 
	return 0;
}
  8022df:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e4:	83 c4 10             	add    $0x10,%esp
  8022e7:	5b                   	pop    %ebx
  8022e8:	5e                   	pop    %esi
  8022e9:	5d                   	pop    %ebp
  8022ea:	c3                   	ret    

008022eb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	53                   	push   %ebx
  8022ef:	83 ec 14             	sub    $0x14,%esp
  8022f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802300:	e8 e5 ee ff ff       	call   8011ea <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802305:	89 1c 24             	mov    %ebx,(%esp)
  802308:	e8 13 f2 ff ff       	call   801520 <fd2data>
  80230d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802311:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802318:	e8 cd ee ff ff       	call   8011ea <sys_page_unmap>
}
  80231d:	83 c4 14             	add    $0x14,%esp
  802320:	5b                   	pop    %ebx
  802321:	5d                   	pop    %ebp
  802322:	c3                   	ret    

00802323 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	57                   	push   %edi
  802327:	56                   	push   %esi
  802328:	53                   	push   %ebx
  802329:	83 ec 2c             	sub    $0x2c,%esp
  80232c:	89 c6                	mov    %eax,%esi
  80232e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802331:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802336:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802339:	89 34 24             	mov    %esi,(%esp)
  80233c:	e8 85 05 00 00       	call   8028c6 <pageref>
  802341:	89 c7                	mov    %eax,%edi
  802343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802346:	89 04 24             	mov    %eax,(%esp)
  802349:	e8 78 05 00 00       	call   8028c6 <pageref>
  80234e:	39 c7                	cmp    %eax,%edi
  802350:	0f 94 c2             	sete   %dl
  802353:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802356:	8b 0d b4 50 80 00    	mov    0x8050b4,%ecx
  80235c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80235f:	39 fb                	cmp    %edi,%ebx
  802361:	74 21                	je     802384 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802363:	84 d2                	test   %dl,%dl
  802365:	74 ca                	je     802331 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802367:	8b 51 58             	mov    0x58(%ecx),%edx
  80236a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80236e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802372:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802376:	c7 04 24 7b 31 80 00 	movl   $0x80317b,(%esp)
  80237d:	e8 77 e3 ff ff       	call   8006f9 <cprintf>
  802382:	eb ad                	jmp    802331 <_pipeisclosed+0xe>
	}
}
  802384:	83 c4 2c             	add    $0x2c,%esp
  802387:	5b                   	pop    %ebx
  802388:	5e                   	pop    %esi
  802389:	5f                   	pop    %edi
  80238a:	5d                   	pop    %ebp
  80238b:	c3                   	ret    

0080238c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	57                   	push   %edi
  802390:	56                   	push   %esi
  802391:	53                   	push   %ebx
  802392:	83 ec 1c             	sub    $0x1c,%esp
  802395:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802398:	89 34 24             	mov    %esi,(%esp)
  80239b:	e8 80 f1 ff ff       	call   801520 <fd2data>
  8023a0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023a7:	eb 45                	jmp    8023ee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8023a9:	89 da                	mov    %ebx,%edx
  8023ab:	89 f0                	mov    %esi,%eax
  8023ad:	e8 71 ff ff ff       	call   802323 <_pipeisclosed>
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	75 41                	jne    8023f7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8023b6:	e8 69 ed ff ff       	call   801124 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023bb:	8b 43 04             	mov    0x4(%ebx),%eax
  8023be:	8b 0b                	mov    (%ebx),%ecx
  8023c0:	8d 51 20             	lea    0x20(%ecx),%edx
  8023c3:	39 d0                	cmp    %edx,%eax
  8023c5:	73 e2                	jae    8023a9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023ca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023ce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023d1:	99                   	cltd   
  8023d2:	c1 ea 1b             	shr    $0x1b,%edx
  8023d5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8023d8:	83 e1 1f             	and    $0x1f,%ecx
  8023db:	29 d1                	sub    %edx,%ecx
  8023dd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8023e1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8023e5:	83 c0 01             	add    $0x1,%eax
  8023e8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023eb:	83 c7 01             	add    $0x1,%edi
  8023ee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023f1:	75 c8                	jne    8023bb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8023f3:	89 f8                	mov    %edi,%eax
  8023f5:	eb 05                	jmp    8023fc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8023fc:	83 c4 1c             	add    $0x1c,%esp
  8023ff:	5b                   	pop    %ebx
  802400:	5e                   	pop    %esi
  802401:	5f                   	pop    %edi
  802402:	5d                   	pop    %ebp
  802403:	c3                   	ret    

00802404 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
  802407:	57                   	push   %edi
  802408:	56                   	push   %esi
  802409:	53                   	push   %ebx
  80240a:	83 ec 1c             	sub    $0x1c,%esp
  80240d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802410:	89 3c 24             	mov    %edi,(%esp)
  802413:	e8 08 f1 ff ff       	call   801520 <fd2data>
  802418:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80241a:	be 00 00 00 00       	mov    $0x0,%esi
  80241f:	eb 3d                	jmp    80245e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802421:	85 f6                	test   %esi,%esi
  802423:	74 04                	je     802429 <devpipe_read+0x25>
				return i;
  802425:	89 f0                	mov    %esi,%eax
  802427:	eb 43                	jmp    80246c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802429:	89 da                	mov    %ebx,%edx
  80242b:	89 f8                	mov    %edi,%eax
  80242d:	e8 f1 fe ff ff       	call   802323 <_pipeisclosed>
  802432:	85 c0                	test   %eax,%eax
  802434:	75 31                	jne    802467 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802436:	e8 e9 ec ff ff       	call   801124 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80243b:	8b 03                	mov    (%ebx),%eax
  80243d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802440:	74 df                	je     802421 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802442:	99                   	cltd   
  802443:	c1 ea 1b             	shr    $0x1b,%edx
  802446:	01 d0                	add    %edx,%eax
  802448:	83 e0 1f             	and    $0x1f,%eax
  80244b:	29 d0                	sub    %edx,%eax
  80244d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802452:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802455:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802458:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80245b:	83 c6 01             	add    $0x1,%esi
  80245e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802461:	75 d8                	jne    80243b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802463:	89 f0                	mov    %esi,%eax
  802465:	eb 05                	jmp    80246c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802467:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80246c:	83 c4 1c             	add    $0x1c,%esp
  80246f:	5b                   	pop    %ebx
  802470:	5e                   	pop    %esi
  802471:	5f                   	pop    %edi
  802472:	5d                   	pop    %ebp
  802473:	c3                   	ret    

00802474 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	56                   	push   %esi
  802478:	53                   	push   %ebx
  802479:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80247c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80247f:	89 04 24             	mov    %eax,(%esp)
  802482:	e8 b0 f0 ff ff       	call   801537 <fd_alloc>
  802487:	89 c2                	mov    %eax,%edx
  802489:	85 d2                	test   %edx,%edx
  80248b:	0f 88 4d 01 00 00    	js     8025de <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802491:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802498:	00 
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a7:	e8 97 ec ff ff       	call   801143 <sys_page_alloc>
  8024ac:	89 c2                	mov    %eax,%edx
  8024ae:	85 d2                	test   %edx,%edx
  8024b0:	0f 88 28 01 00 00    	js     8025de <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8024b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024b9:	89 04 24             	mov    %eax,(%esp)
  8024bc:	e8 76 f0 ff ff       	call   801537 <fd_alloc>
  8024c1:	89 c3                	mov    %eax,%ebx
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	0f 88 fe 00 00 00    	js     8025c9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024cb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024d2:	00 
  8024d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e1:	e8 5d ec ff ff       	call   801143 <sys_page_alloc>
  8024e6:	89 c3                	mov    %eax,%ebx
  8024e8:	85 c0                	test   %eax,%eax
  8024ea:	0f 88 d9 00 00 00    	js     8025c9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	89 04 24             	mov    %eax,(%esp)
  8024f6:	e8 25 f0 ff ff       	call   801520 <fd2data>
  8024fb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024fd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802504:	00 
  802505:	89 44 24 04          	mov    %eax,0x4(%esp)
  802509:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802510:	e8 2e ec ff ff       	call   801143 <sys_page_alloc>
  802515:	89 c3                	mov    %eax,%ebx
  802517:	85 c0                	test   %eax,%eax
  802519:	0f 88 97 00 00 00    	js     8025b6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80251f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802522:	89 04 24             	mov    %eax,(%esp)
  802525:	e8 f6 ef ff ff       	call   801520 <fd2data>
  80252a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802531:	00 
  802532:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802536:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80253d:	00 
  80253e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802542:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802549:	e8 49 ec ff ff       	call   801197 <sys_page_map>
  80254e:	89 c3                	mov    %eax,%ebx
  802550:	85 c0                	test   %eax,%eax
  802552:	78 52                	js     8025a6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802554:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802569:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80256f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802572:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802577:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	89 04 24             	mov    %eax,(%esp)
  802584:	e8 87 ef ff ff       	call   801510 <fd2num>
  802589:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80258c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80258e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802591:	89 04 24             	mov    %eax,(%esp)
  802594:	e8 77 ef ff ff       	call   801510 <fd2num>
  802599:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80259c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a4:	eb 38                	jmp    8025de <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8025a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025b1:	e8 34 ec ff ff       	call   8011ea <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8025b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c4:	e8 21 ec ff ff       	call   8011ea <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d7:	e8 0e ec ff ff       	call   8011ea <sys_page_unmap>
  8025dc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8025de:	83 c4 30             	add    $0x30,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5e                   	pop    %esi
  8025e3:	5d                   	pop    %ebp
  8025e4:	c3                   	ret    

008025e5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025e5:	55                   	push   %ebp
  8025e6:	89 e5                	mov    %esp,%ebp
  8025e8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f5:	89 04 24             	mov    %eax,(%esp)
  8025f8:	e8 89 ef ff ff       	call   801586 <fd_lookup>
  8025fd:	89 c2                	mov    %eax,%edx
  8025ff:	85 d2                	test   %edx,%edx
  802601:	78 15                	js     802618 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	89 04 24             	mov    %eax,(%esp)
  802609:	e8 12 ef ff ff       	call   801520 <fd2data>
	return _pipeisclosed(fd, p);
  80260e:	89 c2                	mov    %eax,%edx
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	e8 0b fd ff ff       	call   802323 <_pipeisclosed>
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	66 90                	xchg   %ax,%ax
  80261e:	66 90                	xchg   %ax,%ax

00802620 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802623:	b8 00 00 00 00       	mov    $0x0,%eax
  802628:	5d                   	pop    %ebp
  802629:	c3                   	ret    

0080262a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
  80262d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802630:	c7 44 24 04 93 31 80 	movl   $0x803193,0x4(%esp)
  802637:	00 
  802638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80263b:	89 04 24             	mov    %eax,(%esp)
  80263e:	e8 e4 e6 ff ff       	call   800d27 <strcpy>
	return 0;
}
  802643:	b8 00 00 00 00       	mov    $0x0,%eax
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	57                   	push   %edi
  80264e:	56                   	push   %esi
  80264f:	53                   	push   %ebx
  802650:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802656:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80265b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802661:	eb 31                	jmp    802694 <devcons_write+0x4a>
		m = n - tot;
  802663:	8b 75 10             	mov    0x10(%ebp),%esi
  802666:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802668:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80266b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802670:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802673:	89 74 24 08          	mov    %esi,0x8(%esp)
  802677:	03 45 0c             	add    0xc(%ebp),%eax
  80267a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80267e:	89 3c 24             	mov    %edi,(%esp)
  802681:	e8 3e e8 ff ff       	call   800ec4 <memmove>
		sys_cputs(buf, m);
  802686:	89 74 24 04          	mov    %esi,0x4(%esp)
  80268a:	89 3c 24             	mov    %edi,(%esp)
  80268d:	e8 e4 e9 ff ff       	call   801076 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802692:	01 f3                	add    %esi,%ebx
  802694:	89 d8                	mov    %ebx,%eax
  802696:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802699:	72 c8                	jb     802663 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80269b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8026a1:	5b                   	pop    %ebx
  8026a2:	5e                   	pop    %esi
  8026a3:	5f                   	pop    %edi
  8026a4:	5d                   	pop    %ebp
  8026a5:	c3                   	ret    

008026a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8026ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8026b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026b5:	75 07                	jne    8026be <devcons_read+0x18>
  8026b7:	eb 2a                	jmp    8026e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8026b9:	e8 66 ea ff ff       	call   801124 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8026be:	66 90                	xchg   %ax,%ax
  8026c0:	e8 cf e9 ff ff       	call   801094 <sys_cgetc>
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	74 f0                	je     8026b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	78 16                	js     8026e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8026cd:	83 f8 04             	cmp    $0x4,%eax
  8026d0:	74 0c                	je     8026de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8026d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d5:	88 02                	mov    %al,(%edx)
	return 1;
  8026d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8026dc:	eb 05                	jmp    8026e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8026de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    

008026e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8026eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8026f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8026f8:	00 
  8026f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026fc:	89 04 24             	mov    %eax,(%esp)
  8026ff:	e8 72 e9 ff ff       	call   801076 <sys_cputs>
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <getchar>:

int
getchar(void)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80270c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802713:	00 
  802714:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80271b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802722:	e8 f3 f0 ff ff       	call   80181a <read>
	if (r < 0)
  802727:	85 c0                	test   %eax,%eax
  802729:	78 0f                	js     80273a <getchar+0x34>
		return r;
	if (r < 1)
  80272b:	85 c0                	test   %eax,%eax
  80272d:	7e 06                	jle    802735 <getchar+0x2f>
		return -E_EOF;
	return c;
  80272f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802733:	eb 05                	jmp    80273a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802735:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80273a:	c9                   	leave  
  80273b:	c3                   	ret    

0080273c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
  80273f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802742:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802745:	89 44 24 04          	mov    %eax,0x4(%esp)
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	89 04 24             	mov    %eax,(%esp)
  80274f:	e8 32 ee ff ff       	call   801586 <fd_lookup>
  802754:	85 c0                	test   %eax,%eax
  802756:	78 11                	js     802769 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802761:	39 10                	cmp    %edx,(%eax)
  802763:	0f 94 c0             	sete   %al
  802766:	0f b6 c0             	movzbl %al,%eax
}
  802769:	c9                   	leave  
  80276a:	c3                   	ret    

0080276b <opencons>:

int
opencons(void)
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
  80276e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802771:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802774:	89 04 24             	mov    %eax,(%esp)
  802777:	e8 bb ed ff ff       	call   801537 <fd_alloc>
		return r;
  80277c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80277e:	85 c0                	test   %eax,%eax
  802780:	78 40                	js     8027c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802782:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802789:	00 
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802791:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802798:	e8 a6 e9 ff ff       	call   801143 <sys_page_alloc>
		return r;
  80279d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	78 1f                	js     8027c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8027a3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027b8:	89 04 24             	mov    %eax,(%esp)
  8027bb:	e8 50 ed ff ff       	call   801510 <fd2num>
  8027c0:	89 c2                	mov    %eax,%edx
}
  8027c2:	89 d0                	mov    %edx,%eax
  8027c4:	c9                   	leave  
  8027c5:	c3                   	ret    

008027c6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027c6:	55                   	push   %ebp
  8027c7:	89 e5                	mov    %esp,%ebp
  8027c9:	56                   	push   %esi
  8027ca:	53                   	push   %ebx
  8027cb:	83 ec 10             	sub    $0x10,%esp
  8027ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8027d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8027d7:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8027d9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8027de:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8027e1:	89 04 24             	mov    %eax,(%esp)
  8027e4:	e8 70 eb ff ff       	call   801359 <sys_ipc_recv>
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	75 1e                	jne    80280b <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  8027ed:	85 db                	test   %ebx,%ebx
  8027ef:	74 0a                	je     8027fb <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8027f1:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8027f6:	8b 40 74             	mov    0x74(%eax),%eax
  8027f9:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8027fb:	85 f6                	test   %esi,%esi
  8027fd:	74 22                	je     802821 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8027ff:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802804:	8b 40 78             	mov    0x78(%eax),%eax
  802807:	89 06                	mov    %eax,(%esi)
  802809:	eb 16                	jmp    802821 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80280b:	85 f6                	test   %esi,%esi
  80280d:	74 06                	je     802815 <ipc_recv+0x4f>
				*perm_store = 0;
  80280f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802815:	85 db                	test   %ebx,%ebx
  802817:	74 10                	je     802829 <ipc_recv+0x63>
				*from_env_store=0;
  802819:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80281f:	eb 08                	jmp    802829 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802821:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802826:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802829:	83 c4 10             	add    $0x10,%esp
  80282c:	5b                   	pop    %ebx
  80282d:	5e                   	pop    %esi
  80282e:	5d                   	pop    %ebp
  80282f:	c3                   	ret    

00802830 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
  802833:	57                   	push   %edi
  802834:	56                   	push   %esi
  802835:	53                   	push   %ebx
  802836:	83 ec 1c             	sub    $0x1c,%esp
  802839:	8b 75 0c             	mov    0xc(%ebp),%esi
  80283c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80283f:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802842:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802844:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802849:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80284c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802850:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802854:	89 74 24 04          	mov    %esi,0x4(%esp)
  802858:	8b 45 08             	mov    0x8(%ebp),%eax
  80285b:	89 04 24             	mov    %eax,(%esp)
  80285e:	e8 d3 ea ff ff       	call   801336 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802863:	eb 1c                	jmp    802881 <ipc_send+0x51>
	{
		sys_yield();
  802865:	e8 ba e8 ff ff       	call   801124 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80286a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80286e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802872:	89 74 24 04          	mov    %esi,0x4(%esp)
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	89 04 24             	mov    %eax,(%esp)
  80287c:	e8 b5 ea ff ff       	call   801336 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802881:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802884:	74 df                	je     802865 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802886:	83 c4 1c             	add    $0x1c,%esp
  802889:	5b                   	pop    %ebx
  80288a:	5e                   	pop    %esi
  80288b:	5f                   	pop    %edi
  80288c:	5d                   	pop    %ebp
  80288d:	c3                   	ret    

0080288e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80288e:	55                   	push   %ebp
  80288f:	89 e5                	mov    %esp,%ebp
  802891:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802894:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802899:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80289c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028a2:	8b 52 50             	mov    0x50(%edx),%edx
  8028a5:	39 ca                	cmp    %ecx,%edx
  8028a7:	75 0d                	jne    8028b6 <ipc_find_env+0x28>
			return envs[i].env_id;
  8028a9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8028ac:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8028b1:	8b 40 40             	mov    0x40(%eax),%eax
  8028b4:	eb 0e                	jmp    8028c4 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8028b6:	83 c0 01             	add    $0x1,%eax
  8028b9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028be:	75 d9                	jne    802899 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8028c0:	66 b8 00 00          	mov    $0x0,%ax
}
  8028c4:	5d                   	pop    %ebp
  8028c5:	c3                   	ret    

008028c6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
  8028c9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028cc:	89 d0                	mov    %edx,%eax
  8028ce:	c1 e8 16             	shr    $0x16,%eax
  8028d1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028d8:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028dd:	f6 c1 01             	test   $0x1,%cl
  8028e0:	74 1d                	je     8028ff <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8028e2:	c1 ea 0c             	shr    $0xc,%edx
  8028e5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028ec:	f6 c2 01             	test   $0x1,%dl
  8028ef:	74 0e                	je     8028ff <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028f1:	c1 ea 0c             	shr    $0xc,%edx
  8028f4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028fb:	ef 
  8028fc:	0f b7 c0             	movzwl %ax,%eax
}
  8028ff:	5d                   	pop    %ebp
  802900:	c3                   	ret    
  802901:	66 90                	xchg   %ax,%ax
  802903:	66 90                	xchg   %ax,%ax
  802905:	66 90                	xchg   %ax,%ax
  802907:	66 90                	xchg   %ax,%ax
  802909:	66 90                	xchg   %ax,%ax
  80290b:	66 90                	xchg   %ax,%ax
  80290d:	66 90                	xchg   %ax,%ax
  80290f:	90                   	nop

00802910 <__udivdi3>:
  802910:	55                   	push   %ebp
  802911:	57                   	push   %edi
  802912:	56                   	push   %esi
  802913:	83 ec 0c             	sub    $0xc,%esp
  802916:	8b 44 24 28          	mov    0x28(%esp),%eax
  80291a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80291e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802922:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802926:	85 c0                	test   %eax,%eax
  802928:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80292c:	89 ea                	mov    %ebp,%edx
  80292e:	89 0c 24             	mov    %ecx,(%esp)
  802931:	75 2d                	jne    802960 <__udivdi3+0x50>
  802933:	39 e9                	cmp    %ebp,%ecx
  802935:	77 61                	ja     802998 <__udivdi3+0x88>
  802937:	85 c9                	test   %ecx,%ecx
  802939:	89 ce                	mov    %ecx,%esi
  80293b:	75 0b                	jne    802948 <__udivdi3+0x38>
  80293d:	b8 01 00 00 00       	mov    $0x1,%eax
  802942:	31 d2                	xor    %edx,%edx
  802944:	f7 f1                	div    %ecx
  802946:	89 c6                	mov    %eax,%esi
  802948:	31 d2                	xor    %edx,%edx
  80294a:	89 e8                	mov    %ebp,%eax
  80294c:	f7 f6                	div    %esi
  80294e:	89 c5                	mov    %eax,%ebp
  802950:	89 f8                	mov    %edi,%eax
  802952:	f7 f6                	div    %esi
  802954:	89 ea                	mov    %ebp,%edx
  802956:	83 c4 0c             	add    $0xc,%esp
  802959:	5e                   	pop    %esi
  80295a:	5f                   	pop    %edi
  80295b:	5d                   	pop    %ebp
  80295c:	c3                   	ret    
  80295d:	8d 76 00             	lea    0x0(%esi),%esi
  802960:	39 e8                	cmp    %ebp,%eax
  802962:	77 24                	ja     802988 <__udivdi3+0x78>
  802964:	0f bd e8             	bsr    %eax,%ebp
  802967:	83 f5 1f             	xor    $0x1f,%ebp
  80296a:	75 3c                	jne    8029a8 <__udivdi3+0x98>
  80296c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802970:	39 34 24             	cmp    %esi,(%esp)
  802973:	0f 86 9f 00 00 00    	jbe    802a18 <__udivdi3+0x108>
  802979:	39 d0                	cmp    %edx,%eax
  80297b:	0f 82 97 00 00 00    	jb     802a18 <__udivdi3+0x108>
  802981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802988:	31 d2                	xor    %edx,%edx
  80298a:	31 c0                	xor    %eax,%eax
  80298c:	83 c4 0c             	add    $0xc,%esp
  80298f:	5e                   	pop    %esi
  802990:	5f                   	pop    %edi
  802991:	5d                   	pop    %ebp
  802992:	c3                   	ret    
  802993:	90                   	nop
  802994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802998:	89 f8                	mov    %edi,%eax
  80299a:	f7 f1                	div    %ecx
  80299c:	31 d2                	xor    %edx,%edx
  80299e:	83 c4 0c             	add    $0xc,%esp
  8029a1:	5e                   	pop    %esi
  8029a2:	5f                   	pop    %edi
  8029a3:	5d                   	pop    %ebp
  8029a4:	c3                   	ret    
  8029a5:	8d 76 00             	lea    0x0(%esi),%esi
  8029a8:	89 e9                	mov    %ebp,%ecx
  8029aa:	8b 3c 24             	mov    (%esp),%edi
  8029ad:	d3 e0                	shl    %cl,%eax
  8029af:	89 c6                	mov    %eax,%esi
  8029b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8029b6:	29 e8                	sub    %ebp,%eax
  8029b8:	89 c1                	mov    %eax,%ecx
  8029ba:	d3 ef                	shr    %cl,%edi
  8029bc:	89 e9                	mov    %ebp,%ecx
  8029be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8029c2:	8b 3c 24             	mov    (%esp),%edi
  8029c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8029c9:	89 d6                	mov    %edx,%esi
  8029cb:	d3 e7                	shl    %cl,%edi
  8029cd:	89 c1                	mov    %eax,%ecx
  8029cf:	89 3c 24             	mov    %edi,(%esp)
  8029d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8029d6:	d3 ee                	shr    %cl,%esi
  8029d8:	89 e9                	mov    %ebp,%ecx
  8029da:	d3 e2                	shl    %cl,%edx
  8029dc:	89 c1                	mov    %eax,%ecx
  8029de:	d3 ef                	shr    %cl,%edi
  8029e0:	09 d7                	or     %edx,%edi
  8029e2:	89 f2                	mov    %esi,%edx
  8029e4:	89 f8                	mov    %edi,%eax
  8029e6:	f7 74 24 08          	divl   0x8(%esp)
  8029ea:	89 d6                	mov    %edx,%esi
  8029ec:	89 c7                	mov    %eax,%edi
  8029ee:	f7 24 24             	mull   (%esp)
  8029f1:	39 d6                	cmp    %edx,%esi
  8029f3:	89 14 24             	mov    %edx,(%esp)
  8029f6:	72 30                	jb     802a28 <__udivdi3+0x118>
  8029f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029fc:	89 e9                	mov    %ebp,%ecx
  8029fe:	d3 e2                	shl    %cl,%edx
  802a00:	39 c2                	cmp    %eax,%edx
  802a02:	73 05                	jae    802a09 <__udivdi3+0xf9>
  802a04:	3b 34 24             	cmp    (%esp),%esi
  802a07:	74 1f                	je     802a28 <__udivdi3+0x118>
  802a09:	89 f8                	mov    %edi,%eax
  802a0b:	31 d2                	xor    %edx,%edx
  802a0d:	e9 7a ff ff ff       	jmp    80298c <__udivdi3+0x7c>
  802a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a18:	31 d2                	xor    %edx,%edx
  802a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a1f:	e9 68 ff ff ff       	jmp    80298c <__udivdi3+0x7c>
  802a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a28:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a2b:	31 d2                	xor    %edx,%edx
  802a2d:	83 c4 0c             	add    $0xc,%esp
  802a30:	5e                   	pop    %esi
  802a31:	5f                   	pop    %edi
  802a32:	5d                   	pop    %ebp
  802a33:	c3                   	ret    
  802a34:	66 90                	xchg   %ax,%ax
  802a36:	66 90                	xchg   %ax,%ax
  802a38:	66 90                	xchg   %ax,%ax
  802a3a:	66 90                	xchg   %ax,%ax
  802a3c:	66 90                	xchg   %ax,%ax
  802a3e:	66 90                	xchg   %ax,%ax

00802a40 <__umoddi3>:
  802a40:	55                   	push   %ebp
  802a41:	57                   	push   %edi
  802a42:	56                   	push   %esi
  802a43:	83 ec 14             	sub    $0x14,%esp
  802a46:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a4a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a4e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802a52:	89 c7                	mov    %eax,%edi
  802a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a58:	8b 44 24 30          	mov    0x30(%esp),%eax
  802a5c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a60:	89 34 24             	mov    %esi,(%esp)
  802a63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a67:	85 c0                	test   %eax,%eax
  802a69:	89 c2                	mov    %eax,%edx
  802a6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a6f:	75 17                	jne    802a88 <__umoddi3+0x48>
  802a71:	39 fe                	cmp    %edi,%esi
  802a73:	76 4b                	jbe    802ac0 <__umoddi3+0x80>
  802a75:	89 c8                	mov    %ecx,%eax
  802a77:	89 fa                	mov    %edi,%edx
  802a79:	f7 f6                	div    %esi
  802a7b:	89 d0                	mov    %edx,%eax
  802a7d:	31 d2                	xor    %edx,%edx
  802a7f:	83 c4 14             	add    $0x14,%esp
  802a82:	5e                   	pop    %esi
  802a83:	5f                   	pop    %edi
  802a84:	5d                   	pop    %ebp
  802a85:	c3                   	ret    
  802a86:	66 90                	xchg   %ax,%ax
  802a88:	39 f8                	cmp    %edi,%eax
  802a8a:	77 54                	ja     802ae0 <__umoddi3+0xa0>
  802a8c:	0f bd e8             	bsr    %eax,%ebp
  802a8f:	83 f5 1f             	xor    $0x1f,%ebp
  802a92:	75 5c                	jne    802af0 <__umoddi3+0xb0>
  802a94:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a98:	39 3c 24             	cmp    %edi,(%esp)
  802a9b:	0f 87 e7 00 00 00    	ja     802b88 <__umoddi3+0x148>
  802aa1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802aa5:	29 f1                	sub    %esi,%ecx
  802aa7:	19 c7                	sbb    %eax,%edi
  802aa9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802aad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ab1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ab5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ab9:	83 c4 14             	add    $0x14,%esp
  802abc:	5e                   	pop    %esi
  802abd:	5f                   	pop    %edi
  802abe:	5d                   	pop    %ebp
  802abf:	c3                   	ret    
  802ac0:	85 f6                	test   %esi,%esi
  802ac2:	89 f5                	mov    %esi,%ebp
  802ac4:	75 0b                	jne    802ad1 <__umoddi3+0x91>
  802ac6:	b8 01 00 00 00       	mov    $0x1,%eax
  802acb:	31 d2                	xor    %edx,%edx
  802acd:	f7 f6                	div    %esi
  802acf:	89 c5                	mov    %eax,%ebp
  802ad1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ad5:	31 d2                	xor    %edx,%edx
  802ad7:	f7 f5                	div    %ebp
  802ad9:	89 c8                	mov    %ecx,%eax
  802adb:	f7 f5                	div    %ebp
  802add:	eb 9c                	jmp    802a7b <__umoddi3+0x3b>
  802adf:	90                   	nop
  802ae0:	89 c8                	mov    %ecx,%eax
  802ae2:	89 fa                	mov    %edi,%edx
  802ae4:	83 c4 14             	add    $0x14,%esp
  802ae7:	5e                   	pop    %esi
  802ae8:	5f                   	pop    %edi
  802ae9:	5d                   	pop    %ebp
  802aea:	c3                   	ret    
  802aeb:	90                   	nop
  802aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802af0:	8b 04 24             	mov    (%esp),%eax
  802af3:	be 20 00 00 00       	mov    $0x20,%esi
  802af8:	89 e9                	mov    %ebp,%ecx
  802afa:	29 ee                	sub    %ebp,%esi
  802afc:	d3 e2                	shl    %cl,%edx
  802afe:	89 f1                	mov    %esi,%ecx
  802b00:	d3 e8                	shr    %cl,%eax
  802b02:	89 e9                	mov    %ebp,%ecx
  802b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b08:	8b 04 24             	mov    (%esp),%eax
  802b0b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b0f:	89 fa                	mov    %edi,%edx
  802b11:	d3 e0                	shl    %cl,%eax
  802b13:	89 f1                	mov    %esi,%ecx
  802b15:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b19:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b1d:	d3 ea                	shr    %cl,%edx
  802b1f:	89 e9                	mov    %ebp,%ecx
  802b21:	d3 e7                	shl    %cl,%edi
  802b23:	89 f1                	mov    %esi,%ecx
  802b25:	d3 e8                	shr    %cl,%eax
  802b27:	89 e9                	mov    %ebp,%ecx
  802b29:	09 f8                	or     %edi,%eax
  802b2b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b2f:	f7 74 24 04          	divl   0x4(%esp)
  802b33:	d3 e7                	shl    %cl,%edi
  802b35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b39:	89 d7                	mov    %edx,%edi
  802b3b:	f7 64 24 08          	mull   0x8(%esp)
  802b3f:	39 d7                	cmp    %edx,%edi
  802b41:	89 c1                	mov    %eax,%ecx
  802b43:	89 14 24             	mov    %edx,(%esp)
  802b46:	72 2c                	jb     802b74 <__umoddi3+0x134>
  802b48:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b4c:	72 22                	jb     802b70 <__umoddi3+0x130>
  802b4e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802b52:	29 c8                	sub    %ecx,%eax
  802b54:	19 d7                	sbb    %edx,%edi
  802b56:	89 e9                	mov    %ebp,%ecx
  802b58:	89 fa                	mov    %edi,%edx
  802b5a:	d3 e8                	shr    %cl,%eax
  802b5c:	89 f1                	mov    %esi,%ecx
  802b5e:	d3 e2                	shl    %cl,%edx
  802b60:	89 e9                	mov    %ebp,%ecx
  802b62:	d3 ef                	shr    %cl,%edi
  802b64:	09 d0                	or     %edx,%eax
  802b66:	89 fa                	mov    %edi,%edx
  802b68:	83 c4 14             	add    $0x14,%esp
  802b6b:	5e                   	pop    %esi
  802b6c:	5f                   	pop    %edi
  802b6d:	5d                   	pop    %ebp
  802b6e:	c3                   	ret    
  802b6f:	90                   	nop
  802b70:	39 d7                	cmp    %edx,%edi
  802b72:	75 da                	jne    802b4e <__umoddi3+0x10e>
  802b74:	8b 14 24             	mov    (%esp),%edx
  802b77:	89 c1                	mov    %eax,%ecx
  802b79:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b7d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802b81:	eb cb                	jmp    802b4e <__umoddi3+0x10e>
  802b83:	90                   	nop
  802b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b88:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802b8c:	0f 82 0f ff ff ff    	jb     802aa1 <__umoddi3+0x61>
  802b92:	e9 1a ff ff ff       	jmp    802ab1 <__umoddi3+0x71>
