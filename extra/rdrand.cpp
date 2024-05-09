extern int is_nan();
double random_number;

extern "C" double getrandom()
{
    asm(".intel_syntax noprefix");
    asm("push r15");
    asm("rng:");
    asm("rdrand r15");
    asm("mov rax, 0");
    asm("mov rdi, r15");
    asm("call is_nan"); // implementation not included
    asm("cmp rax, 0");
    asm("je rng");
    asm("shl r15, 12");
    asm("shr r15, 12");
    asm("mov rax, 0x3FF0000000000000");
    asm("or r15, rax");
    asm("mov random_number, r15");
    asm("pop r15");
    asm(".att_syntax noprefix");
    return random_number;
}