#include "plumber.h"

int sporth_butbr(sporth_stack *stack, void *ud)
{
    plumber_data *pd = ud;
    SPFLOAT input;
    SPFLOAT output;
    SPFLOAT freq;
    SPFLOAT bw;
    sp_butbr *butbr;

    switch(pd->mode) {
        case PLUMBER_CREATE:

#ifdef DEBUG_MODE
            fprintf(stderr, "butbr: Creating\n");
#endif

            sp_butbr_create(&butbr);
            plumber_add_ugen(pd, SPORTH_BUTBR, butbr);
            if(sporth_check_args(stack, "fff") != SPORTH_OK) {
                fprintf(stderr,"Not enough arguments for butbr\n");
                stack->error++;
                return PLUMBER_NOTOK;
            }
            sporth_stack_push_float(stack, 0);
            break;
        case PLUMBER_INIT:

#ifdef DEBUG_MODE
            fprintf(stderr, "butbr: Initialising\n");
#endif

            bw = sporth_stack_pop_float(stack);
            freq = sporth_stack_pop_float(stack);
            input = sporth_stack_pop_float(stack);
            butbr = pd->last->ud;
            sp_butbr_init(pd->sp, butbr);
            sporth_stack_push_float(stack, 0);
            break;
        case PLUMBER_COMPUTE:
            bw = sporth_stack_pop_float(stack);
            freq = sporth_stack_pop_float(stack);
            input = sporth_stack_pop_float(stack);
            butbr = pd->last->ud;
            butbr->freq = freq;
            butbr->bw = bw;
            sp_butbr_compute(pd->sp, butbr, &input, &output);
            sporth_stack_push_float(stack, output);
            break;
        case PLUMBER_DESTROY:
            butbr = pd->last->ud;
            sp_butbr_destroy(&butbr);
            break;
        default:
            fprintf(stderr, "butbr: Uknown mode!\n");
            break;
    }
    return PLUMBER_OK;
}
