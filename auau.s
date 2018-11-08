
a.out: formato do arquivo elf64-x86-64


Desmontagem da seção .init:

0000000000000558 <_init>:
 558:	48 83 ec 08          	sub    $0x8,%rsp
 55c:	48 8b 05 85 0a 20 00 	mov    0x200a85(%rip),%rax        # 200fe8 <__gmon_start__>
 563:	48 85 c0             	test   %rax,%rax
 566:	74 02                	je     56a <_init+0x12>
 568:	ff d0                	callq  *%rax
 56a:	48 83 c4 08          	add    $0x8,%rsp
 56e:	c3                   	retq   

Desmontagem da seção .plt:

0000000000000570 <.plt>:
 570:	ff 35 42 0a 20 00    	pushq  0x200a42(%rip)        # 200fb8 <_GLOBAL_OFFSET_TABLE_+0x8>
 576:	ff 25 44 0a 20 00    	jmpq   *0x200a44(%rip)        # 200fc0 <_GLOBAL_OFFSET_TABLE_+0x10>
 57c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000000580 <printf@plt>:
 580:	ff 25 42 0a 20 00    	jmpq   *0x200a42(%rip)        # 200fc8 <printf@GLIBC_2.2.5>
 586:	68 00 00 00 00       	pushq  $0x0
 58b:	e9 e0 ff ff ff       	jmpq   570 <.plt>

0000000000000590 <sbrk@plt>:
 590:	ff 25 3a 0a 20 00    	jmpq   *0x200a3a(%rip)        # 200fd0 <sbrk@GLIBC_2.2.5>
 596:	68 01 00 00 00       	pushq  $0x1
 59b:	e9 d0 ff ff ff       	jmpq   570 <.plt>

Desmontagem da seção .plt.got:

00000000000005a0 <__cxa_finalize@plt>:
 5a0:	ff 25 52 0a 20 00    	jmpq   *0x200a52(%rip)        # 200ff8 <__cxa_finalize@GLIBC_2.2.5>
 5a6:	66 90                	xchg   %ax,%ax

Desmontagem da seção .text:

00000000000005b0 <_start>:
 5b0:	31 ed                	xor    %ebp,%ebp
 5b2:	49 89 d1             	mov    %rdx,%r9
 5b5:	5e                   	pop    %rsi
 5b6:	48 89 e2             	mov    %rsp,%rdx
 5b9:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
 5bd:	50                   	push   %rax
 5be:	54                   	push   %rsp
 5bf:	4c 8d 05 ca 01 00 00 	lea    0x1ca(%rip),%r8        # 790 <__libc_csu_fini>
 5c6:	48 8d 0d 53 01 00 00 	lea    0x153(%rip),%rcx        # 720 <__libc_csu_init>
 5cd:	48 8d 3d e6 00 00 00 	lea    0xe6(%rip),%rdi        # 6ba <main>
 5d4:	ff 15 06 0a 20 00    	callq  *0x200a06(%rip)        # 200fe0 <__libc_start_main@GLIBC_2.2.5>
 5da:	f4                   	hlt    
 5db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000005e0 <deregister_tm_clones>:
 5e0:	48 8d 3d 31 0a 20 00 	lea    0x200a31(%rip),%rdi        # 201018 <__TMC_END__>
 5e7:	55                   	push   %rbp
 5e8:	48 8d 05 29 0a 20 00 	lea    0x200a29(%rip),%rax        # 201018 <__TMC_END__>
 5ef:	48 39 f8             	cmp    %rdi,%rax
 5f2:	48 89 e5             	mov    %rsp,%rbp
 5f5:	74 19                	je     610 <deregister_tm_clones+0x30>
 5f7:	48 8b 05 da 09 20 00 	mov    0x2009da(%rip),%rax        # 200fd8 <_ITM_deregisterTMCloneTable>
 5fe:	48 85 c0             	test   %rax,%rax
 601:	74 0d                	je     610 <deregister_tm_clones+0x30>
 603:	5d                   	pop    %rbp
 604:	ff e0                	jmpq   *%rax
 606:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 60d:	00 00 00 
 610:	5d                   	pop    %rbp
 611:	c3                   	retq   
 612:	0f 1f 40 00          	nopl   0x0(%rax)
 616:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 61d:	00 00 00 

0000000000000620 <register_tm_clones>:
 620:	48 8d 3d f1 09 20 00 	lea    0x2009f1(%rip),%rdi        # 201018 <__TMC_END__>
 627:	48 8d 35 ea 09 20 00 	lea    0x2009ea(%rip),%rsi        # 201018 <__TMC_END__>
 62e:	55                   	push   %rbp
 62f:	48 29 fe             	sub    %rdi,%rsi
 632:	48 89 e5             	mov    %rsp,%rbp
 635:	48 c1 fe 03          	sar    $0x3,%rsi
 639:	48 89 f0             	mov    %rsi,%rax
 63c:	48 c1 e8 3f          	shr    $0x3f,%rax
 640:	48 01 c6             	add    %rax,%rsi
 643:	48 d1 fe             	sar    %rsi
 646:	74 18                	je     660 <register_tm_clones+0x40>
 648:	48 8b 05 a1 09 20 00 	mov    0x2009a1(%rip),%rax        # 200ff0 <_ITM_registerTMCloneTable>
 64f:	48 85 c0             	test   %rax,%rax
 652:	74 0c                	je     660 <register_tm_clones+0x40>
 654:	5d                   	pop    %rbp
 655:	ff e0                	jmpq   *%rax
 657:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 65e:	00 00 
 660:	5d                   	pop    %rbp
 661:	c3                   	retq   
 662:	0f 1f 40 00          	nopl   0x0(%rax)
 666:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 66d:	00 00 00 

0000000000000670 <__do_global_dtors_aux>:
 670:	80 3d a1 09 20 00 00 	cmpb   $0x0,0x2009a1(%rip)        # 201018 <__TMC_END__>
 677:	75 2f                	jne    6a8 <__do_global_dtors_aux+0x38>
 679:	48 83 3d 77 09 20 00 	cmpq   $0x0,0x200977(%rip)        # 200ff8 <__cxa_finalize@GLIBC_2.2.5>
 680:	00 
 681:	55                   	push   %rbp
 682:	48 89 e5             	mov    %rsp,%rbp
 685:	74 0c                	je     693 <__do_global_dtors_aux+0x23>
 687:	48 8b 3d 7a 09 20 00 	mov    0x20097a(%rip),%rdi        # 201008 <__dso_handle>
 68e:	e8 0d ff ff ff       	callq  5a0 <__cxa_finalize@plt>
 693:	e8 48 ff ff ff       	callq  5e0 <deregister_tm_clones>
 698:	c6 05 79 09 20 00 01 	movb   $0x1,0x200979(%rip)        # 201018 <__TMC_END__>
 69f:	5d                   	pop    %rbp
 6a0:	c3                   	retq   
 6a1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 6a8:	f3 c3                	repz retq 
 6aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000000006b0 <frame_dummy>:
 6b0:	55                   	push   %rbp
 6b1:	48 89 e5             	mov    %rsp,%rbp
 6b4:	5d                   	pop    %rbp
 6b5:	e9 66 ff ff ff       	jmpq   620 <register_tm_clones>

00000000000006ba <main>:
*/

#include  <stdio.h>
#include  <unistd.h>
char *str1 = "brk: %d";
int  main(int argc , char **argv) {
 6ba:	55                   	push   %rbp
 6bb:	48 89 e5             	mov    %rsp,%rbp
 6be:	48 83 ec 20          	sub    $0x20,%rsp
 6c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
 6c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int *x = sbrk(0);
 6c9:	bf 00 00 00 00       	mov    $0x0,%edi
 6ce:	e8 bd fe ff ff       	callq  590 <sbrk@plt>
 6d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	int *z;
		printf("%p\n",x);
 6d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 6db:	48 89 c6             	mov    %rax,%rsi
 6de:	48 8d 3d c7 00 00 00 	lea    0xc7(%rip),%rdi        # 7ac <_IO_stdin_used+0xc>
 6e5:	b8 00 00 00 00       	mov    $0x0,%eax
 6ea:	e8 91 fe ff ff       	callq  580 <printf@plt>

		__asm__("movq 12, %rax");
 6ef:	48 8b 04 25 0c 00 00 	mov    0xc,%rax
 6f6:	00 
		__asm__("movq $0, %rdi");
 6f7:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
		__asm__("syscall");
 6fe:	0f 05                	syscall 
		__asm__("movq %rax, %rdi");
 700:	48 89 c7             	mov    %rax,%rdi
		__asm__("movq %rax, %rsi");
 703:	48 89 c6             	mov    %rax,%rsi
		__asm__("call printf");
 706:	e8 00 00 00 00       	callq  70b <main+0x51>
 70b:	b8 00 00 00 00       	mov    $0x0,%eax

	/*printf("brk: %p\n, );*/


 710:	c9                   	leaveq 
 711:	c3                   	retq   
 712:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 719:	00 00 00 
 71c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000000720 <__libc_csu_init>:
 720:	41 57                	push   %r15
 722:	41 56                	push   %r14
 724:	49 89 d7             	mov    %rdx,%r15
 727:	41 55                	push   %r13
 729:	41 54                	push   %r12
 72b:	4c 8d 25 6e 06 20 00 	lea    0x20066e(%rip),%r12        # 200da0 <__frame_dummy_init_array_entry>
 732:	55                   	push   %rbp
 733:	48 8d 2d 6e 06 20 00 	lea    0x20066e(%rip),%rbp        # 200da8 <__init_array_end>
 73a:	53                   	push   %rbx
 73b:	41 89 fd             	mov    %edi,%r13d
 73e:	49 89 f6             	mov    %rsi,%r14
 741:	4c 29 e5             	sub    %r12,%rbp
 744:	48 83 ec 08          	sub    $0x8,%rsp
 748:	48 c1 fd 03          	sar    $0x3,%rbp
 74c:	e8 07 fe ff ff       	callq  558 <_init>
 751:	48 85 ed             	test   %rbp,%rbp
 754:	74 20                	je     776 <__libc_csu_init+0x56>
 756:	31 db                	xor    %ebx,%ebx
 758:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 75f:	00 
 760:	4c 89 fa             	mov    %r15,%rdx
 763:	4c 89 f6             	mov    %r14,%rsi
 766:	44 89 ef             	mov    %r13d,%edi
 769:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
 76d:	48 83 c3 01          	add    $0x1,%rbx
 771:	48 39 dd             	cmp    %rbx,%rbp
 774:	75 ea                	jne    760 <__libc_csu_init+0x40>
 776:	48 83 c4 08          	add    $0x8,%rsp
 77a:	5b                   	pop    %rbx
 77b:	5d                   	pop    %rbp
 77c:	41 5c                	pop    %r12
 77e:	41 5d                	pop    %r13
 780:	41 5e                	pop    %r14
 782:	41 5f                	pop    %r15
 784:	c3                   	retq   
 785:	90                   	nop
 786:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 78d:	00 00 00 

0000000000000790 <__libc_csu_fini>:
 790:	f3 c3                	repz retq 

Desmontagem da seção .fini:

0000000000000794 <_fini>:
 794:	48 83 ec 08          	sub    $0x8,%rsp
 798:	48 83 c4 08          	add    $0x8,%rsp
 79c:	c3                   	retq   
