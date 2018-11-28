# PURPOSE: Program to manage memory usage - allocates
# and deallocates memory as requested
# 
# NOTES: The programs using these routines will ask
# for a certain size of memory. We actually
# use more than that size, but we put it
# at the beginning, before the pointer
# we hand back. We add a size field and
# an DISPONIVEL/INDISPONIVEL marker. So, the
# memory looks like this
#
# # ########################################################
# # DISPONIVEL Marker#Size of memory#Actual memory locations#
# # ########################################################
#									^--Returned pointer
# points here
# The pointer we return only points to the actual
# locations requested to make it easier for the
# calling program. It also allows us to change our
# structure without the calling program having to
# change at all.


.section .data

# # #####GLOBAL VARIABLES########
# This points to the beginning of the memory we are managing
inicio_heap: .long 0

# This points to one location past the memory we are managing
brk_atual: .long 0

# # ####STRUCTURE INFORMATION####
# size of space for memory region header
.equ cabecalho_tam, 8
# Location of the "DISPONIVEL" flag in the header
.equ HDR_AVAIL_OFFSET, 0
# Location of the size field in the header
.equ HDR_SIZE_OFFSET, 4

# # #########CONSTANTS###########
.equ INDISPONIVEL, 0 # This is the number we will use to mark
					# space that has been given out
.equ DISPONIVEL, 1   # This is the number we will use to mark
					# space that has been returned, and is
					# DISPONIVEL for giving
.equ SYS_BRK, 45 	# system call number for the break
					# system call
.equ LINUX_SYSCALL, 0x80 # make system calls easier to read

.section .text

# # ########FUNCTIONS############
# # allocate_init##
# PURPOSE: call this function to initialize the
# functions (specifically, this sets inicio_heap and
# brk_atual). This has no parameters and no
# return value.
.globl allocate_init
.type allocate_init,@function
allocate_init:
pushq %rbp 	# standard function stuff
movq %rsp, %rbp

# If the brk system call is called with 0 in %rbx, it
# returns the last valid usable address
movq $SYS_BRK, %rax 	# find out where the break is
movq $0, %rbx
int $LINUX_SYSCALL
incq %rax 		# %rax now has the last valid
				# address, and we want the
				# memory location after that

movq %rax, brk_atual # store the current break

movq %rax, inicio_heap # store the current break as our
					  # first address. This will cause
					  # the allocate function to get
					  # more memory from Linux the
					  # first time it is run
movq %rbp, %rsp
popq %rbp # exit the function
ret
# # ###END OF FUNCTION#######


# # allocate##
# PURPOSE:This function is used to grab a section of
# memory. It checks to see if there are any
# free blocks, and, if not, it asks Linux
# for a new one.
# 
# PARAMETERS: This function has one parameter - the size
# of the memory block we want to allocate
# 
# RETURN VALUE:
# This function returns the address of the
# allocated memory in %rax. If there is no
# memory DISPONIVEL, it will return 0 in %rax
# 
# # ####PROCESSING########
# Variables used:
# 
# %rcx - hold the size of the requested memory
# (first/only parameter)
# %rax - current memory region being examined
# %rbx - current break position
# %rdx - size of current memory region
# 
# We scan through each memory region starting with
# inicio_heap. We look at the size of each one, and if
# it has been allocated. If it’s big enough for the
# requested size, and its DISPONIVEL, it grabs that one.
# If it does not find a region large enough, it asks
# Linux for more memory. In that case, it moves
# brk_atual up
.globl allocate
.type allocate,@function
.equ ST_MEM_SIZE, 8 # stack position of the memory size
					# to allocate
allocate:
pushq %rbp 	# standard function stuff
movq %rsp, %rbp

movq ST_MEM_SIZE(%rbp), %rcx # %rcx will hold the size
							 # we are looking for (which is the first
							 # and only parameter)

movq inicio_heap, %rax # %rax will hold the current
					  # search location
movq brk_atual, %rbx # %rbx will hold the current
						 # break
alloc_loop_begin: # here we iterate through each
				  # memory region
cmpq %rbx, %rax # need more memory if these are equal
je move_break


# grab the size of this memory
movq HDR_SIZE_OFFSET(%rax), %rdx
# If the space is INDISPONIVEL, go to the
cmpq $INDISPONIVEL, HDR_AVAIL_OFFSET(%rax)
je next_location # next one

cmpq %rdx, %rcx   # If the space is DISPONIVEL, compare
jle allocate_here # the size to the needed size. If its
				  # big enough, go to allocate_here

next_location:
addq $cabecalho_tam, %rax # The total size of the memory
addq %rdx, %rax 		# region is the sum of the size
						# requested (currently stored
						# in %rdx), plus another 8 bytes
						# for the header (4 for the
						# DISPONIVEL/INDISPONIVEL flag,
						# and 4 for the size of the
						# region). So, adding %rdx and $8
						# to %rax will get the address
						# of the next memory region

jmp alloc_loop_begin # go look at the next location

allocate_here: # if we’ve made it here,
			   # that means that the
			   # region header of the region
			   # to allocate is in %rax
			   # mark space as INDISPONIVEL
movq $INDISPONIVEL, HDR_AVAIL_OFFSET(%rax)
addq $cabecalho_tam, %rax # move %rax past the header to
						# the usable memory (since
						# that’s what we return)

movq %rbp, %rsp # return from the function
popq %rbp
ret 


move_break: # if we’ve made it here, that
			# means that we have exhausted
			# all addressable memory, and
			# we need to ask for more.
			# %rbx holds the currentChapter 9. Intermediate Memory Topics
			# endpoint of the data,
			# and %rcx holds its size


			# we need to increase %rbx to
			# where we _want_ memory
			# to end, so we
addq $cabecalho_tam, %rbx # add space for the headers
						# structure
addq %rcx, %rbx 	# add space to the break for
					# the data requested
					# now its time to ask Linux
					# for more memory

pushq %rax # save needed registers
pushq %rcx
pushq %rbx 
movq $SYS_BRK, %rax # reset the break (%rbx has
					# the requested break point)
int $LINUX_SYSCALL
				# under normal conditions, this should
				# return the new break in %rax, which
				# will be either 0 if it fails, or
				# it will be equal to or larger than
				# we asked for. We don’t care
				# in this program where it actually
				# sets the break, so as long as %rax
				# isn’t 0, we don’t care what it is

cmpq $0, %rax # check for error conditions
je  error 
popq %rbx # restore saved registers
popq %rcx 
popq %rax

# set this memory as INDISPONIVEL, since we’re about to
# give it away
movq $INDISPONIVEL, HDR_AVAIL_OFFSET(%rax)
# set the size of the memory
movq %rcx, HDR_SIZE_OFFSET(%rax)
# move %rax to the actual start of usable memory.
# %rax now holds the return value
addq $cabecalho_tam, %rax
movq %rbx, brk_atual # save the new break
movq %rbp, %rsp # return the function
popq %rbp 
ret 

error:
movq $0, %rax  # on error, we return zero
movq %rbp, %rsp
popq %rbp
ret

# # ######END OF FUNCTION########

# # deallocate##
# PURPOSE:
# The purpose of this function is to give back
# a region of memory to the pool after we’re done
# using it.
# 
# PARAMETERS:
# The only parameter is the address of the memory
# we want to return to the memory pool.
# 
# RETURN VALUE:
# There is no return value
# 
# PROCESSING:
# If you remember, we actually hand the program the
# start of the memory that they can use, which is
# 8 storage locations after the actual start of the
# memory region. All we have to do is go back
# 8 locations and mark that memory as DISPONIVEL,
# so that the allocate function knows it can use it.
.globl deallocate
.type deallocate,@function
# stack position of the memory region to free
.equ ST_MEMORY_SEG, 4
deallocate:
# since the function is so simple, we
# don’t need any of the fancy function stuff
# get the address of the memory to free
# (normally this is 8(%rbp), but since
# we didn’t push %rbp or move %rsp to
# %rbp, we can just do 4(%rsp)
movq ST_MEMORY_SEG(%rsp), %rax
# get the pointer to the real beginning of the memory
subq $cabecalho_tam, %rax
# mark it as DISPONIVEL
movq $DISPONIVEL, HDR_AVAIL_OFFSET(%rax)
# return
ret
# # ######END OF FUNCTION##########